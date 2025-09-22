//
//  MusicData.swift
//  Project-1971272-hwanggwihwan
//
//  Created by hwang on 2024/06/01.
//

import Foundation

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            // Check if jsonObject is a dictionary
            guard var jsonArray = jsonObject as? [[String: Any]] else {
                fatalError("Couldn't parse \(filename) as array of dictionaries.")
            }
            
            // Convert track_name from Int to String if necessary
            for i in 0..<jsonArray.count {
                if let trackName = jsonArray[i]["track_name"] as? Int {
                    jsonArray[i]["track_name"] = String(trackName)
                }
                if let artistName = jsonArray[i]["artist_name"] as? Int {
                    jsonArray[i]["artist_name"] = String(artistName)
                }
            }
            
            let modifiedData = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: modifiedData)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
}
