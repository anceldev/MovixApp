//
//  ContentView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/7/24.
//

import SwiftUI

struct ContentView: View {
    
   @State var authViewModel = AuthenticationViewModel()

    var body: some View {
        VStack {
            switch authViewModel.flow {
            case .authenticated:
                MainTabView()
                    .environment(authViewModel)
            case .authenticating:
                ProgressView()
            case .unauthenticated:
                LoginView(viewModel: authViewModel)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
