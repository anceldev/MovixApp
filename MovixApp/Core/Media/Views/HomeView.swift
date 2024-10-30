//
//  HomeView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 1/8/24.
//

import SwiftUI
import Inject

struct HomeView: View {
    @ObserveInjection var inject
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Hello Movix App!")
            Spacer()
        }
        .enableInjection()
    }
}

#Preview {
    HomeView()
}
