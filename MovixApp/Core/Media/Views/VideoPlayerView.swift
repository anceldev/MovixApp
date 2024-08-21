//
//  VideoPlayer.swift
//  MovixApp
//
//  Created by Ancel Dev account on 20/8/24.
//

import SwiftUI
import AVKit


struct VideoPlayerView: View {
    
    let videoURL: URL? = Bundle.main.url(forResource: "baseVideo", withExtension: "mp4")
    @State var player = AVPlayer(url: Bundle.main.url(forResource: "baseVideo", withExtension: "mp4")!)
    @State var isPlaying: Bool = false
    
    var body: some View {
        
        VStack {
            VideoPlayer(player: player) {
                Button {
                    isPlaying ? player.pause() : player.play()
                    isPlaying.toggle()
                    player.seek(to: .zero)
                } label: {

                }
                .buttonStyle(.capsuleButton)

            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    VideoPlayerView()
}
