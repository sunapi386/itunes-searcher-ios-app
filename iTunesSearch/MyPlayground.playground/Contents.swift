//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport // so it runs continuously
// async support
PlaygroundPage.current.needsIndefiniteExecution = true

// Just get a URL
let baseURL = "https://itunes.apple.com/search?parameterkeyvalue"
if var components = URLComponents(string: baseURL) {
    components.queryItems?.append(URLQueryItem(name: "term", value: "lady gaga"))
    components.queryItems?.append(URLQueryItem(name: "term", value: "lady gaga"))
    components.url
    let session = URLSession.shared
    if let url = components.url {
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, resp: URLResponse?, err: Error?) in
            if let isErrored = err {
                debugPrint(err)
            }
            if let unwrptData = data {
                let jsonDict = try! JSONSerialization.jsonObject(with: unwrptData, options: []) as? [AnyHashable:Any]
                if let allTracks = jsonDict?["results"] as? [[AnyHashable:Any]] {
                    debugPrint(allTracks[1])
                }
            }
        })
        task.resume()
    }
}

