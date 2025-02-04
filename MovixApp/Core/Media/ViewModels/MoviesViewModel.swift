//
//  MoviesViewModel.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import Foundation
import Observation


@Observable
final class MoviesViewModel {
//    var trendingMovies: [Movie] = []
    var trendingMovies: [ShortMovie] = []

    // private var _trendingMoviesSet: Set<ShortMovie> = []
    // var trendingMovies: [ShortMovie] {
    //     Array(_trendingMoviesSet)
    // }

    var searchedMovies: [ShortMovie] = []
//    var searchedMovies: [Movie] = []
    var errorMessage: String?
    
    var trendingMoviesPage: Int = 1
    var searchMoviesPage: Int = 1
    
    private var favoriteMoviesPages: Int = 0
    var movieGenres: [Genre] = []
    var tvGenres: [Genre] = []
    
    let httpClient = HTTPClient()
    
    init() {
        Task {
            await getMovieGenres()
            await getTvGenres()
        }
    }
    
    func getMovieGenres(language: String = "en") async {
        do {
            let resource = Resource(
                url: Endpoints.genre(.movie).url,
                method: .get([
                    URLQueryItem(name: "language", value: language)
                ]),
                modelType: Genres.self
            )
            let movieGenres = try await httpClient.load(resource)
            self.movieGenres = movieGenres.genres
        } catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    func getTvGenres(language: String = "en") async {
        do {
            let resource = Resource(
                url: Endpoints.genre(.tv).url,
                method: .get([
                    URLQueryItem(name: "language", value: language)
                ]),
                modelType: Genres.self
            )
            let tvGenres = try await httpClient.load(resource)
            self.tvGenres = tvGenres.genres
        } catch {
            print(error.localizedDescription)
            self.errorMessage = errorMessage
        }
    }
    
    func getTrendingMovies(language: String = "en-US") async {
        print("language is:", language)
        do {
            let resource = Resource(
                url: Endpoints.trending(.movie, .week, self.trendingMoviesPage).url,
                method: .get([
                    URLQueryItem(name: "language", value: language),
                    URLQueryItem(name: "page", value: "\(self.trendingMoviesPage)")
                ]),
//                modelType: MoviesCollection.self
                modelType: PageCollection<ShortMovie>.self
            )
            let trendingMovies = try await httpClient.load(resource)
            self.trendingMovies += trendingMovies.results
        } catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    func isLastItem(id: Int) -> Bool {
        let index = self.trendingMovies.firstIndex { $0.id == id }
        if index == self.trendingMovies.count - 1 {
            return true
        }
        return false
    }
    
    /// Searchs a movie
    /// - Parameter searchTerm: query for search action
    func searchMovies(searchTerm: String, firstPage: Bool = true) async {
        do {
            let resource = Resource(
                url: Endpoints.search(searchTerm, .movie).url,
                method: .get(
                    [
                        URLQueryItem(name: "page", value: "\(self.searchMoviesPage)"),
                        URLQueryItem(name: "query", value: searchTerm),
                        URLQueryItem(name: "language", value: "en-US"),
                        URLQueryItem(name: "page", value: firstPage ? "1" : "\(self.searchMoviesPage)")
                    ]
                ),
//                modelType: MoviesCollection.self
                modelType: PageCollection<ShortMovie>.self
            )
            let searchedMovies = try await httpClient.load(resource)
            if firstPage {
                self.searchedMovies = searchedMovies.results
            }
            else {
                self.searchedMovies += searchedMovies.results
            }
        } catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    /// Get current movie genres
    func getMovieGenres() {
        Task {
            do {
                self.movieGenres = try await ApiTMDB.shared.getMovieGenres(for: .movieGenres)
            } catch {
                print("DEBUG - Error: ApiTMDB error \(error.localizedDescription)")
            }
        }
    }
}
