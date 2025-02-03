//
//  ListItemsView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 30/10/24.
//

import SwiftUI

struct ListItemsView: View {
//    let movies: [Movie]
    let movies: [ShortMovie]
    @Binding var searchText: String
    
    @Environment(AuthViewModel.self) var authViewModel
    @Environment(MoviesViewModel.self) var moviesViewModel
    @Environment(UserViewModel.self) var userVM
    @State private var showLoadButton = false
    
    var body: some View {
        @Bindable var viewModel = moviesViewModel
        LazyVStack(alignment: .leading) {
            ForEach(movies) { movie in
                NavigationLink {
                    MovieScreen(movieId: movie.id)
                        .navigationBarBackButtonHidden()
                        .environment(authViewModel)
                } label: {
                    MediaRow(
                        title: movie.title,
                        backdropPath: movie.backdropPath,
                        releaseDate: movie.releaseDate,
                        voteAverage: movie.voteAverage
                    )
                }
                .onAppear(perform: {
                    if searchText.isEmpty {
                        if movie == moviesViewModel.trendingMovies.last {
                            viewModel.trendingMoviesPage += 1
                            print("lan in listitem: \(userVM.language)")
                            Task {
                                await viewModel.getTrendingMovies(language: userVM.language)
                            }
                        }
                    }
                    else {
                        if movie == moviesViewModel.searchedMovies.last {
                            viewModel.searchMoviesPage += 1
                            Task {
                                await viewModel.searchMovies(searchTerm: searchText, firstPage: false)
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
                    await viewModel.searchMovies(searchTerm: searchText)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ListItemsView(movies: [ShortMovie.preview], searchText: .constant(""))
            .environment(AuthViewModel())
            .environment(MoviesViewModel())
            .environment(UserViewModel())
    }
}
