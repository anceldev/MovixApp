//
//  Movie.swift
//  MovixApp
//
//  Created by Ancel Dev account on 19/7/24.
//

import SwiftUI

struct MovieView: View {
    
    var movie: Movie?
    var viewModel: CastViewModel
    
    init(movie: Movie? = nil) {
        self.movie = movie
        self.viewModel = CastViewModel(id: self.movie!.id)
    }
    
    var body: some View {
        GeometryReader { geo in
        
        ScrollView(.vertical) {
            if let movie = movie {
                PosterView(
                    posterURL: movie.posterPath,
                    duration: movie.duration,
                    isAdult: movie.isAdult,
                    releasedDate: movie.releaseDate?.yearString ?? "NP",
                    size: geo.size
                )
                MovieActionsBar()
                HStack {
                    GeneralInfo(cast: viewModel.cast, overview: movie.overview)
                }
                MediaTabs()
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
        .ignoresSafeArea()
        }
    }
}
#Preview(body: {
    MovieView(movie: Movie.preview)
})

