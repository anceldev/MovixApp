//
//  ProvidersScreen.swift
//  MovixApp
//
//  Created by Ancel Dev account on 23/10/24.
//

import SwiftUI

struct ProvidersScreen: View {
    let viewModel: ProvidersViewModel
    
    init(id: Int) {
        self.viewModel = ProvidersViewModel(id: id)
    }
    var body: some View {
//        ZStack(alignment: .top) {
            VStack {
                BannerTopBar(true)
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Providers")
                            .font(.system(size: 32, weight: .medium))
                        ProvidersList(title: "Stream", providers: viewModel.providers.streamProviders)
                            .background(.clear)
                        ProvidersList(title: "Rent", providers: viewModel.providers.rentProviders)
                            .background(.clear)
                        ProvidersList(title: "Buy", providers: viewModel.providers.buyProviders)
                            .background(.clear)
                        Spacer()
                    }
//                    .padding(24)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
//                    .padding(.top, 40)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Spacer()
                }
                .scrollIndicators(.hidden)
            }
            .background(.bw10)
            .frame(maxHeight: .infinity)
            .swipeToDismiss()
//        }
//        .background(.bw10)
    }
    @ViewBuilder
    func ProvidersList(title: String, providers: [Providers.Provider]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.bw50)
            if providers.count > 0 {
                FlowLayout(spacing: 24) {
                    ForEach(providers) { provider in
                        ZStack {
//                            LinearGradient(colors: [.bw50, .bw90], startPoint: .top, endPoint: .bottom)
//                                .aspectRatio(1/1, contentMode: .fill)
//                            ProgressView()
                            AsyncImage(url: provider.logoPath) { phase in
                                switch phase {
                                case .empty:
                                    Color.gray
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 75, height: 75, alignment: .top)
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                @unknown default:
                                    ProgressView()
                                }
                            }
                        }
                        .background(content: {
                            LinearGradient(colors: [.bw50, .bw90], startPoint: .top, endPoint: .bottom)
                        })
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(width: 75, height: 75)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .scrollIndicators(.hidden)
            } else {
                Text("No available \(title.lowercased()) providers in your region")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 16)
            }
        }
    }
}

#Preview {
    ProvidersScreen(id: 533535)
}
