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
    var avatarPath: String?
//    var avatarPath: String
    
    var favoriteMovies: [Movie]?
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case avatar
        
        enum AvatarType: String, CodingKey {
            case tmdb
            
            enum AvatarPath: String, CodingKey {
                case avatarPath = "avatar_path"
            }
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        
        let avatarContainer = try container.nestedContainer(keyedBy: CodingKeys.AvatarType.self, forKey: .avatar)
        let tmdbAvatarContainer = try avatarContainer.nestedContainer(keyedBy: CodingKeys.AvatarType.AvatarPath.self, forKey: .tmdb)
        if let avatarPath = try tmdbAvatarContainer.decodeIfPresent(String.self, forKey: .avatarPath) {
            self.avatarPath = "https://image.tmdb.org/t/p/w500" + avatarPath
        }
    }
}
