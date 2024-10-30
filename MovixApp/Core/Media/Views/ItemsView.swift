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
    @State private var currentPage = 1
    
    let movies: [Movie]
    let fetchAction: FetchAction
    let itemsView: ItemsViewOption
    
    var body: some View {
        ScrollView(.vertical) {
            if movies.count > 0 {
                switch itemsView {
                case .row:
                    ListItemsView(movies: movies, currentPage: $currentPage)
                        .environment(authViewModel)
                        .environment(moviesViewModel)
                case .grid:
                    GridItemsView(movies: movies, currentPage: $currentPage)
                        .environment(authViewModel)
                        .environment(moviesViewModel)
                }
//                .padding()
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        VStack {
            ItemsView(movies: [Movie.preview], fetchAction: .trending, itemsView: .grid)
                .environment(AuthViewModel())
                .environment(MoviesViewModel())
        }
        .background(.bw10)
    }
}
