//
//  RateView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 18/12/24.
//

import SwiftUI

struct RateView: View {
    
    
    @Binding private var currentRate: Float
    @State private var isEditing: Bool
    let action: () -> ()
    
    init(currentRate: Binding<Float>, action: @escaping () -> ()) {
        self._currentRate = currentRate
        self._isEditing = State(initialValue: false)
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Rate movie")
                .fontWeight(.bold)
            Text(currentRate, format: .number.precision(.fractionLength(1)))
                .font(.system(size: 45))
            Slider(
                value: $currentRate,
                in: 0...10,
                step: 0.1
            ) { editing in
                    isEditing = editing
                }
                .tint(.blue2)
            Button {
                rateMovie()
            } label: {
                Label("Rate", systemImage: "star.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.capsuleButton(.orangeGradient))
        }
        .onChange(of: currentRate) {
            print("New rate: \(currentRate)")
        }
        .frame(maxWidth: 250, maxHeight: 200)
    }
    private func rateMovie() {
        print("Rating")
        action()
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    RateView(currentRate: .constant(5.0), action: {})
})
