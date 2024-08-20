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
    var movies: [Movie] = []
    var movieGenres: [Genre] = []
    
    init() {
        getTrendingMovies()
        getMovieGenres()
    }

    func getTrendingMovies() {

        Task {
            self.movies = await ApiTMDB.shared.getTrendingMovies()
        }
    }
    
    
    /// Searchs a movie
    /// - Parameter searchTerm: query for search action
    func searchMovie(searchTerm: String) {
        
        Task {
            do {
                self.movies = try await ApiTMDB.shared.searchMovies(searchTerm: searchTerm)
            } catch {
                print("DEBUG - Error: ApiTMDB error \(error.localizedDescription)")
            }
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
