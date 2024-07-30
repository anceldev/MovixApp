//
//  BannerTopBar.swift
//  MovixApp
//
//  Created by Ancel Dev account on 19/7/24.
//

import SwiftUI

struct BannerTopBar: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "chevron.left")
            })
            Spacer(minLength: 0)
            Button(action: {
                print("Share...")
            }, label: {
                Label("Share", systemImage: "square.and.arrow.up")
                    .labelStyle(.iconOnly)
            })
        }
        .padding(8)
        .padding(.horizontal, 10)
        .font(.system(size: 20))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
    }
}
#Preview(body: {
    MovieView(movie: Movie.preview)
})

