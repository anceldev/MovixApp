//
//  ContentView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/7/24.
//

import SwiftUI

struct ContentView: View {
   @State var authVM = AuthViewModel()
    var body: some View {
        VStack {
            switch authVM.flow {
            case .authenticated:
                MainTabView()
                    .environment(authVM)
            case .authenticating:
                ProgressView()
            case .unauthenticated:
                LoginView(viewModel: authVM)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
