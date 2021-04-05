//
//  Item.swift
//  idus
//
//  Created by jc.kim on 3/25/21.
//

import Foundation

struct Tracks: Decodable {
    let results: [Track]
}

struct Track: Decodable {
    let trackName: String
    let screenshotUrls: [String]? //imageurls
    let fileSizeBytes: String
    let version: String
    let releaseNotes: String?
    let description: String?
    let genres: [String]? //tag
    
    static let dummy = Track(trackName: "trackName",
                             screenshotUrls: nil,
                             fileSizeBytes: "fileSizeBytes",
                             version: "version",
                             releaseNotes: nil,
                             description: nil,
                             genres: nil)
}
