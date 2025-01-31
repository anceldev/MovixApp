//
//  HTTPClient.swift
//  MovixApp
//
//  Created by Ancel Dev account on 24/1/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badRequest
    case serverError(String)
    case decodingError
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Unable to pferform request", comment: "badRequestError")
        case .serverError(let errorMessage):
            return NSLocalizedString(errorMessage, comment: "serverError")
        case .decodingError:
            return NSLocalizedString("Unable to decode succesfully", comment: "decidingError")
        case .invalidResponse:
            return NSLocalizedString("Invalid response", comment: "invalidResponse")
        }
    }
}
