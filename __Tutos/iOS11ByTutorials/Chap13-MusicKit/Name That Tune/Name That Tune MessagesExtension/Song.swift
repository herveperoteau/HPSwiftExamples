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

enum MusicError: Error {
    case invalidUrl
    case noData
    case jsonDecoding
    case networkError(innerError: Error?)
}

struct Song {
  let title: String
  let artist: String
  let id: String
  let artworkUrl: URL
  
    init(id: String,
         title: String,
         artist: String,
         artworkUrl: URL) {
        
        self.title = title
        self.artist = artist
        self.id = id
        self.artworkUrl = artworkUrl
    }
    
  init?(queryItems: [URLQueryItem]) {
    guard
        let title = queryItems.first(where: { queryItem in
            queryItem.name == Song.AttributesKeys.title.stringValue })?.value,
        let artist = queryItems.first(where: { queryItem in
            queryItem.name == Song.AttributesKeys.artist.stringValue })?.value,
        let id = queryItems.first(where: { queryItem in
            queryItem.name == Song.CodingKeys.id.stringValue })?.value,
        let artworkUrlString = queryItems.first(where: { queryItem in
            queryItem.name == Song.ArtworkKeys.url.stringValue })?.value
        else { return nil }
    self.title = title
    self.artist = artist
    self.id = id
    
    // TODO: replace {w} and {h} with the size we want to get
    guard let artworkUrl = URL(string: artworkUrlString) else { return nil }
    self.artworkUrl = artworkUrl
  }
  
  var queryItems: [URLQueryItem] {
    var items: [URLQueryItem] = []
    items.append(URLQueryItem(name: Song.AttributesKeys.title.stringValue, value: title))
    items.append(URLQueryItem(name: Song.AttributesKeys.artist.stringValue, value: artist))
    items.append(URLQueryItem(name: Song.CodingKeys.id.stringValue, value: id))
    items.append(URLQueryItem(name: Song.ArtworkKeys.url.stringValue, value: artworkUrl.absoluteString))
    return items
  }
}

extension Song: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case attributes
    }
    
    enum AttributesKeys: String, CodingKey {
        case title = "name"
        case artist = "artistName"
        case artwork
    }
    
    enum ArtworkKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        let topContainer = try decoder.container(keyedBy: CodingKeys.self)
        let id = try topContainer.decode(String.self, forKey: .id)
        let attributes = try topContainer.nestedContainer(keyedBy: AttributesKeys.self, forKey: .attributes)
        let title = try attributes.decode(String.self, forKey: .title)
        let artist = try attributes.decode(String.self, forKey: .artist)
        
        let artwork = try attributes.nestedContainer(keyedBy: ArtworkKeys.self, forKey: .artwork)
        let artworkUrlTemplate = try artwork.decode(String.self, forKey: .url)
        let urlString = artworkUrlTemplate
            .replacingOccurrences(of: "{w}", with: "150")
            .replacingOccurrences(of: "{h}", with: "150")
        
        guard let url = URL(string: urlString) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [ArtworkKeys.url],
                    debugDescription: "Artwork URL not in URL format"))
        }
        
        self.init(id: id, title: title, artist: artist, artworkUrl: url)
    }
}

extension Song {
    
    // 1
    static func top40Songs(completion: @escaping ([Song]?, Error?) -> Void) {
        // 2
        AuthorizationManager.withAPIData {
            developerToken, countryCode in
            // 3
            let urlString = """
            https://api.music.apple.com/\
            v1/catalog/\(countryCode)/charts?types=songs&\
            chart=most-played&limit=40
            """
            guard let url = URL(string: urlString) else {
                completion(nil, MusicError.invalidUrl)
                return
            }
            var request = URLRequest(url: url)
            // 4
            request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
            // 5
            let task = URLSession.shared.dataTask(with: request) {
                data, _, error in
                // 6
                let completeOnMain: ([Song]?, Error?) -> Void = {
                    songs, error in
                    DispatchQueue.main.async {
                        completion(songs, error)
                    }
                }
                // 7
                if let error = error {
                    completeOnMain(nil, MusicError.networkError(innerError: error))
                    return
                }
                // 8
                guard let data = data else {
                    completeOnMain(nil, MusicError.noData)
                    return
                }
                // 9
                guard let jsonData =
                    // 10
                    try? JSONSerialization.jsonObject(with: data),
                    let dataDictionary = jsonData as? [String: Any],
                    let results = dataDictionary["results"] as? [String:Any],
                    let songsArray = results["songs"] as? [[String: Any]],
                    let songsItem = songsArray.first,
                    let songsDictionary = songsItem["data"],
                    // 11
                    let songsData = try? JSONSerialization.data(withJSONObject: songsDictionary),
                    // 12
                    let songs = try? JSONDecoder().decode([Song].self, from: songsData)
                    else {
                        completeOnMain(nil, MusicError.jsonDecoding)
                        return
                }
                
                completeOnMain(songs, nil)
            }
            task.resume()
        }
    }
    
}
