//
//  ListItemsView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 30/10/24.
//

import SwiftUI

struct ListItemsView: View {
    let movies: [Movie]
    @Binding var currentPage: Int
    
    @Environment(AuthViewModel.self) var authViewModel
    @Environment(MoviesViewModel.self) var moviesViewModel
    var body: some View {
        LazyVStack(alignment: .leading) {
            ForEach(movies) { movie in
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
    }
}

#Preview {
    ListItemsView(movies: [Movie.preview], currentPage: .constant(1))
        .environment(AuthViewModel())
        .environment(MoviesViewModel())
}
