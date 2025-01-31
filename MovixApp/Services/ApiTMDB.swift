//
//  ApiTMDB.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import Foundation

enum NetworkErrorA: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
    case invalidUrlRequest
}

@Observable
class ApiTMDB {
    static var shared = ApiTMDB()

    private let apiKey = "4bd71d332c3d3c219fe01c8d465ba03a"
    private let baseEndpoint = "https://api.themoviedb.org/3/"
    private var lang: Lang = .en
    
    private func buildUrl(type search: Endpoint, id: Int) -> URL? {
        let endpoint = baseEndpoint + search.rawValue + "/\(id)?api_key=" + apiKey + "&" + lang.rawValue
        return URL(string: endpoint)
    }

    @MainActor
    func getMovieDetails(id: Int) async -> Movie? {
        do {
            let url = buildUrl(type: .movie, id: id)!
            let request = URLRequest(url: url)
            let movie = try await fetchData(data: Movie.self, from: request)
            return movie
        } catch NetworkErrorA.invalidUrl {
            print("DEBUG - Error: Wrong url provided")
        } catch NetworkErrorA.invalidResponse {
            print("DEBUG - Error: Invalid response form URL")
        } catch NetworkErrorA.invalidData {
            print("DEBUG - Error: Invalid data from response")
        } catch {
            print("DEBUG - Error: Unknown error")
        }
        return nil
    }
    
