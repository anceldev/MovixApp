//
//  MovieTabsView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 3/2/25.
//

import SwiftUI

struct MovieTabsView: View {
    /// View Properties
    @State private var selectedTab: MovieTab? = .general
    @Environment(\.colorScheme) private var scheme
    @Environment(MovieViewModel.self) var movieVM
    /// Tab Progress
    @State private var tabProgress: CGFloat = 0
    var body: some View {
        VStack(spacing: 15) {
            CustomTabBar()
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        GeneralTabView(cast: movieVM.movieCast)
                            .id(MovieTab.general)
                            .containerRelativeFrame(.horizontal)
                        DetailsTabView(movie: movieVM.movie!)
                            .id(MovieTab.details)
                            .containerRelativeFrame(.horizontal)
                        
                        ReviewsTabView()
                            .id(MovieTab.reviews)
                            .containerRelativeFrame(.horizontal)
                            .environment(movieVM)
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $selectedTab)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollClipDisabled()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(MovieTab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Text(tab.rawValue.capitalized)
                        .font(.system(size: 20))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    /// Updating Tab
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
                .overlay {
                    Rectangle()
                        .fill(tab == selectedTab ? .blue1 : .clear)
                        .frame(height: 4)
                        .padding(.horizontal, 8)
                        .offset(y: 18)
                }
            }
        }
        .padding(.horizontal, 25)
    }
}
