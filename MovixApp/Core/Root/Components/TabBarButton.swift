//
//  TabBarButton.swift
//  MovixApp
//
//  Created by Ancel Dev account on 1/8/24.
//

import SwiftUI

struct TabBarButton: View {
    var animation: Namespace.ID
    var tab: Tab
    @Binding var selectedTab: Tab
    var body: some View {
        Button {
            withAnimation(.snappy) {
                self.selectedTab = tab
            }
        } label: {
            VStack(spacing: 0) {
                Image(systemName: selectedTab == tab ? tab.selected : tab.unselected)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28)
                    .foregroundStyle(selectedTab == tab ? .blue1 : .bw50)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
