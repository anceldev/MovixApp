//
//  MediaList.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

struct ItemsView: View {
    
    enum FetchAction {
        case trending
        case search
        case favMovies
    }
    
    @Environment(AuthViewModel.self) var authViewModel
    @Environment(MoviesViewModel.self) var moviesViewModel

    @Binding var searchTerm: String
    let itemsView: ViewOption
    
    var body: some View {
        @Bindable var moviesVM = moviesViewModel
        ScrollView(.vertical) {
                switch itemsView {
                case .row:
                    ListItemsView(movies: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies, searchText: $searchTerm)
                case .grid:
                    GridItemsView(
                        movies: searchTerm.isEmpty ? moviesVM.trendingMovies : moviesVM.searchedMovies,
                        searchText: $searchTerm
                    )
                        .environment(authViewModel)
                        .environment(moviesViewModel)
                }
        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            ItemsView(searchTerm: .constant(""), itemsView: .grid)
                .environment(AuthViewModel())
                .environment(MoviesViewModel())
        }
        .background(.bw10)
    }
}
