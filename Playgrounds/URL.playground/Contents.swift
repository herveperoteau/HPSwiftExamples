//: Playground - URL: a place where people can play

import UIKit


// MARK: - URLComponents

let API = "https://eonet.sci.gsfc.nasa.gov/api/v2.1"
let categoriesEndpoint = "/categories"

if let url = URL(string: API)?.appendingPathComponent(categoriesEndpoint) {

    print ("url=\(url)")
    
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    print (components!)
    
    let query : [String: String] = ["param1" : "value1",
                                    "param2" : "value2"]

    components!.queryItems = query.flatMap { (key, value) in
        guard let v = value as? CustomStringConvertible else {
            print("bad value \(value)")
            return nil
        }
        print("create QueryItem \(key):\(v.description)")
        return URLQueryItem(name: key, value: v.description)
    }
    
    let finalURL = components!.url
    print ("finalURL=\(finalURL)")
}


