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
        if authViewModel.account == nil {
            LoginView(viewModel: authViewModel)
                
        } else {
            MainTabView()
                .environment(authViewModel)
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
