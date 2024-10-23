//
//  Provider.swift
//  MovixApp
//
//  Created by Ancel Dev account on 7/8/24.
//

import Foundation

struct Providers: Decodable {
    var rentProviders: [Provider]
    var buyProviders: [Provider]
    var streamProviders: [Provider]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    enum CountryCodes: String, CodingKey {
        case ES
    }
    enum ProviderTypes: String, CodingKey {
        case rent, buy, flatrate
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resultsContainer = try container.nestedContainer(keyedBy: CountryCodes.self, forKey: .results)
        let esContainer = try resultsContainer.nestedContainer(keyedBy: ProviderTypes.self, forKey: .ES)
        self.rentProviders = try esContainer.decodeIfPresent([Provider].self, forKey: .rent) ?? []
        self.buyProviders = try esContainer.decodeIfPresent([Provider].self, forKey: .buy) ?? []
        self.streamProviders = try esContainer.decodeIfPresent([Provider].self, forKey: .flatrate) ?? []
    }
    init() {
        self.rentProviders = []
        self.buyProviders = []
        self.streamProviders = []
    }
}

extension Providers {
    struct Provider: Identifiable, Decodable {
        let id: Int
        let providerName: String
        let providerPriority: Int
        let logoPath: URL?
        
        enum CodingKeys: String, CodingKey {
            case id = "provider_id"
            case providerName = "provider_name"
            case providerPriority = "display_priority"
            case logoPath = "logo_path"
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Providers.Provider.CodingKeys> = try decoder.container(keyedBy: Providers.Provider.CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: CodingKeys.id)
            self.providerName = try container.decode(String.self, forKey: CodingKeys.providerName)
            self.providerPriority = try container.decode(Int.self, forKey: CodingKeys.providerPriority)
            let logoUrl = try container.decodeIfPresent(String.self, forKey: CodingKeys.logoPath)
            self.logoPath = URL(string: "https://image.tmdb.org/t/p/w500" + (logoUrl ?? "")) 
        }
    }
}
