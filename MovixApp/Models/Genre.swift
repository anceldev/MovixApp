//
//  Genre.swift
//  MovixApp
//
//  Created by Ancel Dev account on 7/8/24.
//

import Foundation
import SwiftUI

struct Genres: Decodable {
    var genres: [Genre]
}
struct Genre: Identifiable, Decodable, Hashable {
    var id: Int
    var name: String
    var urlBackground: String?
    
    var background: Image {
        Image(urlBackground!)
    }
}

extension Genres {
    static let movieGenres: [Genre] = [
        .init(id: 28, name: "Action", urlBackground: "genre-action"),
        .init(id: 12, name: "Adventure", urlBackground: "genre-adventure"),
        .init(id: 16, name: "Animation", urlBackground: "genre-animation"),
        .init(id: 35, name: "Comedy", urlBackground: "genre-comedy"),
        .init(id: 80, name: "Crime", urlBackground: "banner"),
        .init(id: 99, name: "Documentary", urlBackground: "genre-documentary"),
        .init(id: 18, name: "Drama", urlBackground: "genre-drama"),
        .init(id: 10751, name: "Family", urlBackground: "banner"),
        .init(id: 14, name: "Fantasy", urlBackground: "genre-fantast"),
        .init(id: 36, name: "History", urlBackground: "genre-history"),
        .init(id: 27, name: "Horror", urlBackground: "genre-horror"),
        .init(id: 10402, name: "Music", urlBackground: "genre-music"),
        .init(id: 9648, name: "Mistery", urlBackground: "banner"),
        .init(id: 10749, name: "Romance", urlBackground: "genre-romance"),
        .init(id: 878, name: "Science Fiction", urlBackground: "genre-scfi"),
        .init(id: 10770, name: "TV Movie", urlBackground: "banner"),
        .init(id: 53, name: "Thriller", urlBackground: "genre-thriller"),
        .init(id: 10752, name: "War", urlBackground: "genre-war"),
        .init(id: 37, name: "Western", urlBackground: "genre-western"),
    ]
    static let tvGenres: [Genre] = [
        .init(id: 10759, name: "Action & Adventure", urlBackground: "genre-action"),
        .init(id: 16, name: "Animation", urlBackground: "genre-animation"),
        .init(id: 35, name: "Comedy", urlBackground: "genre-comedy"),
        .init(id: 80, name: "Crime", urlBackground: "banner"),
        .init(id: 99, name: "Documentary", urlBackground: "genre-documentary"),
        .init(id: 18, name: "Drama", urlBackground: "genre-drama"),
        .init(id: 10751, name: "Family", urlBackground: "banner"),
        .init(id: 10762, name: "Kids", urlBackground: "banner"),
        .init(id: 9648, name: "Mistery", urlBackground: "banner"),
        .init(id: 10763, name: "News", urlBackground: "banner"),
        .init(id: 10764, name: "Reality", urlBackground: "banner"),
        .init(id: 10765, name: "Sci-Fi & Fantasy", urlBackground: "genre-scfi"),
        .init(id: 10766, name: "Soap", urlBackground: "banner"),
        .init(id: 10767, name: "Talk", urlBackground: "banner"),
        .init(id: 10768, name: "War & Politics", urlBackground: "genre-war"),
        .init(id: 37, name: "Western", urlBackground: "genre-western")
    ]
    
    static var combinedGenres: [Genre] = {
        var allGenres = Genres.movieGenres
        for tvGenre in Genres.tvGenres {
            if let index = allGenres.firstIndex(where: { $0.id == tvGenre.id }) {
                allGenres[index] = tvGenre
            } else {
                allGenres.append(tvGenre)
            }
        }
        allGenres.sort { $0.name < $1.name }
        return allGenres
    }()
}
