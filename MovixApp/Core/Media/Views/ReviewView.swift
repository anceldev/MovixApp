//
//  ReviewView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 3/2/25.
//

import SwiftUI

struct ReviewView: View {
    let review: Review
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                AsyncImage(url: review.authorDetails.avatarPath) { phase in
                    switch phase {
                    case .empty:
                        Image(.profileDefault)
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(.circle)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(.circle)
                    case .failure:
                        Image(.profileDefault)
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(.circle)
                    @unknown default:
                        Color.gray
                    }
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(review.author)
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    if let createdAt = review.createdAt {
                        Text(createdAt, format: .dateTime)
                            .font(.system(size: 10))
                            .foregroundStyle(.bw50)
                    }
                }
                Spacer()
            }
            Text(review.content)
                .foregroundStyle(.white)
                .font(.system(size: 14))
        }
        .padding(16)
    }
}

#Preview {
    ReviewView(review: Review.preview)
        .background(.bw10)
}
