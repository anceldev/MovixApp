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
    
    private var trendingMoviesPages: Int = 0
    private var searchMoviesPages: Int = 0
    private var favoriteMoviesPages: Int = 0
    
    var movieGenres: [Genre] = []
    
    init() {
        getTrendingMovies(page: 1)
//        getMovieGenres()
    }

    func getTrendingMovies(page: Int) {
        Task {
            if page == 1 {
                self.movies = []
            }
            let fetchedPage = await ApiTMDB.shared.getTrendingMovies(page: page)
            self.movies.append(contentsOf: fetchedPage)
        }
    }
    
    func isLastItem(id: Int) -> Bool {
        let index = self.movies.firstIndex { $0.id == id }
        if index == self.movies.count - 1 {
            return true
        }
        return false
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
