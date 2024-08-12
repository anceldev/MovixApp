//
//  Genre.swift
//  MovixApp
//
//  Created by Ancel Dev account on 7/8/24.
//

import Foundation


struct Genres: Decodable {
    var genres: [Genre]
}
struct Genre: Identifiable, Decodable {
    var id: Int
    var name: String
}
