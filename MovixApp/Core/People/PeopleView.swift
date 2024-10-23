//
//  PeopleView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 30/7/24.
//

import SwiftUI

struct PeopleView: View {
    let id: Int
    let viewModel: PeopleViewModel
    @State private var viewMoreLimit: Int? = 5
    
    init(id: Int) {
        self.id = id
        self.viewModel = PeopleViewModel(id: id)
    }
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            ZStack(alignment: .top) {
                ScrollView(.vertical) {
                    ZStack {
                        ActorPhoto(size: size)
                        LinearGradient(
                            stops: [
                                .init(color: .bw10.opacity(0.59), location: 0),
                                .init(color: .bw10.opacity(0), location: 0.48),
                                .init(color: .bw10, location: 1)
                            ],
                            startPoint: .bottom,
                            endPoint: .top)
                        VStack(alignment: .leading){
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        
                    }
                    VStack {
                        ActorData()
                        if let bio = viewModel.actor?.biography, bio != "" {
                            ActorBio(bio: bio)
                        }
                    }
                    .foregroundStyle(.white)
                    .padding()
                    
                }
                BannerTopBar(true)
                    .padding(.top, 44)
            }
            .background(.bw10)
            .ignoresSafeArea()
        }
        .ignoresSafeArea(.all)
    }
    @ViewBuilder
    func ActorPhoto(size: CGSize) -> some View {
        VStack {
            AsyncImage(url: viewModel.actor?.profilePath) { phase in
                switch phase {
                case .empty:
                    Color.gray
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height * 0.65, alignment: .top)
                case .failure(let error):
                    VStack {
                        Image(systemName: "photo")
                        Text(error.localizedDescription)
                    }
                @unknown default:
                    Color.gray
                }
            }
        }
        .clipped()
    }
    @ViewBuilder
    func ActorData() -> some View {
        VStack {
            Text(viewModel.actor?.name ?? "No name")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.title)
            HStack {
                Text("Actor")
                
                if let age = viewModel.actor?.age {
                    Text("|")
                    Text("\(age) years")
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(.bw50)
        }
    }
    @ViewBuilder
    func ActorBio(bio: String) -> some View {
        VStack(alignment: .leading) {
            Text("Bio")
                .fontWeight(.semibold)
                .font(.system(size: 18))
            Text(bio)
                .lineLimit(viewMoreLimit)
            Button(action: {
                print("View more...")
                withAnimation(.snappy) {
                    if(viewMoreLimit != nil) {
                        viewMoreLimit = nil
                    } else {
                        viewMoreLimit = 5
                    }
                }
            }, label: {
                Text(viewMoreLimit == nil ? "View less" : "View More ")
                    .foregroundStyle(.blue1)
            })
        }
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    PeopleView(id: 10859)
})
