//
//  BannerTopBar.swift
//  MovixApp
//
//  Created by Ancel Dev account on 19/7/24.
//

import SwiftUI


struct BannerTopBar: View {
    let backButton: Bool
    let shareButton: Bool
    @Environment(\.dismiss) private var dismiss
    
    init(_ backButton: Bool, _ shareButton: Bool = false){
        self.backButton = backButton
        self.shareButton = shareButton
    }
    var body: some View {
        HStack {
            if backButton {
                Button(action: {
                    dismiss()
                }, label: {
                    VStack {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                    .frame(width: 22, height: 22)
                })
            }
            Spacer(minLength: 0)
            if shareButton {
                ShareLink(item: URL(string: "https://www.themoviedb.org/")!) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                }
            }
        }
        .opacity(0.8)
        .padding(8)
        .padding(.horizontal)
        .font(.system(size: 20))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
    }
}
#Preview {
    BannerTopBar(true)
        .background(.bw10)
}
