//
//  TokenManager.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 05/11/24.
//

import Foundation

/// Note: It is generally recommended to handle token generation on the backend side.
/// Storing and retrieving sensitive credentials and private keys directly within an app
/// poses significant security vulnerabilities, as it increases the risk of unauthorized access.

class TokenManager {
    
    // Constants for the JWT generation process
    let issuerID = "b2dsmc-ncncks-mkls-4u93-sample"  // The issuer ID required for generating the JWT
    let keyID = "SampleKeyID"                        // The key ID associated with the private key for JWT
    let keyFileName = "AuthKey_Sample64564"          // The filename of the private key used to sign the JWT
    
    /// Stores the token and its expiration date in UserDefaults for future use.
    /// - Parameters:
    ///   - token: The JWT token to store.
    ///   - expirationDate: The date when the token expires.
    func storeToken(_ token: String, expirationDate: Date) {
        UserDefaults.standard.set(token, forKey: "jwtToken")
        UserDefaults.standard.set(expirationDate, forKey: "jwtTokenExpirationDate")
    }
    
    /// Retrieves a valid token from storage if it hasn't expired.
    /// - Returns: The stored JWT token if valid; otherwise, `nil`.
    func getValidToken() -> String? {
        let defaults = UserDefaults.standard

        if let token = defaults.string(forKey: "jwtToken"),
           let expirationDate = defaults.object(forKey: "jwtTokenExpirationDate") as? Date {
            // Check if the token is still valid by comparing the current date to the expiration date
            if Date() < expirationDate {
                return token
            }
        }
        return nil
    }

    /// Fetches a JWT token, either returning a valid stored token or generating a new one if needed.
    /// - Returns: A JWT token as a `String`, or `nil` if there was an error generating it.
    func fetchToken() -> String? {
        if let validToken = getValidToken() {
            // Return the existing valid token if available
            return validToken
        } else {
            do {
                // Attempt to generate a new JWT token if no valid one is stored
                let jwtGenerator = try JWTGenerator(issuerID: issuerID, keyID: keyID, keyFileName: keyFileName)
                let (token, expirationDate) = try jwtGenerator.generateJWT()
                
                // Store the new token and expiration date for future use
                storeToken(token, expirationDate: expirationDate)
                return token
            } catch {
                // Handle errors in generating the JWT token
                print("Error generating JWT: \(error)")
                return nil
            }
        }
    }
}
