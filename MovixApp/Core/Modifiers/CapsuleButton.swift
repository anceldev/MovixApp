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
        case lightGray
    }
    
    let color: CapsuleColor
    let height: CGFloat
    
    var bg: LinearGradient {
        switch color {
        case .orangeGradient:
            LinearGradient(colors: [Color.marsA, Color.marsB], startPoint: .bottomLeading, endPoint: .topTrailing)
        case .gray:
            LinearGradient(colors: [Color.grayM, Color.grayM], startPoint: .bottomLeading, endPoint: .topTrailing)
        case .lightGray:
            LinearGradient(colors: [Color(hex: "#E595957")], startPoint: .leading, endPoint: .trailing)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20))
            .foregroundStyle(.white)
        //            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(bg)
            .clipShape(Capsule())
    }
}

extension ButtonStyle where Self == CapsuleButton {
    static var capsuleButton: CapsuleButton { .init(color: .orangeGradient, height: 56)}
    static func capsuleButton(_ color: CapsuleButton.CapsuleColor = .orangeGradient, height: CGFloat = 56) -> CapsuleButton {
        CapsuleButton(color: color, height: height)
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    VStack(spacing: 16) {
        
        Button(action: {
            print("Login")
        }, label: {
            Text("Login")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.capsuleButton)
        
        Button(action: {
            print("Apply...")
        }, label: {
            Text("Apply")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.capsuleButton(.gray))
        Button(action: {
            print("Apply...")
        }, label: {
            Text("Apply")
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.capsuleButton(.lightGray))
        
        Text("Sign up")
            .capsuleModifier(.white)
        
        TextField("E-mail", text: .constant(""))
            .capsuleModifier(.bw50, input: true)
    }
    .background(.green.opacity(0.5))
})
