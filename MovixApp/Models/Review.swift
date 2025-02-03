//
//  Review.swift
//  MovixApp
//
//  Created by Ancel Dev account on 3/2/25.
//

import Foundation

struct Review: Codable, Identifiable {
    let author: String
    let authorDetails: Author
    let id: String
    let content: String
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case author, id, content, createdAt = "created_at", authorDetails = "author_details"
    }
    
    init(id: String, author: String, authorDetails: Author, content: String, createdAt: Date? = .now) {
        self.author = author
        self.authorDetails = authorDetails
        self.id = id
        self.content = content
        self.createdAt = createdAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decode(String.self, forKey: .author)
        self.id = try container.decode(String.self, forKey: .id)
        self.content = try container.decode(String.self, forKey: .content)
        self.authorDetails = try container.decode(Author.self, forKey: .authorDetails)
        
        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: createdAtString) {
                self.createdAt = date
            } else {
                self.createdAt = nil
            }
        }
        else {
            self.createdAt = nil
        }
    }
}

struct Author: Codable {
    let name: String
    let username: String
    let avatarPath: URL?
    
    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
    }
    
    init(name: String, username: String, avatarPath: String? = nil) {
        self.name = name
        self.username = username
        self.avatarPath = URL(string: "https://image.tmdb.org/t/p/w632\(avatarPath ?? "")")
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        
        let avatarPathId = try container.decodeIfPresent(String.self, forKey: .avatarPath)
        self.avatarPath = URL(string: "https://image.tmdb.org/t/p/w500\(avatarPathId ?? "")")
    }
}

extension Review {
    static let preview = Review(
        id: "1",
        author: "whatever",
        authorDetails: .init(name: "whatever", username: "what_ever", avatarPath: "/zDsL1byzwuiJvjhqW2hT6yw5OxU.jpg"),
        content: "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, voluptatem! Quasi, voluptates! Quo, voluptatem! Quo, voluptatem!",
        createdAt: .now
    )
}
