//
//  MovieTabsView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 3/2/25.
//

import SwiftUI

private struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 300
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct MovieTabsView: View {
    /// View Properties
    @State private var selectedTab: MovieTab? = .general
    @Environment(\.colorScheme) private var scheme
    @Environment(MovieViewModel.self) var movieVM
    /// Tab Progress
    @State private var tabProgress: CGFloat = 0
        @State private var viewHeight: CGFloat = 300 // Add this line

    var body: some View {
        VStack(spacing: 15) {
            /// Custom Tab Bar
            CustomTabBar()
            switch selectedTab {
            case .general:
                GeneralTabView(cast: movieVM.movieCast)
            case .details:
                DetailsTabView(movie: movieVM.movie!)
            case .reviews:
                ReviewsTabView()
                    .environment(movieVM)
            case nil:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
       .frame(height: nil)
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(MovieTab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Text(tab.rawValue.capitalized)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
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
                        .fill(selectedTab == tab ? .blue1 : .clear)
                        .frame(height: 4)
                        .offset(y: 18)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
    
    /// Sample View For Demonstrating Scrollable Tab Bar Indicator
    @ViewBuilder
    func SampleView(_ color: Color, _ to: Int) -> some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                ForEach(1...to, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color.gradient)
                        .frame(height: 150)
                        .overlay {
                            VStack(alignment: .leading) {
                                Circle()
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 80, height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 60, height: 8)
                                }
                                
                                Spacer(minLength: 0)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 40, height: 8)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                }
            })
            .padding(15)
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
    }
}
