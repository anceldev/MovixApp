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
                    .font(.title2)
            })
            Spacer(minLength: 0)
            ShareLink(item: URL(string: "https://www.themoviedb.org/")!) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .labelStyle(.iconOnly)
                    .font(.title2)
            }
        }
        .opacity(0.6)
        .padding(8)
        .padding(.horizontal)
        .font(.system(size: 20))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
    }
}
#Preview(body: {
    MovieView(movie: Movie.preview)
})

