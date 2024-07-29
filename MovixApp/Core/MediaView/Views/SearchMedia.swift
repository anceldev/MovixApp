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
    var body: some View {
        VStack {
            SearchBar(
                searchTerm: $searchTerm,
                filterAction: {
                    showFilterSheet = true
                }
            )
            MediaList(movies: viewModel.movies)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw20)
        .onChange(of: searchTerm) {
            viewModel.searchMovie(searchTerm: searchTerm)
        }
        .sheet(isPresented: $showFilterSheet, content: {
            FiltersView()
        })
        
    }
}
