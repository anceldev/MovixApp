////
////  Movie.swift
////  MovixApp
////
////  Created by Ancel Dev account on 25/7/24.
////

import Foundation


struct Movie: Decodable, Identifiable, Hashable {
    var id: Int
    var title: String
    var originalTitle: String?
    var overview: String?
    var runtime: Int?
    var releaseDate: Date?
    var posterPath: URL?
    var backdropPath: URL?
    var budget: Double?
    var homepageURL: URL?
    var popularity: Double?
    var voteAverage: Double?
    var voteCount: Int?
    var isAdult: Bool?

    
    var duration: String {
        guard let runtime else {
            return ""
        }
        return "\(runtime/60)h\(runtime%60)min"
    }
    
    init(id: Int,
         title: String,
         originalTitle: String? = nil,
         overview: String? = nil,
         runtime: Int? = nil,
         releaseDate: Date? = nil,
         posterPath: URL? = nil,
         backdropPath: URL? = nil,
         budget: Double? = nil,
         homepageURL: URL? = nil,
         popularity: Double? = nil,
         voteAverage: Double? = nil,
         voteCount: Int? = nil,
         isAdult: Bool? = nil
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.overview = overview
        self.runtime = runtime
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.budget = budget
        self.homepageURL = homepageURL
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.isAdult = isAdult
    }
}

extension Movie {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case runtime
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case budget
        case homepageURL = "homepage"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case isAdult = "adult"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        
        if let releasedOn = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.releaseDate = dateFormatter.date(from: releasedOn)
        }

        let posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.posterPath = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")
        
        let backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.backdropPath = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")
        
        self.budget = try container.decodeIfPresent(Double.self, forKey: .budget)
        self.homepageURL = try container.decodeIfPresent(URL.self, forKey: .homepageURL)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.isAdult = try container.decodeIfPresent(Bool.self, forKey: .isAdult)
    }
}
extension Date {
    var yearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
}


extension Movie {
    static var preview: Movie = .init(
        id: 533535,
        title: "Deadpool & Wolverine",
        originalTitle: "Deadpool & Wolverine",
        overview: "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.",
        runtime: 128,
        releaseDate: .now,
        posterPath: URL(string: "https://image.tmdb.org/t/p/w500/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"),
        backdropPath: URL(string: "https://image.tmdb.org/t/p/w500/9l1eZiJHmhr5jIlthMdJN5WYoff.jpg"),
        budget: 250000000,
        homepageURL: URL(string: "https://www.marvel.com/movies/deadpool-and-wolverine"),
        popularity: 2178.995,
        voteAverage: 8.202,
        voteCount: 141,
        isAdult: false
    )
}
