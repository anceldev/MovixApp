//
//  MediaList.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

struct MediaList: View {
    
    enum FetchAction {
        case trending
        case search
        case favMovies
    }    
    
    @Environment(AuthenticationViewModel.self) var authViewModel
    @Environment(MoviesViewModel.self) var moviesViewModel
    @State private var currentPage = 1

    let movies: [Movie]
    let fetchAction: FetchAction

    var body: some View {
        ScrollView(.vertical) {
            if movies.count > 0 {
                LazyVStack(alignment: .leading) {
                    ForEach(moviesViewModel.movies) { movie in
                        NavigationLink {
                            MovieView(movie: movie)
                                .navigationBarBackButtonHidden()
                                .environment(authViewModel)
                        } label: {
                            MediaRow(
                                title: movie.title,
                                backdropPath: movie.backdropPath,
                                genres: ["Test"],
                                voteAverage: movie.voteAverage)
                        }
                        .onAppear(perform: {
                            if moviesViewModel.isLastItem(id: movie.id) {
                                self.currentPage += 1
                                moviesViewModel.getTrendingMovies(page: currentPage)
                            }
                        })
                    }
                }
                .padding()
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    VStack {
        MediaList(movies: [Movie.preview], fetchAction: .trending)
            .environment(AuthenticationViewModel())
            .environment(MoviesViewModel())
    }
    .background(.bw10)
}
