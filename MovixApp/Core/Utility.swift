//
//  Utility.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

//struct TabModel: Identifiable {
//    private(set) var id: Tab
//    var size: CGSize = .zero
//    var minX: CGFloat = .zero
//    
//    enum Tab: String, CaseIterable {
//        case general = "General"
//        case details = "Details"
//        case comments = "Comments"
//        case all = "All"
//        case movies = "Movies"
//        case series = "Series"
//    }
//}
//
//struct Utility: View {
//    @State private var tabs: [TabModel] = [
//        .init(id: .general),
//        .init(id: .details),
//        .init(id: .comments)
//    ]
//    @State private var activeTab: TabModel.Tab = .general
//    @State private var mainViewScrollState: TabModel.Tab?
//    @State private var progress: CGFloat = .zero
//    
//    var body: some View {
//        CustomTabBar()
//        GeometryReader {
//            let size = $0.size
//            
//            ScrollView(.horizontal) {
//                LazyHStack(spacing: 0) {
//                    ForEach(tabs) { tab in
//                        Text(tab.id.rawValue)
//                            .frame(width: size.width, height: size.height)
//                            .contentShape(.rect)
//                    }
//                }
//                .scrollTargetLayout()
//                .rect { rect in
//                    progress = rect.minX / size.width
//                }
//            }
//            .scrollPosition(id: $mainViewScrollState)
//            .scrollIndicators(.hidden)
//            .scrollTargetBehavior(.paging)
//            .onChange(of: mainViewScrollState) { oldValue, newValue in
//                if let newValue {
//                    withAnimation(.snappy) {
//                        activeTab = newValue
//                    }
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    func CustomTabBar() -> some View {
//        HStack(spacing: 20) {
//            ForEach($tabs) { $tab in
//                Button(action: {
//                    withAnimation(.snappy) {
//                        activeTab = tab.id
//                        mainViewScrollState = tab.id
//                    }
//                }, label: {
//                    Text(tab.id.rawValue)
//                        .padding(.vertical, 12)
//                        .foregroundStyle(activeTab == tab.id ? .black : .gray)
//                        .contentShape(.rect)
//                })
//                .buttonStyle(.plain)
//                .rect { rect in
//                    tab.size = rect.size
//                    tab.minX = rect.minX
//                }
//            }
//        }
//        .overlay(alignment: .bottom) {
//            ZStack(alignment: .leading, content: {
//                Rectangle()
//                    .fill(.gray.opacity(0.3))
//                    .frame(height: 2)
//                
//                let inputRange = tabs.indices.compactMap { return CGFloat($0) }
//                let outputRange = tabs.compactMap { return $0.size.width }
//                let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
//                
//                Rectangle()
//                    .fill(.black)
//                    .frame(width: indicatorWidth ,height: 1.5)
//
//            })
//        }
//        .safeAreaPadding(.horizontal, 15)
//    }
//}
//
//struct RectKey: PreferenceKey {
//    static var defaultValue: CGRect = .zero
//    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
//        value = nextValue()
//    }
//}
//extension View {
//    @ViewBuilder
//    func rect(completion: @escaping (CGRect) -> ()) -> some View {
//        self
//            .overlay {
//                GeometryReader {
//                    let rect = $0.frame(in: .scrollView(axis: .horizontal))
//                    
//                    Color.clear
//                        .preference(key: RectKey.self, value: rect)
//                        .onPreferenceChange(RectKey.self, perform: completion)
//                }
//            }
//    }
//}
//extension CGFloat {
//    func interpolate(inputRange: [CGFloat], outputRange: [CGFloat]) -> CGFloat {
//        let x = self
//        let length = inputRange.count - 1
//        if x <= inputRange[0] { return outputRange[0]}
//        for index in 1...length {
//            let x1 = inputRange[index - 1]
//            let x2 = inputRange[index]
//            
//            let y1 = outputRange[index - 1]
//            let y2 = outputRange[index]
//            
//            if x <= inputRange[index] {
//                let y = y1 + ((y2 - y1) / (x2-x1)) * (x-x1)
//                return y
//            }
//        }
//        return outputRange[length]
//    }
//    
//}


//#Preview {
//    Utility()
//}
