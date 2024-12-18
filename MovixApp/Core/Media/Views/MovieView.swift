//
//  Movie.swift
//  MovixApp
//
//  Created by Ancel Dev account on 19/7/24.
//

import SwiftUI

struct MovieView: View {
    
    var movie: Movie?
    var castViewModel: CastViewModel
    @State private var showRateSlider = true
    @State private var currentRate: Float = 5.0
    @Environment(AuthViewModel.self) var authViewModel
    
    
    init(movie: Movie? = nil) {
        self.movie = movie
        self.castViewModel = CastViewModel(id: self.movie!.id)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                ScrollView(.vertical) {
                    if let movie = movie {
                        PosterView(
                            posterURL: movie.posterPath,
                            duration: movie.duration,
                            isAdult: movie.isAdult,
                            releasedDate: movie.releaseDate?.yearString ?? "NP",
                            size: geo.size,
                            id: movie.id
                        )
                        MovieActionsBar(idMovie: movie.id, showRateSlider: $showRateSlider)
                            .environment(authViewModel)
                        HStack {
                            GeneralInfo(cast: castViewModel.cast, overview: movie.overview)
                        }
                        MediaTabs()
                    } else {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.bw10)
                .background(ignoresSafeAreaEdges: .bottom)
                BannerTopBar(true, true)
                    .padding(.top, 44)
            }
            .sheet(isPresented: $showRateSlider) {
                RateView(currentRate: $currentRate, action: makeRate)
                    .presentationDetents([.height(300)])
//                    .presentationBackground(.red)
            }
        }
        .ignoresSafeArea()
    }
    private func makeRate() {
        let rateValue = round(currentRate * 10) / 10
        
    }
}
#Preview(body: {
    NavigationStack {
        MovieView(movie: Movie.preview)
            .environment(AuthViewModel())
    }
})

