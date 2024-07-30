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
    
    init() {
        self.movie = nil
    }
    
    @MainActor
    func getMovie(id: Int) async {
        Task {
            self.movie = await ApiTMDB.shared.getMovieDetails(id: id)
        }
    }
}
