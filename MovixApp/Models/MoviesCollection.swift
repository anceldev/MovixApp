//
//  TrandingMovies.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import Foundation

struct ReviewCollection: Codable {
    let id: Int
    let page: Int
    let results: [Review]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct PageCollection<T:Codable>: Codable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MoviesCollection: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.page = try values.decode(Int.self, forKey: .page)
        self.results = try values.decode([Movie].self, forKey: .results)
        self.totalPages = try values.decode(Int.self, forKey: .totalPages)
        self.totalResults = try values.decode(Int.self, forKey: .totalResults)
    }
    
    func encode(to encoder: any Encoder) throws {
        
    }
}
