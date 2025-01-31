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
    let releaseDate: Date?
    
    init(title: String, backdropPath: URL? = nil, genres: [String] = [], voteAverage: Double? = nil, releaseDate: Date? = nil ) {
        self.title = title
        self.backdropPath = backdropPath
        self.genres = genres
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
    }
    
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
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    Color.gray
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
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
                    }
                    .frame(width: size.width * 0.4)
                    .frame(maxHeight: .infinity)
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.top, 8)
                        if let releaseDate = releaseDate {
                            Text(releaseDate.releaseDate())
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                .frame(maxWidth: size.width)
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
        voteAverage: Movie.preview.voteAverage ?? 0.0,
        releaseDate: .now
    )
    .background(.bw20)
})