    func rateMovie(rate: Double, sessionId: String) async throws {
        let postData = Data("{\"value\":\(rate)".utf8)
        let url = URL(string: "https://api.themoviedb.org/3/movie/movie_id/rating?session_id=\(sessionId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Content-Type": "application/json;charset=utf-8",
          "Authorization": "Bearer \(apiKey)"
        ]
        request.httpBody = postData
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
        } catch {
            print(error.localizedDescription)
            print("No rated movie")
        }

    }

    @MainActor
    func getTrendingMovies(page: Int) async -> [Movie] {
        let baseSearch = Endpoint.trending
        let mediaSearch = Endpoint.movie
        let timeWindow = TimeWindow.day
        
        do {
            let urlString = baseEndpoint + baseSearch.rawValue + "/" + mediaSearch.rawValue + "/" + timeWindow.rawValue + "?api_key=\(self.apiKey)" + "&page=\(page)"
            guard let url = URL(string: urlString) else {
                throw NetworkErrorA.invalidUrl
            }
            let request = URLRequest(url: url)
            let movies = try await fetchData(data: MoviesCollection.self, from: request)
            return movies.results
        } catch NetworkErrorA.invalidUrl {
            print("DEBUG - Error: Wrong url provided in trneding")
        } catch NetworkErrorA.invalidResponse {
            print("DEBUG - Error: Invalid response form URL")
        } catch NetworkErrorA.invalidData {
            print("DEBUG - Error: Invalid data from response")
        } catch {
            print("DEBUG - Error: Unknown error")
        }
        return []
    }
    
    @MainActor
    func searchMovies(searchTerm: String) async throws -> [Movie] {
        let endpoint = Endpoint.search
        let mediaSearch = Endpoint.movie
        let query = "query=" + searchTerm
        do {
            let urlString = baseEndpoint + endpoint.rawValue + "/" + mediaSearch.rawValue + "?api_key=" + apiKey + "&" + query
            
            guard let url = URL(string: urlString) else {
                throw NetworkErrorA.invalidUrl
            }
            let request = URLRequest(url: url)
            let collection = try await fetchData(data: MoviesCollection.self, from: request)
            return collection.results
            
        } catch NetworkErrorA.invalidUrl {
            print("DEBUG - Error: Wrong url provided in trneding")
        } catch NetworkErrorA.invalidResponse {
            print("DEBUG - Error: Invalid response form URL")
        } catch NetworkErrorA.invalidData {
            print("DEBUG - Error: Invalid data from response")
        } catch {
            print("DEBUG - Error: Unknown error")
        }
        return []
    }
    
    func getMovieGenres(for media: Endpoint) async throws -> [Genre] {
        let endpoint = baseEndpoint + media.rawValue + "api_key=" + apiKey
        do {
            guard let url = URL(string: endpoint) else { throw NetworkErrorA.invalidUrl }
            let request = URLRequest(url: url)
            let genres = try await fetchData(data: Genres.self, from: request)
            return genres.genres
        } catch NetworkErrorA.invalidUrl {
            print("DEBUG - Error: Wrong url provided")
        } catch {
            print("DEBUG - Error: error in network manager \(error.localizedDescription)")
        }
        return []
    }
    
    @MainActor
    func setFavoriteMovie(for id: Int, account accountId: Int, withSession session: String) {
        let endpoint = "https://api.themoviedb.org/3/account/\(accountId)/favorite?\(session)"
        print(endpoint)
    }
    
    func getCasting(id: Int) async throws -> [Cast] {
        let mediaSerch = Endpoint.movie
        do {
            let urlString = baseEndpoint + mediaSerch.rawValue + "/\(id)/credits?api_key=" + apiKey
            guard let url = URL(string: urlString) else { throw NetworkErrorA.invalidUrl }
            let request = URLRequest(url: url)
            let credits = try await fetchData(data: Credits.self, from: request)
            return credits.cast
        } catch NetworkErrorA.invalidUrl {
            print("DEBUG - Error: Wrong url provided in casting")
        } catch NetworkErrorA.invalidResponse {
            print("DEBUG - Error: Invalid response form URL")
        } catch NetworkErrorA.invalidData {
            print("DEBUG - Error: Invalid data from response")
        } catch {
            print("DEBUG - Error: Unknown error")
        }
        return []
    }
    
    func getPeople(id: Int) async throws -> People? {
        let personSearch = Endpoint.people
        do {
            let urlString = baseEndpoint + personSearch.rawValue + "/\(id)?api_key=" + apiKey
            guard let url = URL(string: urlString) else { throw NetworkErrorA.invalidUrl }
            let request = URLRequest(url: url)
            let person = try await fetchData(data: People.self, from: request)
            return person
        } catch NetworkErrorA.invalidUrl {
            print("DEBUG - Error: Wrong url provided in casting")
        } catch NetworkErrorA.invalidResponse {
            print("DEBUG - Error: Invalid response form URL")
        } catch NetworkErrorA.invalidData {
            print("DEBUG - Error: Invalid data from response")
        } catch {
            print("DEBUG - Error: Unknown error")
        }
        return nil
    }
    /// Gets favorites movies list of account
    func getFavoriteMovies(page: Int, accountId: Int, sessionId: String) async throws -> [Movie] {
        let url = URL(string: "https://api.themoviedb.org/3/account/\(accountId)/favorite/movies")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "\(page)"),
          URLQueryItem(name: "sort_by", value: "created_at.asc"),
          URLQueryItem(name: "api_key", value: apiKey),
          URLQueryItem(name: "session_id", value: sessionId)
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(apiKey)"
        ]
        let favoriteMovies = try await fetchData(data: MoviesCollection.self, from: request)
        return favoriteMovies.results
    }
    
    @MainActor
    /// Add or remove a movie to favorites list of related account
    func toggleFavorite(id: Int, mediaType: MediaType, isFavorite: Bool, accountId: Int, sessionId: String) async throws -> Int {
        let parameters = [
            "media_type": mediaType.rawValue,
            "media_id": id,
            "favorite": !isFavorite
        ] as [String: Any?]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let url = URL(string: "https://api.themoviedb.org/3/account/\(accountId)/favorite?api_key=\(apiKey)&session_id=\(sessionId)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "content-type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ]
            request.httpBody = postData
            let (data, response ) = try await URLSession.shared.data(for: request)
            print(response)
            let decoder = JSONDecoder()
            let addedToFavorites = try decoder.decode(AuthRequest.self, from: data)
            if addedToFavorites.statusCode == 1 {
                print("Added to favorites")
            } else {
                print("Deleted from favorites")
            }
            print(addedToFavorites)
            guard let statusCode =  addedToFavorites.statusCode else { return -1 }
            return statusCode
        } catch {
            print("DEBUG - Error: \(error.localizedDescription)")
            return -2
        }
    }
    
    func getMediaProviders(id: Int) async throws -> Providers? {
        do {
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/watch/providers?api_key=\(apiKey)")!
            let request = URLRequest(url: url)
            let providers = try await fetchData(data: Providers.self, from: request)
            return providers
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func fetchData<T: Decodable>(data: T.Type, from request: URLRequest) async throws -> T {

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let _ = response as? HTTPURLResponse else {
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

extension ApiTMDB {
    enum Endpoint: String {
        case movie
        case tvSerie = "tv"
        case trending
        case search
        case people = "person"
        case movieGenres = "genre/movie/list?"
        case tvGenres = "genre/tv/list?"
    }
//    enum MediaType: String {
//        case movie
//        case tv
//    }
    enum Lang: String {
        case en = "language=en-US"
        case es = "language=es-ES"
    }
//    enum TimeWindow: String {
//        case day
//        case week
//    }
}
