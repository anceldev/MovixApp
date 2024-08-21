//
//  Provider.swift
//  MovixApp
//
//  Created by Ancel Dev account on 7/8/24.
//

import Foundation

struct Providers: Decodable {
    var providers: [Provider]
    
    enum CodingKeys: String, CodingKey {
        case providers = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.providers = try container.decode([Providers.Provider].self, forKey: .providers)
    }
}

extension Providers {
    struct Provider: Identifiable, Decodable {
        let id: Int
        let providerName: String
        let logoPath: URL?
        
        enum CodingKeys: String, CodingKey {
            case id = "provider_id"
            case providerName = "provider_name"
            case logoPath = "logo_path"
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<Providers.Provider.CodingKeys> = try decoder.container(keyedBy: Providers.Provider.CodingKeys.self)
            
            self.id = try container.decode(Int.self, forKey: Providers.Provider.CodingKeys.id)
            self.providerName = try container.decode(String.self, forKey: Providers.Provider.CodingKeys.providerName)
            let logoPath = try container.decodeIfPresent(String.self, forKey: Providers.Provider.CodingKeys.logoPath)
            
            self.logoPath = URL(string: "https://image.tmdb.org/t/p/w500" + (logoPath ?? "")) 
        }
    }
}
