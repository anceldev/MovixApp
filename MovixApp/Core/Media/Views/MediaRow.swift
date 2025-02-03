//
//  MediaRow.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

struct MediaRow: View {

    let title: String
    let backdropPath: String?
    let releaseDate: Date?
    let voteAverage: Double?
    @State private var image: Image? = nil
    
    var body: some View {
        HStack {
                HStack {
                    HStack {
                        ZStack {
                            Group {
                                if let image = image {
                                    VStack {
                                        image
                                            .resizable()
                                            .aspectRatio(16/9, contentMode: .fill)
                                    }
                                }
                                else {
                                    ProgressView()
                                        .tint(.marsB)
                                }
                            }
                            .frame(maxWidth: .infinity)
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
        }
        .frame(maxWidth: .infinity)
        .frame(height: 104)
        .onAppear {
            Task {
                let image = await Movie.getBackdropImage(posterPath: backdropPath)
                self.image = image
            }
        }
    }
}

//#Preview(traits: .sizeThatFitsLayout, body: {
//    MediaRow(
//        title: "Spiderman 3",
//        backdropPath: ShortMovie.preview.backdropPath,
//        releaseDate: .now,
//        voteAverage: 2.5
//    )
//    .background(.bw20)
//})
