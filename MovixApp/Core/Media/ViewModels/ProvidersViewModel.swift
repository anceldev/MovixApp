//
//  ProvidersViewModel.swift
//  MovixApp
//
//  Created by Ancel Dev account on 23/10/24.
//

import Foundation

@Observable
final class ProvidersViewModel {
    var providers: Providers
    
    init(id: Int) {
        self.providers = .init()
        getProviders(id: id)
    }
    func getProviders(id: Int) {
        Task {
            let providers = try await ApiTMDB.shared.getMediaProviders(id: id)
            if providers != nil {
                self.providers = providers!
            }
        }
    }
}
