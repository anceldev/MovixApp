//
//  Account.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/8/24.
//

import Foundation

struct Account: Decodable {
    var id: Int
    var name: String
    var username: String
    
    var favoriteMovies: [Movie]?
}
