//
//  MovieScreen.swift
//  MovixApp
//
//  Created by Ancel Dev account on 19/7/24.
//

import SwiftUI

struct MovieScreen: View {
    
    var movie: Movie?
    //    var castViewModel: CastViewModel
    @State private var castViewModel: CastViewModel
    @State private var showRateSlider = false
    @State private var currentRate: Float = 5.0
    @Environment(AuthViewModel.self) var authViewModel
    
    
    init(movie: Movie? = nil) {
        self.movie = movie
        self._castViewModel = State(initialValue: CastViewModel(id: self.movie!.id))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical) {
                if let movie = movie {
                    PosterView(
                        posterURL: movie.posterPathUrl,
                        duration: movie.duration,
                        isAdult: movie.isAdult,
                        releasedDate: movie.releaseDate?.yearString ?? "NP",
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
            .scrollIndicators(.hidden)
            BannerTopBar(true, true)
                .padding(.top, 44)
        }
        .sheet(isPresented: $showRateSlider) {
            RateView(currentRate: $currentRate, action: makeRate)
                .presentationDetents([.height(300)])
        }
        .ignoresSafeArea()
        .task {
            castViewModel.getCast(id: self.movie!.id)
        }
    }
    private func makeRate() {
        let rateValue = round(currentRate * 10) / 10
        print(rateValue)
    }
}
#Preview(body: {
    NavigationStack {
        MovieScreen(movie: Movie.preview)
            .environment(AuthViewModel())
    }
})

