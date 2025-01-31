//
//  URLConstants.swift
//  MovixApp
//
//  Created by Ancel Dev account on 24/1/25.
//

import Foundation


enum MediaType: String {
    case movie
    case tv
}
enum TimeWindow: String {
    case day
    case week
}

enum Endpoints {
    
    case movie(String) //
    case trending(MediaType, TimeWindow, Int) //
    case search(String, MediaType)
    case person(String)
    case genre(MediaType)
    case cast(String, MediaType)
    
    private static let apiKey = "4bd71d332c3d3c219fe01c8d465ba03a"
    private static let baseUrlPath = "https://api.themoviedb.org/3/"
    
    var endpoint: String {
        switch self {
        case .movie: return "movie"
        case .trending: return "trending/"
        case .search: return "search/"
        case .person: return "person/"
        case .genre: return "genre/"
        case .cast: return "credits"
        }
    }
    
    var url: URL {
        switch self {
        case .movie(let movieId):
            URL(string: Self.baseUrlPath + self.endpoint + "/\(movieId)?api_key=\(Self.apiKey)")!
        case .trending(let media, let timeWindow, let page):
            URL(string: Self.baseUrlPath + self.endpoint + "\(media.rawValue)/\(timeWindow.rawValue)?api_key=\(Self.apiKey)&page=\(page)")!
        case .search(let query, let mediaType):
            URL(string: Self.baseUrlPath + self.endpoint + "\(mediaType.rawValue)?api_key=\(Self.apiKey)&\(query)")!
        case .person(let personId):
            URL(string: Self.baseUrlPath + self.endpoint + "\(personId)?api_key=\(Self.apiKey)")!
        case .genre(let mediaType): URL(string: Self.baseUrlPath + mediaType.rawValue + "/list?api_key=\(Self.apiKey)")!
        case .cast(let mediaId, let mediaType):
            URL(string: Self.baseUrlPath + mediaType.rawValue + "/\(mediaId)/\(self.endpoint)?api_key=\(Self.apiKey)")!
        }
    }
}
