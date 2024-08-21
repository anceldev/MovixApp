//
//  AuthenticationViewModel.swift
//  MovixApp
//
//  Created by Ancel Dev account on 31/7/24.
//

import Foundation
import Observation
import SwiftUI

enum AuthenticationError: Error {
    case invalidTokenResponse
    case tokenRequestFailure
    case tokenDecodeFailure
    case invalidTokenRequest
    
    case statusCodeFailure
    
    case invalidLoginToken
    
    case sessionFailure
    case invalidSession
    
    case imdbAuthentication
    
    case logoutError
}

enum AuthenticationFlow {
    case authenticated
    case authenticating
    case unauthenticated
}

@Observable
class AuthenticationViewModel {
    
    var account: Account?
    var flow: AuthenticationFlow = .unauthenticated
    
    private var imdbSession = ""
    private let apiKey = "4bd71d332c3d3c219fe01c8d465ba03a"
    
    var usernameTMDB = ""
    var passwordTMDB = ""
    
    
    
    /// Loads the current session if exists.
    /// Fetchs account data with that session.
    init(){
        let currentSessionId = UserDefaults.standard.string(forKey: "session_id")
        
        if currentSessionId != nil {
            self.imdbSession = currentSessionId!
            Task {
                do {
                    try await getAccount()
                    try await getFavoriteMoviews(page: 1)
                } catch {
                    throw AuthenticationError.imdbAuthentication
                }
            }
        } else {
            print("No session in userdefaults")
        }
    }

    
    /// Login account
    /// First request a IMDB token, validates the token with loging and creates a session with that validated token.
    /// Once the session has been created, it saves the session token in memory.
    @MainActor
    func loginTMDB() async throws {
        self.flow = .authenticating
        Task {
            do {
                let token = try await requestIMDBToken()
                guard let loginToken = try await validateRequestTokenWithLogin(token: token) else {
                    throw AuthenticationError.invalidLoginToken
                }
                guard let sessionId = try await createSession(token: loginToken) else {
                    throw AuthenticationError.invalidSession
                }
                self.imdbSession = sessionId
                UserDefaults.standard.setValue(sessionId, forKey: "session_id")
                try await getAccount()
                try await getFavoriteMoviews(page: 1)
            } catch {
                throw AuthenticationError.imdbAuthentication
            }
        }
    }
    
    
    /// Log out the curren user
    @MainActor
    func logoutTMDB() async throws {
        do {
            if try await deleteIMDBSession() {
                self.imdbSession = ""
                self.account = nil
                self.flow = .unauthenticated
                UserDefaults.standard.removeObject(forKey: "session_id")
            }
        } catch {
            print("DEBUG - Error: \(error.localizedDescription)")
        }
    }
    
    
    /// Get the user account info using the session token
    private func getAccount() async throws {
        let urlString = "https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=" + self.imdbSession
        let url = URL(string: urlString)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let account = try decoder.decode(Account.self, from: data)
            self.account = account
            self.flow = .authenticated
        } catch {
            print("DEBUG - Error: Fail getting account")
            print(error.localizedDescription)
        }
    }
    
    
    /// Request a token for login
    /// - Returns: token
    private func requestIMDBToken() async throws -> String {
        let url = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "Accept" : "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let tokenRequest = try decoder.decode(AuthRequest.self, from: data)
            if !tokenRequest.success!  {
                throw AuthenticationError.tokenRequestFailure
            }
            return tokenRequest.token!
        } catch {
            print("DEBUG - Error: Error decoding token")
            throw AuthenticationError.invalidTokenRequest
        }
    }
    
    
    /// Validates a requested token with login
    /// - Parameter token: requested token
    /// - Returns: validated token
    private func validateRequestTokenWithLogin(token: String) async throws -> String? {
        let parameters = [
            "username": self.usernameTMDB,
            "password": self.passwordTMDB,
            "request_token": token,
        ] as [String : Any?]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let url = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(apiKey)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "content-type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ]
            request.httpBody = postData
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let session = try decoder.decode(AuthRequest.self, from: data)
            if !session.success! {
                throw AuthenticationError.sessionFailure
            }
            return session.token
        } catch AuthenticationError.invalidTokenResponse {
            print("DEBUG - Error: Invalid response")
        } catch AuthenticationError.sessionFailure {
            print("DEBUG - Error: Invalid session")
        } catch {
            print("DEBUG - Error: Unknown error \(error.localizedDescription)")
            throw AuthenticationError.invalidSession
        }
        return nil
    }
    
    /// Creates a new session on TMDB Api
    /// - Parameter token: requested token
    /// - Returns: session token
    private func createSession(token: String) async throws -> String? {
        let parameters = [
            "request_token": token
        ] as [String : Any?]
        
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        request.httpBody = postData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let session = try decoder.decode(AuthRequest.self, from: data)
        if session.success! && session.sessionId != nil {
            return session.sessionId!
        }
        return nil
    }
    
    /// Deletes the current session in TMDB
    /// - Returns: `true` if session is deletes succesfully
    func deleteIMDBSession() async throws -> Bool {
        let parameters = [
            "session_id": self.imdbSession
        ] as [String : Any?]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let url = URL(string: "https://api.themoviedb.org/3/authentication/session?api_key=\(apiKey)")!
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "content-type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ]
            request.httpBody = postData
            
            let (data, _ ) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let deleteSession = try decoder.decode(AuthRequest.self, from: data)
            return deleteSession.success!
        } catch AuthenticationError.statusCodeFailure {
            print("DEBUG - Error: status code failed")
        } catch {
            print("DEBUG - Error: \(error.localizedDescription)")
        }
        return false
    }
    
    
    /// Adds an item to favorites list
    /// - Parameters:
    ///   - id: item to favorite
    ///   - mediaType: media type of item. ``ApiTMDB.MediaType``
    ///   - isFavorite: `true` or `false` the item
    @MainActor
    func toggleFavorite(id: Int, mediaType: ApiTMDB.MediaType, isFavorite: Bool) async throws {
        do {
            let statusCode = try await ApiTMDB.shared.toggleFavorite(id: id, mediaType: .movie, isFavorite: isFavorite, accountId: account?.id ?? 0, sessionId: imdbSession)
            switch statusCode {
            case 1:
                self.account?.favoriteMovies = try await ApiTMDB.shared.getFavoriteMovies(page: 1, accountId: account?.id ?? 0, sessionId: imdbSession)
            case 13:
                self.account?.favoriteMovies = self.account?.favoriteMovies?.filter { $0.id != id }
            default:
                print("Error")
            }
        } catch {
            print("DEBUG - Error: \(error.localizedDescription)")
        }
    }
    
    
    /// Fetch user's favorite movies
    /// - Parameter page: selected page
    @MainActor
    func getFavoriteMoviews(page: Int) async throws {
        do {
            self.account?.favoriteMovies = try await ApiTMDB.shared.getFavoriteMovies(page: 1, accountId: account?.id ?? 0, sessionId: imdbSession)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
}


/// Model for requests response
struct AuthRequest: Decodable {
    let success: Bool?
    let expiresAt: Date?
    let token: String?
    let sessionId: String?
    
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
        case sessionId = "session_id"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.success = try values.decode(Bool.self, forKey: .success)
        if let expiresDate = try values.decodeIfPresent(String.self, forKey: .expiresAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.expiresAt = dateFormatter.date(from: expiresDate)
        } else {
            self.expiresAt = nil
        }
        self.token = try values.decodeIfPresent(String.self, forKey: .requestToken)
        self.sessionId = try values.decodeIfPresent(String.self, forKey: .sessionId)
        self.statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        self.statusMessage = try values.decodeIfPresent(String.self, forKey: .statusMessage)
    }
}
