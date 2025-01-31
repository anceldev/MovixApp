//
//  GridItemsView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 30/10/24.
//

import SwiftUI

struct GridItemsView: View {
    let movies: [Movie]
    @Binding var searchText: String
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Environment(AuthViewModel.self) var authViewModel
    @Environment(MoviesViewModel.self) var moviesViewModel

    var body: some View {
        @Bindable var moviesVM = moviesViewModel
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(movies) { movie in
                NavigationLink {
                    MovieScreen(movie: movie)
                        .navigationBarBackButtonHidden()
                        .environment(authViewModel)
                } label: {
                    MediaGridItem(posterPath: movie.posterPath, voteAverage: movie.voteAverage)
                }
                .onAppear(perform: {
                    if searchText.isEmpty {
                        if movie == moviesViewModel.trendingMovies.last {
                            moviesViewModel.trendingMoviesPage += 1
                            Task {
                                await moviesViewModel.getTrendingMovies()
                            }
                        }
                    }
                    else {
                        if movie == moviesViewModel.searchedMovies.last {
                            moviesViewModel.searchMoviesPage += 1
                            Task {
                                await moviesViewModel.searchMovies(searchTerm: searchText, firstPage: false)
                            }
                        }
                    }
                })
            }
        }
        .padding()
        .onChange(of: searchText) { oldValue, newValue in
            if !newValue.isEmpty {
                Task {
                    await moviesViewModel.searchMovies(searchTerm: searchText)
                }
            }
        }
    }
}

#Preview {
    GridItemsView(movies: [Movie.preview], searchText: .constant(""))
        .environment(AuthViewModel())
        .environment(MoviesViewModel())
}
