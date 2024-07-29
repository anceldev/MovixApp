//
//  MediaProtocol.swift
//  MovixApp
//
//  Created by Ancel Dev account on 25/7/24.
//

import Foundation

protocol MediaProtocol: Decodable {
    var id: Int { get set }
    var title: String { get set }
    var originalTitle: String? { get set }
    var overview: String? { get set }
    var runtime: Int? { get set }
    var releaseDate: Date? { get set }
    var posterPath: URL? { get set }
    var backdropPath: URL? { get set }
    var budget: Double? { get set }
    var homepageURL: URL? { get set }
    var popularity: Double?  {get set }
    var voteAverage: Double? { get set }
    var voteCount: Int? { get set }
    var isAdult: Bool? { get set }
    // var genres: [Genre] { get set }

}
