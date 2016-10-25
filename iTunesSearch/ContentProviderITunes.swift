//
//  ContentProvider.swift
//  iTunesSearch
//
//  Created by Woody Lidstone on 2016-02-24.
//  Copyright © 2016 Apple | Software University. All rights reserved.
//

/* This class maintains an array of `matchingObjects`.
   It takes a `searchTerm` and performs async activity of fetching 
   and deserializing the content.
 
   Use: Set a `searchTerm`, then call `performSearch()`
 */

import Foundation

// Used to limit the search requests to a particular media type
enum MediaKindRequested: String {
    case all
    case movie
    case podcast
    case music
    case musicVideo
    case audiobook
    case shortFilm
    case tvShow
    case software
    case ebook
}


class ContentProviderITunes {
    
    var searchTerm: String?
    var mediaKind = MediaKindRequested.all
    
    let baseURLString = "https://itunes.apple.com/search?parameterkeyvalue"
    
    // URL Session
    let session = URLSession.shared
    var task: URLSessionDataTask?
    
    // Will be nil initially, and if no search is found (no network availability etc.)
    var searchResults: [MediaItem]?
    
    /// Returns a URL using the baseURLString with the search terms / query appended to
    func parameterizedURL() -> URL {
        var baseURLComponents = URLComponents(string: baseURLString)! // Force unwrap because the URL is hardcoded, which means it is known to be good.
        
        let searchQueryItem = URLQueryItem(name: "term", value: searchTerm!)
        baseURLComponents.queryItems?.append(searchQueryItem)
        
        // Use a specific media type
        let mediaKindQueryItem = URLQueryItem(name: "entity", value: mediaKind.rawValue)
        baseURLComponents.queryItems?.append(mediaKindQueryItem)

        return baseURLComponents.url!
    }


    func performSearch() {
        // Guard allows for pre-condition checks
        guard self.searchTerm != nil else {
            print("Unable to search because there is no search term")
            return
        }
        
        // Abort network activity currrently in progress, if we're running/suspended
        if task?.state == .running || task?.state == .suspended {
            task?.cancel()
            print("Stopping existing task")
        }
        
        // Create a new task
        task = session.dataTask(with: parameterizedURL()) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                return
            }
            
            do {
                self.searchResults = try MediaCollection(data: data)?.items
                            
                // Broadcast a notification that the model data has changed. 
                // Ensure it's on mainthread, since UI will be updated.
                DispatchQueue.main.async() {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "ContentProviderReceivedData"), object: nil)
                }
                
            } catch {
                print("Error initializing the media collection from JSON \(error)")
                self.searchResults = nil
            }
        }
        
        task?.resume()
    }

}
