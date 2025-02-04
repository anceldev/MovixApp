//
//  MovieActionsBar.swift
//  MovixApp
//
//  Created by Ancel Dev account on 19/7/24.
//

import SwiftUI


struct MovieActionsBar: View {
    let idMovie: Int
    @Binding var showRateSlider: Bool
    @Environment(AuthViewModel.self) var authViewModel
    var isFavorite: Bool {
        guard (authViewModel.account?.favoriteMovies?.first(where: { $0.id == idMovie
        })) != nil else { return false }
        return true
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Button(action: {
                    showRateSlider.toggle()
                }, label: {
                    VStack(spacing: 12) {
                        VStack {
                            Image(systemName: "hand.thumbsup")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 30, height: 30)
                            Text("Rate")
                            .font(.system(size: 12))
                    }
                    .frame(width: 60)
                })
                .foregroundStyle(.bw50)
                .foregroundStyle(.bw50)
                Button(action: {
                    toggleFavorite()
                    print("My list")
                }, label: {
                    VStack(spacing: 12) {
                        VStack {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 30, height: 30)
                            Text("My List")
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(isFavorite ? .blue1 : .bw50)
                    .frame(width: 60)
                })
                NavigationLink {
                    ProvidersScreen(id: idMovie)
                        .navigationBarBackButtonHidden()
                } label: {
                    VStack(spacing: 12) {
                        VStack {
                            Image(systemName: "play.display")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(8)
                                .background(
                                    LinearGradient(colors: [Color.marsA, Color.marsB], startPoint: .bottomLeading, endPoint: .topTrailing)
                                )
                                .clipShape(.circle)
                                .foregroundStyle(.white)
                        }
                        .frame(width: 30, height: 30)
                        Text("Providers")
                            .font(.system(size: 12))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 60)
                }
            }
            .padding(.top, 26)
        }
        .frame(maxWidth: .infinity)
        .background(.bw10)
    }
    private func toggleFavorite() {
        Task {
            do {
                try await authViewModel.toggleFavorite(id: idMovie, mediaType: .movie, isFavorite: isFavorite)
            } catch {
                print("Error adding favorite movie...")
            }
        }
    }
}

#Preview {
    MovieActionsBar(idMovie: 533535, showRateSlider: .constant(true))
        .background(.bw20)
        .environment(AuthViewModel())
}
