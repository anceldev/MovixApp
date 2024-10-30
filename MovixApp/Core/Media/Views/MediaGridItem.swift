//
//  MediaGridItem.swift
//  MovixApp
//
//  Created by Ancel Dev account on 30/10/24.
//

import SwiftUI

struct MediaGridItem: View {
    
    let posterPath: URL?
    let voteAverage: Double?
    
    
    @ObserveInjection var inject
    
    var body: some View {
        ZStack {
            Color.bw10
//            AsyncImage(url: posterPath) { phase in
            AsyncImage(url: posterPath) { phase in
                switch phase {
                case .empty:
                    Color.gray
                case .success(let image):
                    VStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .clipped()
                case .failure(_):
                    ProgressView()
                        .progressViewStyle(.circular)
                @unknown default:
                    Color.gray
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            if let formattedRate = NumberFormatter.popularity.string(from: NSNumber(value: voteAverage ?? 0.0)) {
                VStack(alignment: .leading) {
                    ZStack(alignment: .center){
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomTrailing: 10))
                            .fill(.black.opacity(0.8))
                        Text(formattedRate)
                            .foregroundStyle(.blue1)
                            .font(.system(size: 12))
                    }
                    .frame(width: 30, height: 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .background(.clear)
        .enableInjection()
    }
}

#Preview {
    MediaGridItem(posterPath: Movie.preview.posterPath, voteAverage: 8.7)
}
