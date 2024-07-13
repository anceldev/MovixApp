//
//  CapsuleFiel.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/7/24.
//

import Foundation
import SwiftUI

struct CapsuleModifier: ViewModifier {
    let stroke: Color
    let input: Bool
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: input ? .leading : .center)
            .padding(.leading, input ? 20 : 0)
            .frame(height: 56)
            .foregroundStyle(.white)
            .font(.system(size: input ? 17 : 20, weight: input ? .regular : .medium))
            .background(.black)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(input ? stroke : .white, lineWidth: 1)
            }
    }
}


extension View {
    func capsuleModifier(_ stroke: Color, input: Bool = false) -> some View {
        modifier(CapsuleModifier(stroke: stroke, input: input))
    }
}

