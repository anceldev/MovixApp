////
////  Movie.swift
////  MovixApp
////
////  Created by Ancel Dev account on 25/7/24.
////

import Foundation
import SwiftUI

struct ImageLoader {
    static func loadImage(from urlString: String) async -> Image? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else { return nil }
            return Image(uiImage: uiImage)
        } catch {
            print("Image loading error: \(error.localizedDescription)")
            return nil
        }
    }
}
    
enum BackdropSize: String, CaseIterable {
    case w300
    case w780
    case w1280
    case original
}

enum PosterSize: String, CaseIterable {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
    case original
}

//fileprivate enum BackdropSizes: String, CaseIterable, SizesEnum {
//    case w300
//    case w780
//    case w1280
//    case original
//}
//fileprivate enum PosterSizes: String, CaseIterable, SizesEnum {
//    case w92
//    case w154
//    case w185
//    case w342
//    case w500
//    case w780
//    case original
//}

struct Movie: Codable, Identifiable, Hashable {
    var id: Int
    var title: String
    var originalTitle: String?
    var overview: String?
    var runtime: Int?
    var releaseDate: Date?
    var posterPathUrl: URL?
    var posterPath: String?
    
    var posterData: Data?
    var backdropData: Data?
    var genres: [Genre]?
//    var genreIds: [Int]?
    
//    var posterDataPath: URL?
    
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
        return "\(runtime/60)h \(runtime%60)min"
    }
    
    init(id: Int,
         title: String,
         originalTitle: String? = nil,
         overview: String? = nil,
         runtime: Int? = nil,
         releaseDate: Date? = nil,
         posterPath: URL? = nil,
         backdropPath: URL? = nil,
         genres: [Genre] = [],
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
        self.posterPathUrl = posterPath
        self.backdropPath = backdropPath
        self.genres = genres
        self.budget = budget
        self.homepageURL = homepageURL
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.isAdult = isAdult
        self.genres = []
    }
    
    static func getImageFromPath<T:CaseIterable & RawRepresentable>(backdropPath: String?,_ availableSizes: T) async -> Image? {
        guard let imagePath = backdropPath else { return nil }
        do {
            for size in T.allCases {
                let url = URL(string: "https://image.tmdb.org/t/p/\(size.rawValue)\(imagePath)")!
                let (data, _ ) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    return Image(uiImage: uiImage)
                }
            }
            return nil
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func getBackdropImage(posterPath: String?) async -> Image? {
        guard let posterPath = posterPath else {
            return nil
        }
        var url = URL(string: "https://image.tmdb.org/t/p/w780\(posterPath)")!
        do {
            let (dataW500, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW500) {
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/w1280\(posterPath)")!
            let (dataW1280, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW1280) {
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")!
            let (dataOriginal, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataOriginal) {
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/w300\(posterPath)")!
            let (dataW300, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW300) {
                return Image(uiImage: uiImage)
            }
            return nil
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

extension Movie {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case genres
        case genreIds = "genre_ids"
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
    
    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        try container.encode(id, forKey: .id)
//        try container.encode(title, forKey: .title)
//        
//        try container.encodeIfPresent(originalTitle, forKey: .originalTitle)
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
        self.posterPath = posterPath
        self.posterPathUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")
        
        let backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.backdropPath = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath ?? "")")
        
        self.budget = try container.decodeIfPresent(Double.self, forKey: .budget)
//        self.homepageURL = try container.decodeIfPresent(URL.self, forKey: .homepageURL)
        self.homepageURL = nil
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.isAdult = try container.decodeIfPresent(Bool.self, forKey: .isAdult)
        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
//        self.genreIds = try container.decode([Int].self, forKey: .genreIds)
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
        genres: [.init(id: 1, name: "Action"), .init(id: 2, name: "Hero")],
        budget: 250000000,
        homepageURL: URL(string: "https://www.marvel.com/movies/deadpool-and-wolverine"),
        popularity: 2178.995,
        voteAverage: 8.202,
        voteCount: 141,
        isAdult: false
    )
}
