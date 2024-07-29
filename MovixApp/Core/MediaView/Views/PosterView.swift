//
//  PosterView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 19/7/24.
//

import SwiftUI

let genres = ["USA", "Comedy", "Fantasy", "FullHD"]

struct PosterView: View {
    
    let posterURL: URL?
    let duration: String
    let isAdult: Bool?
    let releasedDate: String
    
    var body: some View {
        ZStack {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .empty:
                    Color.gray
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
//                case .failure(let error):
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                @unknown default:
                    ProgressView()
                }
            }
            LinearGradient(
                stops: [
                    .init(color: .black.opacity(0.59), location: 0),
                    .init(color: .black.opacity(0), location: 0.48),
                    .init(color: .black, location: 1)
                ],
                startPoint: .bottom,
                endPoint: .top)
            VStack {
                BannerTopBar()
                    .padding(.top, 44)
                Spacer()

                Button(action: {
                    print("Playing moview...")
                }, label: {
                    Label("Play", systemImage: "play.fill")
                        .font(.system(size: 20))
                        .padding(.horizontal, 28)
                })
                .buttonStyle(.capsuleButton(height: 44))
                .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: true),
                            value: true
                        )
                
                .padding(.top, -12)
                VStack(spacing: 8) {
                    HStack {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                    HStack {
                        Text(releasedDate)
                        Text("|")
                        Text(duration)
                        Text("|")
                        Text(isAdult ?? false ? "18+" : "13+")
                        
                    }
                }
                .font(.system(size: 12))
                .padding(.top, 20)
                .padding(.bottom, 8) 
            }
            .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
//        .frame(height: 468)
    }
}

//#Preview {
//    PosterView(posterURL: Movie.preview.posterPath, duration: Movie.preview.duration, isAdult: false, releasedDate: Movie.preview.releaseDate?.yearString ?? "1900")
//}
#Preview(body: {
    MovieView(movie: Movie.preview)
})