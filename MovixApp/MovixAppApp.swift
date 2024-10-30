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
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environment(\.colorScheme, .dark)
            }
        }
    }
}
