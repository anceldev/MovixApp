//
//  MovixAppApp.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/7/24.
//

import SwiftUI

@main
struct MovixAppApp: App {
    @AppStorage("privacyAccepted") var token: Bool = false
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
