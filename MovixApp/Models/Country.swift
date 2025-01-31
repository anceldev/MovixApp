//
//  Country.swift
//  MovixApp
//
//  Created by Ancel Dev account on 27/1/25.
//

import Foundation

// list of countries (ISO 3166-1 tags) used throughout TMDB.
/**
    "iso_3166_1": "AD",
    "english_name": "Andorra",
    "native_name": "Andorra"
 */

struct Country: Codable {
    var iso31661: String
    var englishName: String
    var nativeName: String
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case englishName = "english_name"
        case nativeName = "native_name"
    }
    
    init() {
        self.iso31661 = "US"
        self.englishName = "United States of America"
        self.nativeName = "United States"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.iso31661 = try container.decode(String.self, forKey: .iso31661)
        self.englishName = try container.decode(String.self, forKey: .englishName)
        self.nativeName = try container.decode(String.self, forKey: .nativeName)
    }
}
