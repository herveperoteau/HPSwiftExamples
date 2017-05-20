import Foundation

protocol HttpHeaderRequest {
  init(url:String)
  func getHeader(_ header:String, callback:@escaping (String, String?) -> Void )
  func execute()
}

// PROXY PATTERN RESTRICTING ACCESS
class AccessControlProxy : HttpHeaderRequest {
  // WRAPPER PATTERN
  fileprivate let wrappedObject: HttpHeaderRequest
  
  required init(url:String) {
    wrappedObject = HttpHeaderRequestProxy(url: url)
  }
  
  func getHeader(_ header: String, callback:@escaping (String, String?) -> Void) {
    wrappedObject.getHeader(header, callback: callback)
  }
  
  func execute() {
    if UserAuthentication.sharedInstance.authenticated {
      wrappedObject.execute()
    } else {
      fatalError("Unauthorized")
    }
  }
}

// PROXY PATTERN WITH CACHE
private class HttpHeaderRequestProxy : HttpHeaderRequest {
  
  let url:String
  var headersRequired:[String: (String, String?) -> Void]
  
  required init(url: String) {
    self.url = url
    self.headersRequired = Dictionary<String, (String, String?) -> Void>()
  }
  
  func getHeader(_ header: String, callback: @escaping (String, String?) -> Void) {
    self.headersRequired[header] = callback
  }
  
  func execute() {
    let nsUrl = URL(string: url)
    let request = URLRequest(url: nsUrl!)
    URLSession.shared.dataTask(with: request,
                               completionHandler: {data, response, error in
                                if let httpResponse = response as? HTTPURLResponse {
                                  let headers = httpResponse.allHeaderFields as! [String: String]
                                  
                                  for (header, callback) in self.headersRequired {
                                    callback(header, headers[header])
                                  }
                                }
    }).resume()
  }
}
