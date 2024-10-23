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
                if viewModel.providers.streamProviders.count > 0 {
                    ProvidersList(title: "Stream", providers: viewModel.providers.streamProviders)
                }
                if viewModel.providers.rentProviders.count > 0 {
                    ProvidersList(title: "Rent", providers: viewModel.providers.rentProviders)
                }
                if viewModel.providers.buyProviders.count > 0 {
                    ProvidersList(title: "Buy", providers: viewModel.providers.buyProviders)
                }
                Spacer()
            }
            .padding()
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
            ScrollView(.horizontal) {
                VStack(alignment: .leading) {
                    HStack {
                        ForEach(providers) { provider in
                            AsyncImage(url: provider.logoPath) { phase in
                                switch phase {
                                case .empty:
                                    Color.gray
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80, alignment: .top)
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                @unknown default:
                                    ProgressView()
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.horizontal, 5)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    ProvidersView(id: 533535)
}
