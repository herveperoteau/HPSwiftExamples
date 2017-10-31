/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import StoreKit

class AuthorizationManager {
    // 1
    static func authorize(
        completionIfAuthorized
        authorizedCompletion: @escaping () -> Void,
        ifUnauthorized
        unauthorizedCompletion: @escaping () -> Void) {
        // 2
        SKCloudServiceController.requestAuthorization {
            authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                // 3
                DispatchQueue.main.async {
                    authorizedCompletion()
                }
            case .restricted, .denied:
                // 4
                DispatchQueue.main.async {
                    unauthorizedCompletion()
                }
            default:
                break
            }
        }
    }
    
    // 1
    fileprivate static let downloadDeveloperTokenOperation = DownloadDeveloperTokenOperation()
    private static let requestCountryCodeOperation = RequestCountryCodeOperation()
    // 2
    private static let musicAPIQueue: OperationQueue = {
        let queue = OperationQueue()
        // 3
        queue.addOperation(downloadDeveloperTokenOperation)
        queue.addOperation(requestCountryCodeOperation)
        return queue
    }()
    
    // 4
    static func withAPIData(completion: @escaping (String, String) -> Void) {
        // 5
        let operation = BlockOperation {
            // 6
            guard
                let developerToken = downloadDeveloperTokenOperation.developerToken,
                let countryCode = requestCountryCodeOperation.countryCode
                else { return }
            // 7
            completion(developerToken, countryCode)
        }
        // 8
        operation.addDependency(downloadDeveloperTokenOperation)
        operation.addDependency(requestCountryCodeOperation)
        // 9
        musicAPIQueue.addOperation(operation)
    }
    
    
}


private let developerTokenServerUrl = URL(string: "https://example.com/devtoken")!

private class MockURLProtocol: URLProtocol {
  static var fakeResponse = ""  // Your developer token will go here
  static var fakeHeaders: [String: String] = [:]
  static var fakeStatusCode = 200
  static var urlToHandle: URL?

  override func startLoading() {
    let client = self.client!
    let response = HTTPURLResponse(url: request.url!, statusCode: MockURLProtocol.fakeStatusCode, httpVersion: "HTTP/1.1", headerFields: MockURLProtocol.fakeHeaders)!
    client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    client.urlProtocol(self, didLoad: MockURLProtocol.fakeResponse.data(using: .utf8)!)
    client.urlProtocolDidFinishLoading(self)
  }

  override func stopLoading() {
  }

  override class func canInit(with request: URLRequest) -> Bool {
    return (request.url == developerTokenServerUrl)
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
}

class DownloadDeveloperTokenOperation: AsyncOperation {
    // 1
    var developerToken: String?
    override func main() {
        // 2
        URLProtocol.registerClass(MockURLProtocol.self)
        // 3
        let task = URLSession.shared
            .dataTask(with: developerTokenServerUrl) {
                data, response, error in
                guard let data = data else {
                    self.state = .finished
                    return
                }
                // 4
                self.developerToken = String(data: data, encoding: .utf8)
                // 5
                self.state = .finished
        }
        task.resume()
    }
}

// 1
class RequestCountryCodeOperation: AsyncOperation {
    // 2
    var countryCode: String?
    override func main() {
        // 3
        SKCloudServiceController().requestStorefrontCountryCode {
            result, error in
            self.countryCode = result
            self.state = .finished
        }
    }
}



