//
//  ApiTMDB.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import Foundation

@Observable
class ApiTMDB {
    
    static var shared = ApiTMDB()
    
    private let apiKey = "api_key=4bd71d332c3d3c219fe01c8d465ba03a"
    private let baseEndpoint = "https://api.themoviedb.org/3/"
    private var lang: Lang = .en
    
    enum Endpoint: String {
        case movie
        case tvSerie = "tv"
        case trending
        case search
    }
    enum Lang: String {
        case en = "language=en-US"
        case es = "language=es-ES"
    }
    enum TimeWindow: String {
        case day
        case week
    }
    
    private func buildUrl(type search: Endpoint, id: Int) -> URL? {
        let endpoint = baseEndpoint + search.rawValue + "/\(id)?" + apiKey + "&" + lang.rawValue
        return URL(string: endpoint)
    }

    func getMovieDetails(id: Int) async -> Movie? {
        do {
            let url = buildUrl(type: .movie, id: id)
            let movie = try await NetworkManager.shared.fetchData(data: Movie.self, from: url)
            return movie
        } catch NetworkError.invalidUrl {
            print("DEBUG - Error: Wrong url provided")
        } catch NetworkError.invalidResponse {
            print("DEBUG - Error: Invalid response form URL")
        } catch NetworkError.invalidData {
            print("DEBUG - Error: Invalid data from response")
        } catch {
            print("DEBUG - Error: Unknown error")
        }
        return nil
    }
    
    
    
    func getTrendingMovies() async -> [Movie] {
        let baseSearch = Endpoint.trending
        let mediaSearch = Endpoint.movie
        let timeWindow = TimeWindow.day
        
        do {
            let urlString = baseEndpoint + baseSearch.rawValue + "/" + mediaSearch.rawValue + "/" + timeWindow.rawValue + "?\(self.apiKey)"
            
            let url = URL(string: urlString)
            let movies = try await NetworkManager.shared.fetchData(data: MoviesCollection.self, from: url)
            return movies.results
        } catch NetworkError.invalidUrl {
            print("DEBUG - Error: Wrong url provided in trneding")
        } catch NetworkError.invalidResponse {
            print("DEBUG - Error: Invalid response form URL")
        } catch NetworkError.invalidData {
            print("DEBUG - Error: Invalid data from response")
        } catch {
            print("DEBUG - Error: Unknown error")
        }
        return []
    }
    
    func searchMovies(searchTerm: String) async throws -> [Movie] {
        let endpoint = Endpoint.search
        let mediaSearch = Endpoint.movie
        let query = "query=" + searchTerm
        do {
            let urlString = baseEndpoint + endpoint.rawValue + "/" + mediaSearch.rawValue + "?" + apiKey + "&" + query
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidUrl
            }
            let collection = try await NetworkManager.shared.fetchData(data: MoviesCollection.self, from: url)
            return collection.results
            
        } catch NetworkError.invalidUrl {
            print("DEBUG - Error: Wrong url provided in trneding")
        } catch NetworkError.invalidResponse {
            print("DEBUG - Error: Invalid response form URL")
        } catch NetworkError.invalidData {
            print("DEBUG - Error: Invalid data from response")
        } catch {
            print("DEBUG - Error: Unknown error")
        }
        return []
    }
    
    func getCasting(id: Int) async throws -> [Cast] {
        let mediaSerch = Endpoint.movie
        do {
            let urlString = baseEndpoint + mediaSerch.rawValue + "/\(id)/credits?" + apiKey
            print(urlString)
            guard let url = URL(string: urlString) else { throw NetworkError.invalidUrl }
            let credits = try await NetworkManager.shared.fetchData(data: Credits.self, from: url)
            return credits.cast
        } catch NetworkError.invalidUrl {
            print("DEBUG - Error: Wrong url provided in casting")
        } catch NetworkError.invalidResponse {
            print("DEBUG - Error: Invalid response form URL")
        } catch NetworkError.invalidData {
            print("DEBUG - Error: Invalid data from response")
        } catch {
            print("DEBUG - Error: Unknown error")
        }
        return []
    }
}
