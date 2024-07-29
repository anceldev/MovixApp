//
//  RoundedRectagleShape.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import Foundation
import SwiftUI

struct RoundedRectagleShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .init(x: 15, y: 0))
            path.addLine(to: .init(x: 45, y: 0))
            path.addLine(to: .init(x: 45, y: 15))
            path.addArc(center: .init(x: 30, y: 15), radius: 15, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            path.addLine(to: .init(x: 0, y: 30))
            path.addLine(to: .init(x: 0, y: 15))
            path.addArc(center: .init(x: 15, y: 15), radius: 15, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        }
    }
}
