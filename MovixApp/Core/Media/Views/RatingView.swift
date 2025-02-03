//
//  RatingView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 3/2/25.
//

import SwiftUI

struct StarView: View {
    var rating: Float
    var index: Float
    
    var starFillWidth: CGFloat {
        let mappedRating = rating / 2
        let fillPercentage = max(0, min(1, (mappedRating - index)))
        return CGFloat(fillPercentage) * 38
    }
    
    var body: some View {
        ZStack {
            // Estrella de fondo (gris/claro)
            Image(systemName: "star")
                .font(.system(size: 38, weight: .thin))
                .foregroundStyle(LinearGradient(colors: [.marsA, .marsB], startPoint: .leading, endPoint: .trailing))
            // Estrella rellena con gradiente
            Image(systemName: "star.fill")
                .font(.system(size: 38, weight: .thin))
                .foregroundStyle(LinearGradient(colors: [.marsA, .marsB], startPoint: .leading, endPoint: .trailing))
                .mask(
                    Rectangle()
                        .frame(width: starFillWidth + 8, height: 45)
                        .position(x: starFillWidth/2, y: 19)
                )
        }
    }
}

struct RatingView: View {
    @Binding var currentRate: Float
    @State private var isEditing = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("Rating")
                .font(.system(size: 22, weight: .medium))
            VStack(spacing: 12) {
                Text("Rate the movie with a touch")
                VStack(spacing: 12) {
                    
                    HStack {
                        ForEach(0..<5) { index in
                            StarView(rating: currentRate, index: Float(index))
                            
                        }
                    }
                    
                    HStack {
                        Slider(
                            value: $currentRate,
                            in: 0...10,
                            step: 0.1
                        ) { editing in
                            isEditing = editing
                        }
                        .tint(.mars)
                        
                        
                    }
                    .padding(.horizontal, 44)
                    Button {
                        print("Send rating")
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32, weight: .light))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, LinearGradient(colors: [.marsA, .marsB], startPoint: .bottomLeading, endPoint: .topTrailing))
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(.bw20)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .onChange(of: currentRate) {
                print("Rate is: \(currentRate)")
            }
        }
    }
}

#Preview {
    @Previewable @State var currentRate: Float = 0.0
    RatingView(currentRate: $currentRate)
}
