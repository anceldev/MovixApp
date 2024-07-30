//
//  MediaRow.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

struct MediaRow: View {
    let title: String
    let backdropPath: URL?
    let genres: [String]
    let voteAverage: Double?
    
    var body: some View {
        HStack {
            GeometryReader {
                let size = $0.size
                HStack {
                    HStack {
                        ZStack {
                            AsyncImage(url: backdropPath) { phase in
                                switch phase {
                                case .empty:
                                    Color.gray
                                case .success(let image):
                                    VStack {
                                        
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: size.width * 0.4, height: 88)
                                    }
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    Color.gray
                                }
                            }
                            if let formattedRate = NumberFormatter.popularity.string(from: NSNumber(value: voteAverage ?? 0.0)) {
                                VStack(alignment: .leading) {
                                    ZStack(alignment: .center){
                                        RoundedRectagleShape()
                                            .fill(.black.opacity(0.5))
                                        //                                .opacity(0.8)
                                        Text(formattedRate)
                                            .foregroundStyle(.blue1)
                                    }
                                    .frame(width: 45, height: 30)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            }
                        }
                    }
                    .frame(width: size.width * 0.4)
                    .frame(maxHeight: .infinity)
                    HStack {
                        Text(title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.top, 8)
                        
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 104)
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    MediaRow(
        title: Movie.preview.title,
        backdropPath: Movie.preview.backdropPath,
        genres: ["Drama"],
        voteAverage: Movie.preview.voteAverage ?? 0.0
    )
        .background(.bw20)
})
