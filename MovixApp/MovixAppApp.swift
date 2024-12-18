//
//  MovixAppApp.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/7/24.
//

import SwiftUI
@_exported  import Inject


@main
struct MovixAppApp: App {
    @State private var authVM = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environment(authVM)
            }
        }
        .environment(\.colorScheme, .dark)
    }
}
