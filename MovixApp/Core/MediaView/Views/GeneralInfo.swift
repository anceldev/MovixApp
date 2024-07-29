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
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        //                        ForEach(actors) { actor in
                        //                            NavigationLink(value: actor.id) {
                        //                                ActorLink(imageUrl: actor.imageUrl, name: actor.name, lastname: actor.lastname, genre: actor.genre.rawValue)
                        //                            }
                        //                        }
                        ForEach(cast) { actor in
                            NavigationLink {
                                Text(actor.originalName)
                            } label: {
                                ActorLink(
                                    imageUrl: actor.profilePath, name:
                                        actor.originalName)
                            }
                            
                        }
                    }
                    .navigationDestination(for: String.self) { actor in
                        Text("Individual view for an actor")
                    }
                    
                }
                .scrollIndicators(.hidden)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func ActorLink(imageUrl: URL?, name: String) -> some View {
        VStack(alignment: .center, spacing: 10) {
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    VStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .offset(y: 8)
                            .frame(width: 76, height: 76)
                        
                    }
                    .clipped()
                    .clipShape(Circle())

                case .failure(_):
                    Image(systemName: "photo")
                @unknown default:
                    ProgressView()
                }
            }
            VStack(alignment: .leading) {
                Text(name)
                    .foregroundStyle(.white)
            }
            
        }
        .font(.system(size: 12))
    }
}
#Preview(body: {
    MovieView(movie: Movie.preview)
})
