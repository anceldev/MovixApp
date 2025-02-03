//
//  MainTabView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 1/8/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .search
    @Environment(AuthViewModel.self) var authViewModel
    @State var moviesVM = MoviesViewModel()
    @State var userVM = UserViewModel()
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                switch selectedTab {
                case .home:
                    HomeScreen()
                case .search:
                    SearchScreen()
                        .environment(authViewModel)
                        .environment(moviesVM)
                case .favourites:
                    FavouritesScreen()
                        .environment(moviesVM)
                        .environment(authViewModel)
                case .profile:
                    ProfileScreen()
                        .environment(authViewModel)
                        
                }
                Spacer(minLength: 0)
                CustomTabBar(selectedTab: $selectedTab)
            }
            .environment(userVM)
        }
        .background(.bw10)
        .background(ignoresSafeAreaEdges: .bottom) 
    }
}

#Preview {
    NavigationStack {
        MainTabView()
            .environment(AuthViewModel())
    }
}
