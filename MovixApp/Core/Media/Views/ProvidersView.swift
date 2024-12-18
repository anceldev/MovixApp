//
//  ProvidersView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 23/10/24.
//

import SwiftUI

struct ProvidersView: View {
    let viewModel: ProvidersViewModel
    
    init(id: Int) {
        self.viewModel = ProvidersViewModel(id: id)
    }
    var body: some View {
        ZStack(alignment: .top) {
            BannerTopBar(true)
            VStack {
                ProvidersList(title: "Stream", providers: viewModel.providers.streamProviders)
                    .background(.clear)
                ProvidersList(title: "Rent", providers: viewModel.providers.rentProviders)
                    .background(.clear)
                ProvidersList(title: "Buy", providers: viewModel.providers.buyProviders)
                    .background(.clear)
                Spacer()
            }
            .padding(24)
            .padding(.top, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.bw10)
    }
    @ViewBuilder
    func ProvidersList(title: String, providers: [Providers.Provider]) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.bw50)
            if providers.count > 0 {
                FlowLayout(spacing: 24) {
                    ForEach(providers) { provider in
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
                        .clipShape(RoundedRectangle(cornerRadius: 15))
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
    ProvidersView(id: 533535)
}
