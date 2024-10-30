//
//  SearchMedia.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

enum ItemsViewOption {
    case row
    case grid
}

struct SearchView: View {

    
    @State private var searchTerm: String = ""
    @State private var showFilterSheet: Bool = false
    @State private var itemsView: ItemsViewOption = .row
    
    @Bindable var viewModel: MoviesViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    
    var body: some View {
        VStack {
            Text("Search")
                .font(.system(size: 22))
                .foregroundStyle(.white)
                .fontWeight(.semibold)
            SearchBar(
                searchTerm: $searchTerm,
                filterAction: {
                    showFilterSheet = true
                },
                itemsView: $itemsView
            )
            ItemsView(movies: viewModel.movies, fetchAction: searchTerm == "" ? .trending : .search, itemsView: itemsView)
                .environment(authViewModel)
                .environment(viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
        .onChange(of: searchTerm) {
            if searchTerm == "" {
                viewModel.getTrendingMovies(page: 1)
            } else {
                viewModel.searchMovie(searchTerm: searchTerm)
            }
        }
        .sheet(isPresented: $showFilterSheet, content: {
            FiltersView()
        })
    }
}

#Preview {
    MainTabView()
        .environment(AuthViewModel())
}
