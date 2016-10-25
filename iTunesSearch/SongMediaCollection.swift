//
//  Song.swift
//  iTunesSearch
//
//  Copyright © 2016 Apple | Software University. All rights reserved.
//

import Foundation


// Used in the JSON returned by the server to indicate the kind of media
enum MediaKindReturned: String {
    case book
    case album
    case coachedAudio = "coached-audio"
    case featureMovie = "feature-movie"
    case interactiveBooklet = "interactive-booklet"
    case musicVideo = "music-video"
    case pdfPodcast = "pdf-podcast"
    case podcastEpisode = "podcast-episode"
    case softwarePackage = "software-package"
    case song
    case tvEpisode = "tv-episode"
    case artist
    
    init?(dict: [AnyHashable:Any]) {
        if let reportedType = dict["kind"] as? String {
            self.init(rawValue: reportedType)
        } else {
            return nil
        }
    }
}

// Represents one track, one music video, one book
struct MediaItem {
    let displayName: String!
    var previewUrl: URL?
    let kind: MediaKindReturned!
    
    init(dict: [AnyHashable: Any]) {
        displayName = dict["trackName"] as! String
        kind = MediaKindReturned(dict: dict)
        
        if let previewUrlString = dict["previewUrl"] as? String, let url = URLComponents(string: previewUrlString)?.url {
            previewUrl = url
        }
    }
}


// A collection of returned values from the server
// Convert JSON data to an array of Media Items
struct MediaCollection {
    var items: [MediaItem]!
    
    init?(data: Data) throws {
        do {
            if let topLevelDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable:Any] {
                if let allMediaDictionaries = topLevelDictionary["results"] as? [[AnyHashable:Any]] {
                    
                    items = [MediaItem]()
                    for currentDict in allMediaDictionaries {
                        let mediaItem = MediaItem(dict: currentDict)
                        items.append(mediaItem)
                    }
                }
            }
        } catch {
            print("Error deserializing json data")
            throw error
        }
    }
}



