//
//  MovieViewModel.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import Foundation
import Observation

@Observable
final class MovieViewModel {
    var movie: Movie?
    var movieCast = [Cast]()
    var movieReviews = [Review]()
    var errorMessage: String?
    let httpClient = HTTPClient()
    
    init() {
        self.movie = nil
    }
    
    func getMovieDetails(id: Int) async {
        do {
            let resource = Resource(
                url: Endpoints.movie("\(id)").url,
                method: .get([URLQueryItem(name: "language", value: "en-US")]),
                modelType: Movie.self
            )
            let movie = try await httpClient.load(resource)
            self.movie = movie
            try await getMovieCast(id: id)
        } catch{
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    func getMovieCast(id: Int) async throws {
        do {
            let resource = Resource(
                url: Endpoints.cast("\(id)", .movie).url,
                method: .get([URLQueryItem(name: "language", value: "en-US")]),
                modelType: Credit.self
            )
            let movieCredits = try await httpClient.load(resource)
            self.movieCast = movieCredits.cast
        } catch {
            print(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getMovieReviews(id: Int) async {
        do {
            let resource = Resource(
                url: Endpoints.review(.movie, "\(id)").url,
                method: .get([
                    URLQueryItem(name: "language", value: "en-US"),
                    URLQueryItem(name: "page", value: "1")
                ]),
                modelType: ReviewCollection.self
            )
            let reviews = try await httpClient.load(resource)
            self.movieReviews = reviews.results
            
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    func resetValues() {
        self.movie = nil
        self.movieCast.removeAll()
        self.errorMessage = nil
    }
}
