//
//  GeneralView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 20/7/24.
//

import SwiftUI


struct GeneralInfo: View {
    //    let overview: String
    let cast: [Cast]
    let overview: String?
    @State var viewMore: Int? = 3
    
    var body: some View {
        VStack {
            VStack(spacing: 12) {
                VStack(alignment: .leading) {
                    if let overview {
                        Text(overview)
                            .lineLimit(viewMore)
                            .foregroundStyle(.white)
                        
                        Button(action: {
                            print("View more...")
                            withAnimation {
                                if(viewMore != nil) {
                                    viewMore = nil
                                } else {
                                    viewMore = 3
                                }
                            }
                        }, label: {
                            Text(viewMore == nil ? "View less" : "View More ")
                                .foregroundStyle(.blue1)
                        })
                    }
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("Actors")
                        .font(.system(size: 22, weight: .medium))
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(cast) { actor in
                                NavigationLink {
                                    ActorScreen(id: actor.id)
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    ActorLink(
                                        imageUrl: actor.profilePath, name:
                                            actor.originalName)
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .padding(16)
        }
    }
    
    @ViewBuilder
    func ActorLink(imageUrl: URL?, name: String) -> some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .tint(.marsB)
                    case .success(let image):
                        VStack {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .offset(y: 8)
                                .frame(width: 76, height: 76)
                            
                        }
                        .clipped()
                    case .failure(_):
                        Image(systemName: "photo")
                    @unknown default:
                        ProgressView()
                    }
                }
            }
            .frame(width: 76, height: 76)
            .background(.bw50)
            .clipShape(.circle)
            
            
            VStack {
                Text(name)
                    .foregroundStyle(.white)
//                    .frame(width: 80)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 30)
//                        .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .font(.system(size: 12))
        .frame(maxWidth: 80)
    }
}
#Preview(body: {
    MovieScreen(movie: Movie.preview)
        .environment(AuthViewModel())
})
