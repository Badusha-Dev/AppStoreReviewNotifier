//
//  JWTGenerator.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 05/11/24.
//


import Foundation
import SwiftJWT

/// A struct representing the claims that will be included in the JWT.
/// Conforms to the `Claims` protocol, which is typically used with JWT libraries.
struct MyClaims: Claims {
    let iss: String  // The issuer ID
    let exp: Date    // Expiration date for the JWT token
    let aud: String  // Audience for which the token is intended, in this case, "appstoreconnect-v1"
}

/// A class responsible for generating signed JSON Web Tokens (JWT) for use in authenticated requests.
class JWTGenerator {
    private let issuerID: String  // The issuer ID used in the claims, uniquely identifying the entity issuing the JWT
    private let keyID: String     // The key ID used in the JWT header, identifying the private key for signing
    private let privateKey: Data  // The private key data used to sign the JWT, loaded from the app bundle
    
    /// Initializes a new instance of `JWTGenerator`.
    ///
    /// - Parameters:
    ///   - issuerID: A `String` representing the issuer ID for the token.
    ///   - keyID: A `String` representing the key ID for the token.
    ///   - keyFileName: The name of the private key file in the app bundle (must be a `.p8` file).
    /// - Throws: An error if the private key file cannot be found or loaded.
    init(issuerID: String, keyID: String, keyFileName: String) throws {
        self.issuerID = issuerID
        self.keyID = keyID
        
        // Load the private key from the app bundle
        guard let keyURL = Bundle.main.url(forResource: keyFileName, withExtension: "p8") else {
            throw NSError(domain: "JWTGenerator", code: -1, userInfo: [NSLocalizedDescriptionKey: "Private key file not found in bundle."])
        }
        self.privateKey = try Data(contentsOf: keyURL)
    }

    /// Generates a signed JWT with claims for authenticated API requests.
    ///
    /// - Returns: A tuple containing the signed JWT as a `String` and its expiration date as a `Date`.
    /// - Throws: An error if the JWT creation or signing process fails.
    func generateJWT() throws -> (String, Date) {
        // Create the claims with expiration time set to 20 minutes from now
        let expirationTime = Date().addingTimeInterval(20 * 60) // Token valid for 20 minutes
        let claims = MyClaims(iss: issuerID, exp: expirationTime, aud: "appstoreconnect-v1")

        // Create the JWT header with the key ID
        var header = Header()
        header.kid = keyID

        // Create the JWT with header and claims
        var jwt = JWT(header: header, claims: claims)

        // Sign the JWT with ES256 algorithm using the private key
        let jwtSigner = JWTSigner.es256(privateKey: privateKey)
        let signedJWT = try jwt.sign(using: jwtSigner)

        return (signedJWT, expirationTime)
    }
}
