//
//  FavouritesScreen.swift
//  MovixApp
//
//  Created by Ancel Dev account on 1/8/24.
//

import SwiftUI

struct FavouritesScreen: View {
    @Environment(AuthViewModel.self) var authViewModel
    @Environment(MoviesViewModel.self) var moviesViewModel
    @State private var showFilterSheet = false
    @State private var searchTerm = ""
    var body: some View {
        VStack {
            Text("Favorites")
                .font(.system(size: 22))
                .foregroundStyle(.white)
                .fontWeight(.semibold)
            if let favorites = authViewModel.account?.favoriteMovies {
                ItemsView(searchTerm: $searchTerm, itemsView: .row)
                    .environment(moviesViewModel)
            } else {
                Text("No favorite movies added")
                    .foregroundStyle(.white)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
        .sheet(isPresented: $showFilterSheet, content: {
            FiltersView()
        })
        .onAppear {
            Task {
                try await authViewModel.getFavoriteMoviews(page: 1)
            }
        }
    }
}

#Preview {
    FavouritesScreen()
        .environment(AuthViewModel())
}
