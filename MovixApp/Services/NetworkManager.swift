//
//  NetworkManager.swift
//  MovixApp
//
//  Created by Ancel Dev account on 25/7/24.
//

import Foundation
import Observation





@Observable
class NetworkManager {
    static let shared = NetworkManager()
    
    @MainActor
    func fetchData<T: Decodable>(data: T.Type, from url: URL?) async throws -> T {
        guard let url = url else {
            throw NetworkErrorA.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkErrorA.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkErrorA.invalidData
        }
    }    
}
