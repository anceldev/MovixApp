//
//  Language.swift
//  MovixApp
//
//  Created by Ancel Dev account on 3/2/25.
//

import Foundation

struct Language: Codable {
    var iso3691: String
    var englishName: String
    
    enum CodingKeys: String, CodingKey {
        case iso3691 = "iso_639_1"
        case englishName = "english_name"
    }
}
