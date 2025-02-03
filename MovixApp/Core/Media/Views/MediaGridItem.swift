//
//  MediaGridItem.swift
//  MovixApp
//
//  Created by Ancel Dev account on 30/10/24.
//

import SwiftUI

struct MediaGridItem: View {
//    let posterPath: URL?
    let posterPath: String?
    let voteAverage: Double?
    @State private var image: Image? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.bw50, .bw90], startPoint: .top, endPoint: .bottom)
            Group {
                if let image = image {
                    VStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .clipped()
                } else {
                    ProgressView()
                        .aspectRatio(2/3, contentMode: .fill)
                        .tint(.marsB)
                }
            }
            .frame(maxWidth: .infinity)
//            .clipShape(RoundedRectangle(cornerRadius: 12))
                

            
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
        .aspectRatio(2/3, contentMode: .fill)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            Task {
                let image = await Movie.getBackdropImage(posterPath: posterPath)
                self.image = image
            }
        }
    }
}

#Preview {
    MediaGridItem(posterPath: Movie.preview.posterPath, voteAverage: 8.7)
}
