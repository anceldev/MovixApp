//
//  MovieScreen.swift
//  MovixApp
//
//  Created by Ancel Dev account on 19/7/24.
//

import SwiftUI

struct MovieScreen: View {
    
//    var movie: Movie?
    let movieId: Int
//    @State private var movie: Movie?
    //    var castViewModel: CastViewModel
    @State private var castViewModel: CastViewModel
    @State private var showRateSlider = false
    @State private var currentRate: Float = 5.0
    @Environment(AuthViewModel.self) var authViewModel
    @State private var movieVM = MovieViewModel()
    
//    init(movie: Movie? = nil) {
    init(movieId: Int) {
        self.movieId = movieId
//        self.movie = movie
        self._castViewModel = State(initialValue: CastViewModel(id: movieId))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                ScrollView(.vertical) {
                    if let movie = movieVM.movie {
                        PosterView(
                            posterURL: movie.posterPathUrl,
                            duration: movie.duration,
                            isAdult: movie.isAdult,
                            releasedDate: movie.releaseDate?.yearString ?? "NP",
                            genres: movie.genres,
                            id: movie.id
                        )
                        MovieActionsBar(idMovie: movie.id, showRateSlider: $showRateSlider)
                            .environment(authViewModel)
                        VStack {
                            HStack {
                                GeneralInfo(cast: movieVM.movieCast, overview: movie.overview)
                            }
                        }
                        VStack {
                            MovieTabsView()
                                .environment(movieVM)
                        }
                    } else {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.bw10)
                .background(ignoresSafeAreaEdges: .bottom)
                .scrollIndicators(.hidden)
                Spacer()
            }
            .frame(maxHeight: .infinity)
            BannerTopBar(true, true)
                .padding(.top, 44)
//                .environment(movieVM)
        }
        .padding(.bottom, 24)
        .sheet(isPresented: $showRateSlider) {
            RateView(currentRate: $currentRate, action: makeRate)
                .presentationDetents([.height(300)])
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                await movieVM.getMovieDetails(id: movieId)
                await movieVM.getMovieCast(id: movieId)
            }
        }
        .swipeToDismiss()
    }
    private func makeRate() {
        let rateValue = round(currentRate * 10) / 10
    }
}
#Preview(body: {
    NavigationStack {
        MovieScreen(movieId: Movie.preview.id)
            .environment(AuthViewModel())
    }
})

