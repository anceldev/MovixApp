//
//  SearchMedia.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI


struct SearchMedia: View {
    @State private var searchTerm: String = ""
    @State private var showFilterSheet: Bool = false
    var viewModel: MoviesViewModel
    @Environment(AuthenticationViewModel.self) private var authViewModel
    var body: some View {
        VStack {
            Text(authViewModel.account?.name ?? authViewModel.usernameTMDB)
            SearchBar(
                searchTerm: $searchTerm,
                filterAction: {
                    showFilterSheet = true
                }
            )
            MediaList(movies: viewModel.movies)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
        .onChange(of: searchTerm) {
            if searchTerm == "" {
                viewModel.getTrending()
            } else {
                viewModel.searchMovie(searchTerm: searchTerm)
            }
        }
        .sheet(isPresented: $showFilterSheet, content: {
            FiltersView()
        })
    }
}
