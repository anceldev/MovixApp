////
////  CustomTabBar.swift
////  MovixApp
////
////  Created by Ancel Dev account on 30/7/24.
////
//
//import SwiftUI
//
//struct TabModel: Identifiable {
//    private(set) var id: Tab
//    var size: CGSize = .zero
//    var minX: CGFloat = .zero
//    
//    enum Tab: String, CaseIterable {
//        case general = "General"
//        case details = "Details"
//        case comments = "Comments"
//        case movie = "Movies"
//        case tv = "TV"
//        case all = "All"
//        case trending = "Trending"
//    }
//}
//
//struct TabSelectionView: View {
//    @State private var tabs: [TabModel] = [
//        .init(id: .general),
//        .init(id: .details),
//        .init(id: .comments),
//        //        .init(id: .movie),
//        //        .init(id: .all),
//        //        .init(id: .trending)
//    ]
//    
//    @State private var activeTab: TabModel.Tab = .general
//    @State private var tabBarScrollState: TabModel.Tab?
//    @State private var mainViewScrollState: TabModel.Tab?
//    @State private var progress: CGFloat = .zero
//    var body: some View {
//        //        VStack(spacing: 15) {
//        VStack(spacing: 0) {
//            CustomTabBar().background(.yellow)
//            GeometryReader {
//                let size = $0.size
//                ScrollView(.horizontal) {
//                    LazyHStack(spacing: 0, content: {
//                        Text("Tab 1 is here")
//                            .frame(width: size.width, height: size.height)
//                            .contentShape(.rect)
//                            .id(TabModel.Tab.general)
//                        Text("Details is here")
//                            .frame(width: size.width, height: size.height)
//                            .contentShape(.rect)
//                            .id(TabModel.Tab.details)
//                        Text("Comments")
//                            .frame(width: size.width, height: size.height)
//                            .contentShape(.rect)
//                            .id(TabModel.Tab.comments)
//                    })
//                    .scrollTargetLayout()
//                    .rect { rect in
//                        progress = -rect.minX / size.width
//                    }
//                }
//                .scrollPosition(id: $mainViewScrollState)
//                .scrollIndicators(.hidden)
//                .scrollTargetBehavior(.paging)
//                .onChange(of: mainViewScrollState) { oldValue, newValue in
//                    if let newValue {
//                        withAnimation(.snappy) {
//                            tabBarScrollState = newValue
//                            activeTab = newValue
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    func CustomTabBar() -> some View {
//        ScrollView(.horizontal) {
//                HStack(spacing: 20) {
//                    ForEach($tabs) { $tab in
//                        Button(action: {
//                            withAnimation(.snappy) {
//                                activeTab = tab.id
//                                tabBarScrollState = tab.id
//                                mainViewScrollState = tab.id
//                            }
//                        }) {
//                            Text(tab.id.rawValue)
//                                .padding(.vertical, 12)
//                                .foregroundStyle(activeTab == tab.id ? Color.primary : Color.gray)
//                                .contentShape(.rect)
//                        }
//                        .buttonStyle(.plain)
//                        .rect { rect in
//                            tab.size = rect.size
//                            tab.minX = rect.minX
//                        }
//                    }
//                }
//                .background(.yellow)
//                .scrollTargetLayout()
//        }
//        .background(.pink)
//        .scrollPosition(id: .init(get: {
//            return tabBarScrollState
//        }, set: { _ in
//            
//        }))
//        .overlay(alignment: .bottom) {
//            ZStack(alignment: .leading) {
//                Rectangle()
//                    .fill(.gray.opacity(0.3))
//                    .frame(height: 1)
//                
//                let inputRange = tabs.indices.compactMap { return CGFloat($0) }
//                let outputRange = tabs.compactMap { return $0.size.width }
//                let outputPositionRange = tabs.compactMap { return $0.minX }
//                let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
//                let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)
//                
//                Rectangle()
//                    .fill(.black)
//                    .frame(width: indicatorWidth ,height: 1.5)
//                    .offset(x: indicatorPosition)
//            }
//        }
//        .safeAreaPadding(.horizontal, 15)
//        .scrollIndicators(.hidden)
//
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
//                    Color.clear
//                        .preference(key: RectKey.self, value: rect)
//                        .onPreferenceChange(RectKey.self, perform: completion)
//                }
//            }
//    }
//}
//
//extension CGFloat {
//    func interpolate(inputRange: [CGFloat], outputRange: [CGFloat]) -> CGFloat {
//        let x = self
//        let length = inputRange.count - 1
//        if x <= inputRange[0] { return outputRange[0] }
//        for index in 1...length {
//            let x1 = inputRange[index - 1]
//            let x2 = inputRange[index]
//            
//            let y1 = outputRange[index - 1]
//            let y2 = outputRange[index]
//            
//            if x <= inputRange[index] {
//                let y = y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
//                return y
//            }
//        }
//        return outputRange[length]
//    }
//}
//
//#Preview {
//    TabSelectionView()
//}
