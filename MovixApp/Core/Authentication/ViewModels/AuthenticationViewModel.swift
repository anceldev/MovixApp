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
    
    var usernameTMDB = ""
    var passwordTMDB = ""
    
    init(){
        print("Reinit the viewmodel")
        let currentSessionId = UserDefaults.standard.string(forKey: "session_id")
        if currentSessionId != nil {
            print("There is a existing session")
            self.imdbSession = currentSessionId!
            Task {
                do {
                    try await getAccount()
                } catch {
                    throw AuthenticationError.imdbAuthentication
                }
            }
        } else {
            print("No session in userdefaults")
        }
    }

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
            } catch {
                throw AuthenticationError.imdbAuthentication
            }
        }
    }
    @MainActor
    func logoutTMDB() async throws {
        do {
            if try await deleteIMDBSession() {
                self.imdbSession = ""
                self.account = nil
                self.flow = .unauthenticated
                print(self.flow)
                UserDefaults.standard.removeObject(forKey: "session_id")
            }
        } catch {
            print("DEBUG - Error: \(error.localizedDescription)")
        }
    }
    
    private func getAccount() async throws {
        let urlString = "https://api.themoviedb.org/3/account?api_key=4bd71d332c3d3c219fe01c8d465ba03a&session_id=" + self.imdbSession
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
    
    /// Token request for authenticaition
    private func requestIMDBToken() async throws -> String {
        let url = URL(string: "https://api.themoviedb.org/3/authentication/token/new")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept" : "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YmQ3MWQzMzJjM2QzYzIxOWZlMDFjOGQ0NjViYTAzYSIsIm5iZiI6MTcyMjQ1MTMyMS4yMjE4MDMsInN1YiI6IjY0YTkzNDliOWM5N2JkMDBlMjRiZDZiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.t1LQyZhqY0MN99uNRhlQtbrL0DUFgFu2xFNW4bbZguM"
        ]
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            let tokenRequest = try decoder.decode(AuthRequest.self, from: data)
            if !tokenRequest.success  {
                throw AuthenticationError.tokenRequestFailure
            }
            
            return tokenRequest.token!
        } catch {
            print("DEBUG - Error: Error decoding token")
            throw AuthenticationError.invalidTokenRequest
        }
    }
    /// Validates rquest token with Login
    private func validateRequestTokenWithLogin(token: String) async throws -> String? {
        let parameters = [
            "username": self.usernameTMDB,
            "password": self.passwordTMDB,
            "request_token": token,
        ] as [String : Any?]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let url = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "content-type": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YmQ3MWQzMzJjM2QzYzIxOWZlMDFjOGQ0NjViYTAzYSIsIm5iZiI6MTcyMjQ1MTMyMS4yMjE4MDMsInN1YiI6IjY0YTkzNDliOWM5N2JkMDBlMjRiZDZiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.t1LQyZhqY0MN99uNRhlQtbrL0DUFgFu2xFNW4bbZguM"
            ]
            
            request.httpBody = postData
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            let session = try decoder.decode(AuthRequest.self, from: data)
            if !session.success {
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
    /// Creates Session
    private func createSession(token: String) async throws -> String? {
        let parameters = [
            "request_token": token
        ] as [String : Any?]
        
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YmQ3MWQzMzJjM2QzYzIxOWZlMDFjOGQ0NjViYTAzYSIsIm5iZiI6MTcyMjQ0MDM0OC44NDI4NTEsInN1YiI6IjY0YTkzNDliOWM5N2JkMDBlMjRiZDZiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Cz_krlX8drLX97S8-MOZJfD-HZmJFjesNNRBDmeS0q0"
        ]
        request.httpBody = postData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let session = try decoder.decode(AuthRequest.self, from: data)
        if session.success && session.sessionId != nil {
            return session.sessionId!
        }
        return nil
    }
    
    func deleteIMDBSession() async throws -> Bool {
        let parameters = [
            "session_id": self.imdbSession
        ] as [String : Any?]
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let url = URL(string: "https://api.themoviedb.org/3/authentication/session")!
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "content-type": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YmQ3MWQzMzJjM2QzYzIxOWZlMDFjOGQ0NjViYTAzYSIsIm5iZiI6MTcyMjQ1MTMyMS4yMjE4MDMsInN1YiI6IjY0YTkzNDliOWM5N2JkMDBlMjRiZDZiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.t1LQyZhqY0MN99uNRhlQtbrL0DUFgFu2xFNW4bbZguM"
            ]
            request.httpBody = postData
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let deleteSession = try decoder.decode(AuthRequest.self, from: data)
            return deleteSession.success
        } catch AuthenticationError.statusCodeFailure {
            print("DEBUG - Error: status code failed")
        } catch {
            print("DEBUG - Error: \(error.localizedDescription)")
        }
        return false
    }
    
}

extension AuthenticationViewModel {
    
    struct Account: Decodable {
        var id: Int
        var name: String
        var username: String
    }
    
    struct AuthRequest: Decodable {
        let success: Bool
        let expiresAt: Date?
        let token: String?
        let sessionId: String?
        
        enum CodingKeys: String, CodingKey {
            case success
            case expiresAt = "expires_at"
            case requestToken = "request_token"
            case sessionId = "session_id"
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
        }
    }
}
