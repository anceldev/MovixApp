//
//  TestMovie.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

struct TestMovie: View {
    @Namespace var tab1
    @Namespace var tab2
    @Namespace var tab3
    @Namespace var tab4
    
    enum MyTabs: String {
        case btn1
        case btn2
        case btn3
        case btn4
    }
    
    @State private var activeTab: MyTabs? = .btn1
    
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollViewReader { proxy in
                HStack {
                    Button(action: {
                        withAnimation(.snappy) {
                            proxy.scrollTo(tab1)
                        }
                    }, label: {
                        Text("Go to 1")
                    })
                    .buttonStyle(.borderedProminent)
                    Button("Got to 2") {
                        withAnimation(.snappy) {
                            proxy.scrollTo(tab2)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Got to 3") {
                        withAnimation(.snappy) {
                            proxy.scrollTo(tab3)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Got to 4") {
                        withAnimation(.snappy) {
                            proxy.scrollTo(tab4)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(width: size.width, height: 50)
                .background(.gray)
                ScrollView(.horizontal) {
                    LazyHStack {
                        Text("Hi")
                            .frame(width: size.width, height: size.height)
                            .id(tab1)
                        Text("Nice")
                            .frame(width: size.width, height: size.height)
                            .id(tab2)
                        Text("Too")
                            .frame(width: size.width, height: size.height)
                            .id(tab3)
                        Text("Meet")
                            .frame(width: size.width, height: size.height)
                            .id(tab4)
                    }
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $activeTab)
                .onChange(of: activeTab) { oldValue, newValue in
                    print(activeTab?.rawValue)
                }
            }
        }
    }
}

#Preview {
    TestMovie()
}
