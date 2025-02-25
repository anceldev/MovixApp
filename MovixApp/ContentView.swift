//
//  ContentView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/7/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthViewModel.self) var authVM
    var body: some View {
        VStack {
            switch authVM.flow {
            case .authenticated:
                MainTabView()
                    .environment(authVM)
            case .authenticating:
                ProgressView()
            case .unauthenticated:
                LoginView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .environment(AuthViewModel())
    }
}
