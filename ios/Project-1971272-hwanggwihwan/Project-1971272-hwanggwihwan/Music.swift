//
//  Music.swift
//  Project-1971272-hwanggwihwan
//
//  Created by hwang on 2024/06/01.
//

import Foundation
import SwiftUI

struct Music: Hashable, Codable{
    var artist_name: String
    var track_name: String
    var release_date: Int
    var genre: String
    var lyrics: String
    var len: Int
    var topic: String
    
    init(artist_name: String, track_name: String, release_date: Int,
         genre: String, lyrics: String, len: Int, topic: String) {
        self.artist_name = artist_name
        self.track_name = track_name
        self.release_date = release_date
        self.genre = genre
        self.lyrics = lyrics
        self.len = len
        self.topic = topic
    }
}
