//
//  SwipeToDismissModifier.swift
//  MovixApp
//
//  Created by Ancel Dev account on 3/2/25.
//

import SwiftUI

enum MovieTab: String, CaseIterable {
    case general, details, reviews
    
    var systemImage: String {
        return "phone"
    }
}

struct SwipeToDismissModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        if value.translation.width > 80 {
                            dismiss()
                        }
                    })
            )
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func swipeToDismiss() -> some View {
        self.modifier(SwipeToDismissModifier())
    }
    
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
    /// Tab bar Masking
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat) -> some View {
        ZStack {
            self
                .foregroundStyle(.gray)
            
            self
                .symbolVariant(.fill)
                .mask {
                    GeometryReader {
                        let size = $0.size
                        let capusleWidth = size.width / CGFloat(MovieTab.allCases.count)
                        
                        Capsule()
                            .frame(width: capusleWidth)
                            .offset(x: tabProgress * (size.width - capusleWidth))
                    }
                }
        }
    }
}

