//
//  MovieActionsBar.swift
//  MovixApp
//
//  Created by Ancel Dev account on 19/7/24.
//

import SwiftUI

struct MovieActionsBar: View {
    let liked = true
    var body: some View {
        VStack {
            HStack(spacing: 34) {
                Button(action: {
                    print("Rate")
                }, label: {
                    VStack(spacing: 12) {
                        Image(systemName: "hand.thumbsup")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Rate")
                            .font(.system(size: 12))
                    }
                })
                .foregroundStyle(.bw50)
                Button(action: {
                    print("Download")
                }, label: {
                    VStack(spacing: 12) {
                        Image(systemName: "tray.and.arrow.down")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Download")
                            .font(.system(size: 12))
                    }
                })
                .foregroundStyle(.bw50)
                Button(action: {
                    print("My list")
                }, label: {
                    VStack(spacing: 12) {
                        Image(systemName: liked ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("My List")
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(liked ? .blue1 : .bw50)
                })
                Button(action: {
                    print("Rate")
                }, label: {
                    VStack(spacing: 12) {
                        Image(systemName: "person.badge.plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Live")
                            .font(.system(size: 12))
                    }
                })
                .foregroundStyle(.bw50)
            }
            .padding(.top, 26)
        }
        .frame(maxWidth: .infinity)
        .background(.bw10)
    }
}

#Preview {
    MovieActionsBar()
        .background(.bw20)
}
