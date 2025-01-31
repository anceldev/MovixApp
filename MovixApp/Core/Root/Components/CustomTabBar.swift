//
//  CustomTabBar.swift
//  MovixApp
//
//  Created by Ancel Dev account on 1/8/24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @Namespace var animation
    
    var body: some View {
        HStack {
            TabBarButton(
                animation: animation,
                tab: .home,
                selectedTab: $selectedTab)
            TabBarButton(
                animation: animation,
                tab: .search,
                selectedTab: $selectedTab)
            TabBarButton(
                animation: animation,
                tab: .favourites,
                selectedTab: $selectedTab)
            TabBarButton(
                animation: animation,
                tab: .profile,
                selectedTab: $selectedTab)
        }
        .padding(.horizontal)
        .padding(.top)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.bw20)
                .frame(height: 1)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    CustomTabBar(selectedTab: .constant(.search))
})

