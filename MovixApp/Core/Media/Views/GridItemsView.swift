//
//  GridItemsView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 30/10/24.
//

import SwiftUI

struct GridItemsView: View {
    let movies: [Movie]
    @Binding var currentPage: Int
    
    @ObserveInjection var inject
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Environment(AuthViewModel.self) var authViewModel
    @Environment(MoviesViewModel.self) var moviesViewModel
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(movies) { movie in
                NavigationLink {
                    MovieView(movie: movie)
                        .navigationBarBackButtonHidden()
                        .environment(authViewModel)
                } label: {
                    MediaGridItem(posterPath: movie.posterPath, voteAverage: movie.voteAverage)
//                    MediaGridItem(posterPath: movie.posterDataPath, voteAverage: movie.voteAverage)
//                        .task {
//                            try? await moviesViewModel.donwloadImage(for: movie)
//                        }
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
        .enableInjection()
    }
}

#Preview {
    GridItemsView(movies: [Movie.preview], currentPage: .constant(1))
        .environment(AuthViewModel())
        .environment(MoviesViewModel())
}
