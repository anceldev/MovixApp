//
//  MainTabView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 1/8/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @Environment(AuthenticationViewModel.self) var authViewModel
//    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State var viewModel = MoviesViewModel()
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                switch selectedTab {
                case .home:
                    HomeView()
                case .search:
                    SearchMedia(viewModel: viewModel)
                case .favourites:
                    FavouritesView()
                case .profile:
                    ProfileView()
                        .environment(authViewModel)
//                        .environmentObject(authViewModel)
                }
                Spacer(minLength: 0)
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .background(.bw10)
        .background(ignoresSafeAreaEdges: .bottom)
    }
}

#Preview {
    NavigationStack {
        MainTabView()
            .environment(AuthenticationViewModel())
//            .environmentObject(AuthenticationViewModel())
    }
}
