//
//  ReviewError.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//

import Foundation


enum ReviewError: LocalizedError {
    case missingCredentials
    case invalidURL
    case mockError
    
    var errorDescription: String? {
        switch self {
        case .missingCredentials:
            return "Missing API credentials"
        case .invalidURL:
            return "Invalid URL"
        case .mockError:
            return "Simulated error"
        }
    }
}
