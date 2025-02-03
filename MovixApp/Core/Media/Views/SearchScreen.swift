//
//  SearchScreen.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

enum ViewOption {
    case row
    case grid
}

struct SearchScreen: View {

    @State private var searchTerm: String = ""
    @State private var showFilterSheet: Bool = false
    @State private var itemsView: ViewOption = .grid

    @Environment(MoviesViewModel.self) var moviesVM
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
            ItemsView(
                searchTerm: $searchTerm,
                itemsView: itemsView
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
        .task {
            await moviesVM.getTrendingMovies()
        }
        .sheet(isPresented: $showFilterSheet, content: {
            FiltersView()
        })
        .onChange(of: searchTerm) { oldValue, newValue in
            if !newValue.isEmpty {
                itemsView = .row
            } else {
                itemsView = .grid
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainTabView()
    }
    .environment(AuthViewModel())
    .environment(MoviesViewModel())
}
