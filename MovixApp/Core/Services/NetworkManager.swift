//
//  NetworkManager.swift
//  MovixApp
//
//  Created by Ancel Dev account on 25/7/24.
//

import Foundation
import Observation



enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}

@Observable
class NetworkManager {
    static let shared = NetworkManager()
    
    @MainActor
    func fetchData<T: Decodable>(data: T.Type, from url: URL?) async throws -> T {
        guard let url = url else {
            throw NetworkError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }    
}
