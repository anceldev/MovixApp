//
//  ShortMovie.swift
//  MovixApp
//
//  Created by Ancel Dev account on 1/2/25.
//

import Foundation

struct ShortMovie: Codable, Identifiable, Equatable {
    var id: Int
    var title: String
    var releaseDate: Date?
    var posterPath: String?
    var backdropPath: String?
    var voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
    }
    
    init(id: Int, title: String, posterPathId: String? = nil, backdropPathId: String? = nil, voteAvarage: Double? = nil) {
        self.id = id
        self.title = title
        self.posterPath = posterPathId
        self.backdropPath = backdropPathId
        self.voteAverage = voteAvarage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        
        if let releasedOn = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.releaseDate = dateFormatter.date(from: releasedOn)
        }
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
    }
}

extension ShortMovie {
    static let preview: ShortMovie = .init(
        id: 533535,
        title: "Deadpool & Wolverine",
        posterPathId: "8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
        backdropPathId: "9l1eZiJHmhr5jIlthMdJN5WYoff.jpg",
        voteAvarage: 8.202
    )
}
