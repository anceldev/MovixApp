//
//  AuthenticationViewModel.swift
//  MovixApp
//
//  Created by Ancel Dev account on 31/7/24.
//

import Foundation
import Observation
import SwiftUI

enum AuthError: Error {
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
    
    var errorMessage: String {
        switch self {
        case .invalidTokenResponse: "Invalid token response"
        case .tokenRequestFailure: "Token request failure"
        case .tokenDecodeFailure: "Token decode failure"
        case .invalidTokenRequest: "Invalid toke request"
        case .statusCodeFailure: "Status code failure"
        case .invalidLoginToken: "Can't login with token"
        case .sessionFailure: "Session failuer"
        case .invalidSession: "Invalid session"
        case .imdbAuthentication: "IMDB Error"
        case .logoutError: "Can't logout account"
        }
    }
}

enum AuthenticationFlow {
    case authenticated
    case authenticating
    case unauthenticated
}

@Observable
class AuthViewModel {
    
    var account: Account?
    var flow: AuthenticationFlow = .unauthenticated

//    let apiKey: String = "4bd71d332c3d3c219fe01c8d465ba03a"
    
    var usernameTMDB: String = ""
    var passwordTMDB: String = ""
    
    private var imdbSession: String = ""
    private var httpHeaderFields: [String : String] = [
        "Accept" : "applicaiton/json",
        "content-type": "application/json",
        "Authorization": "Bearer \("API_KEY")"
    ]
    private var shortHttpHeaderFields: [String : String] = [
        "Accept" : "applicaiton/json",
        "Authorization": "Bearer \("API_KEY")"
    ]
     
    private var timeoutInterval: Double = 10
    
    /// Loads the current session if exists.
    /// Fetchs account data with that session.
    @MainActor
    init(){
        let currentSessionId = UserDefaults.standard.string(forKey: "session_id")
        if currentSessionId != nil {
            self.imdbSession = currentSessionId!
            Task {
                do {
                    try await getAccount(endpoint: .getAccount(sessionId: self.imdbSession))
//                    try await getFavoriteMoviews(page: 1)
                } catch {
                    throw AuthError.imdbAuthentication
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
                    throw AuthError.invalidLoginToken
                }
                guard let sessionId = try await createSession(token: loginToken) else {
                    throw AuthError.invalidSession
                }
                self.imdbSession = sessionId
                UserDefaults.standard.setValue(sessionId, forKey: "session_id")
                try await getAccount(endpoint: .getAccount(sessionId: imdbSession))
//                try await getFavoriteMoviews(page: 1)
            } catch {
                throw AuthError.imdbAuthentication
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
    @MainActor
    private func getAccount(endpoint: AuthEndpoint) async throws {
//        let urlString = "https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=" + self.imdbSession
//        let url = URL(string: urlString)!
        let url = endpoint.url
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print(String(decoding: data, as: UTF8.self))
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
    private func requestIMDBToken(endpoint: AuthEndpoint = .requestToken) async throws -> String {
        let url = endpoint.url
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        request.timeoutInterval = timeoutInterval
        request.allHTTPHeaderFields = shortHttpHeaderFields
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let tokenRequest = try decoder.decode(AuthRequest.self, from: data)
            if !tokenRequest.success! {
                throw AuthError.tokenRequestFailure
            }
            return tokenRequest.token!
        } catch {
            print("DEBUG - Error: Error decoding token")
            throw AuthError.invalidTokenRequest
        }
    }
    
    /// Validates a requested token with login
    /// - Parameter token: requested token
    /// - Returns: validated token
    private func validateRequestTokenWithLogin(endpoint: AuthEndpoint = .validateTokenWithLogin, token: String) async throws -> String? {
        let parameters = [
            "username" : self.usernameTMDB,
            "password" : self.passwordTMDB,
            "request_token" : token,
        ] as [String : Any?]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let url = endpoint.url
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.httpMethod
            request.timeoutInterval = timeoutInterval
            request.allHTTPHeaderFields = httpHeaderFields
            request.httpBody = postData
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let session = try decoder.decode(AuthRequest.self, from: data)
            if !session.success! {
                throw AuthError.sessionFailure
            }
            return session.token
        } catch AuthError.invalidTokenResponse {
            print("DEBUG - \(AuthError.invalidTokenResponse.errorMessage)")
        }
        catch AuthError.sessionFailure {
            print("DEBUG - Error: \(AuthError.sessionFailure.errorMessage)")
        } catch {
            print("DEBUG - Error: Unknown error \(error.localizedDescription)")
            throw AuthError.invalidSession
        }
        return nil
    }
    
    /// Creates a new session on TMDB Api
    /// - Parameter token: requested token
    /// - Returns: session token
    private func createSession(endoint: AuthEndpoint = .createESession, token: String) async throws -> String? {
        let parameters = [
            "request_token": token
        ] as [String : Any?]
        
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let url = endoint.url
        var request = URLRequest(url: url)
        request.httpMethod = endoint.httpMethod
        request.timeoutInterval = timeoutInterval
        request.allHTTPHeaderFields = httpHeaderFields
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
    func deleteIMDBSession(endpoint: AuthEndpoint = .deleteSession) async throws -> Bool {
        let parameters = [
            "session_id": self.imdbSession
        ] as [String : Any?]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let url = endpoint.url
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.httpMethod
            request.timeoutInterval = timeoutInterval
            request.allHTTPHeaderFields = httpHeaderFields
            request.httpBody = postData
            let (data, _ ) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let deleteSession = try decoder.decode(AuthRequest.self, from: data)
            return deleteSession.success!
        } catch AuthError.statusCodeFailure {
            print("DEBUG - Error: \(AuthError.statusCodeFailure.errorMessage)")
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
    func getFavoriteMoviews(page: Int) async throws {
        do {
            let favoriteMovies = try await ApiTMDB.shared.getFavoriteMovies(page: 1, accountId: account?.id ?? 0, sessionId: imdbSession)
            self.account?.favoriteMovies = favoriteMovies
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
extension AuthViewModel {
    enum AuthEndpoint {
        case requestToken
        case validateTokenWithLogin
        case createESession
        case getAccount(sessionId: String)
        case deleteSession
        
        var url: URL {
            let baseURL = "https://api.themoviedb.org/3"
            switch self {
            case .requestToken:
                return URL(string: "\(baseURL)/authentication/token/new?api_key=\("4bd71d332c3d3c219fe01c8d465ba03a")")!
            case .validateTokenWithLogin:
                return URL(string: "\(baseURL)/authentication/token/validate_with_login?api_key=\("4bd71d332c3d3c219fe01c8d465ba03a")")!
            case .createESession:
                return URL(string: "\(baseURL)/authentication/session/new?api_key=\("4bd71d332c3d3c219fe01c8d465ba03a")")!
            case .getAccount(let sessionId):
                return URL(string: "\(baseURL)/account?api_key=\("4bd71d332c3d3c219fe01c8d465ba03a")&session_id=\(sessionId)")!
            case .deleteSession:
                return URL(string: "\(baseURL)/authentication/session?api_key=\("4bd71d332c3d3c219fe01c8d465ba03a")")!
            }
        }
        
        var httpMethod: String {
            switch self {
            case .getAccount, .requestToken:
                return "GET"
            case .validateTokenWithLogin, .createESession:
                return "POST"
            case .deleteSession:
                return "DELETE"
            }
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
