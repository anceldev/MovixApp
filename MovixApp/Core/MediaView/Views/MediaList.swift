//
//  MediaList.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

struct MediaList: View {
    let movies: [Movie]
    var body: some View {
        ScrollView(.vertical) {
            if movies.count > 0 {
                VStack(alignment: .leading) {
                    ForEach(movies) { movie in
                        NavigationLink {
                            MovieView(movie: movie)
                                .navigationBarBackButtonHidden()
                        } label: {
                            MediaRow(
                                title: movie.title,
                                backdropPath: movie.backdropPath,
                                genres: ["Test"],
                                voteAverage: movie.voteAverage)
                        }
                    }
                }
                .padding()
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    MediaList(movies: [Movie.preview])
}
