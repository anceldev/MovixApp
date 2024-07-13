//
//  CapsuleButton.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/7/24.
//

import Foundation
import SwiftUI

struct CapsuleButton: ButtonStyle {
    enum CapsuleColor {
        case orangeGradient
        case gray
    }
    
//    let filled: Bool
    let color: CapsuleColor
    
    var bg: LinearGradient {
        switch color {
        case .orangeGradient:
            LinearGradient(colors: [Color.marsA, Color.marsB], startPoint: .bottomLeading, endPoint: .topTrailing)
        case .gray:
            LinearGradient(colors: [Color.grayM, Color.grayM], startPoint: .bottomLeading, endPoint: .topTrailing)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(bg)
            .clipShape(Capsule())
    }
}

extension ButtonStyle where Self == CapsuleButton {
    static var capsuleButton: CapsuleButton { .init(color: .orangeGradient)}
    static func capsuleButton(_ color: CapsuleButton.CapsuleColor) -> CapsuleButton {
        CapsuleButton(color: color)
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    VStack(spacing: 16) {
        Button("Login") {
            print("Login...")
        }
        .buttonStyle(.capsuleButton)
        
        Button("Apply") {
            print("Apply...")
        }
        .buttonStyle(.capsuleButton(.gray))
        
        Text("Sign up")
            .capsuleModifier(.white)
        
        TextField("E-mail", text: .constant(""))
            .capsuleModifier(.bw50, input: true)
    }
    .background(.green.opacity(0.5))
})
