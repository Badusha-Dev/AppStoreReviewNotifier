//
//  AppStoreReviewsService.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//

import Foundation

/// A protocol defining the methods required for fetching app reviews from a paginated API.
protocol ReviewsService {
    /// The next page link for paginated results. If `nil`, there are no more pages to fetch.
    var nextPage: APILinks? { get set }
    
    /// Fetches the first page of reviews.
    /// - Returns: An array of `Review` objects representing the fetched reviews.
    /// - Throws: An error if the fetch request fails.
    func fetchReviews() async throws -> [Review]
    
    /// Fetches the next page of reviews based on the `nextPage` link.
    /// - Returns: An array of `Review` objects representing the fetched reviews.
    /// - Throws: An error if the fetch request fails or there is no `nextPage`.
    func fetchNextReviews() async throws -> [Review]
}

/// A concrete implementation of `ReviewsService` that fetches app reviews from the App Store Connect API.
class AppStoreReviewsService: ReviewsService {
    
    /// The link to the next page of reviews in the paginated API response.
    var nextPage: APILinks?
    
    private let settings: SettingsService  // Provides the app's unique identifier and other settings.
    private var tokenManager: TokenManager // Manages the JWT token for authorization.
    
    /// Initializes a new instance of `AppStoreReviewsService`.
    ///
    /// - Parameters:
    ///   - settings: An object conforming to `SettingsService` for retrieving app-specific settings.
    ///   - tokenManager: An instance of `TokenManager` to handle authorization tokens.
    init(settings: SettingsService, tokenManager: TokenManager) {
        self.settings = settings
        self.tokenManager = tokenManager
    }
    
    /// Fetches the first page of customer reviews for the app.
    ///
    /// - Returns: An array of `Review` objects representing the customer reviews.
    /// - Throws: An error if the token is missing, the URL is invalid, or the data fetch fails.
    func fetchReviews() async throws -> [Review] {
        // Construct the URL for fetching the first page of reviews
        let urlString = "https://api.appstoreconnect.apple.com/v1/apps/\(settings.appId)/customerReviews?limit=10&sort=-createdDate"
        
        // Ensure we have a valid token
        guard let token = tokenManager.fetchToken() else {
            throw ReviewError.missingCredentials
        }
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            throw ReviewError.invalidURL
        }

        // Configure the GET request with authorization headers
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Perform the network request
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            // Decode the response and extract reviews and next page link
            let response = try JSONDecoder().decode(APIResponse.self, from: data)
            self.nextPage = response.links
            return response.data.map { $0.toReview() }
        } catch (let error) {
            print(error.localizedDescription)
            throw error
        }
    }
    
    /// Fetches the next page of reviews using the `nextPage` link.
    ///
    /// - Returns: An array of `Review` objects representing the customer reviews.
    /// - Throws: An error if the token is missing, the URL is invalid, or the data fetch fails.
    func fetchNextReviews() async throws -> [Review] {
        // Ensure we have a valid token and a next page URL
        guard let token = tokenManager.fetchToken(), let urlString = nextPage?.next else {
            throw ReviewError.missingCredentials
        }
        
        // Ensure the next page URL is valid
        guard let url = URL(string: urlString) else {
            throw ReviewError.invalidURL
        }

        // Configure the GET request with authorization headers
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Perform the network request
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            // Decode the response and update the next page link
            let response = try JSONDecoder().decode(APIResponse.self, from: data)
            self.nextPage = response.links
            return response.data.map { $0.toReview() }
        } catch (let error) {
            print(error.localizedDescription)
            throw error
        }
    }
}
