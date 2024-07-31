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
    
    init() {
        getTrending()
    }

    func getTrending() {
        Task {
            self.movies = await ApiTMDB.shared.getTrendingMovies()
        }
    }
    
    func searchMovie(searchTerm: String) {
        Task {
            do {
                self.movies = try await ApiTMDB.shared.searchMovies(searchTerm: searchTerm)
            } catch {
                print("DEBUG - Error: ApiTMDB error \(error.localizedDescription)")
            }
        }
    }
}
