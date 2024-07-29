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
        ScrollView(.vertical) {
            if let movie = movie {
                PosterView(
                    posterURL: movie.posterPath,
                    duration: movie.duration,
                    isAdult: movie.isAdult,
                    releasedDate: movie.releaseDate?.yearString ?? "NP"
                )
                MovieActionsBar()
                HStack {
                    GeneralInfo(cast: viewModel.cast, overview: movie.overview)
                }
                MediaTabs()
//                MediaTabs(overview: movie.o)
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
        .ignoresSafeArea()
//        .navigationBarBackButtonHidden()

    }
}
#Preview(body: {
    MovieView(movie: Movie.preview)
})

