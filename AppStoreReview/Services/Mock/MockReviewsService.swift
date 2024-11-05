//
//  MockReviewsService.swift
//  AppStoreReview
//
//  Created by Badusha Ygag on 11/5/24.
//

import Foundation

/// A mock implementation of `ReviewsService` for testing purposes, providing sample review data.
class MockReviewsService: ReviewsService {
    
    var nextPage: APILinks?
    
    /// Initializes the mock service with an optional next page link.
    /// - Parameter nextPage: The link to the next page of results, if any.
    init(nextPage: APILinks? = nil) {
        self.nextPage = nextPage
    }
    
    /// Simulates fetching the first page of reviews by returning sample data after a delay.
    /// - Returns: An array of sample `Review` objects.
    func fetchReviews() async throws -> [Review] {
        try await Task.sleep(for: .seconds(1))  // Simulate network delay
        return sampleReviews
    }
    
    /// Simulates fetching the next page of reviews, which returns an empty array in this mock implementation.
    /// - Returns: An empty array of `Review` objects.
    func fetchNextReviews() async throws -> [Review] {
        []
    }
    
    /// Sample review data used for testing.
   let sampleReviews: [Review] = [
        Review(
            id: UUID().uuidString,
            rating: 5,
            title: "Outstanding Experience!",
            body: "I purchased this product last week and it has been a game-changer. The quality is top-notch, and the customer service was excellent. I highly recommend it to anyone looking for reliability and efficiency.",
            reviewerNickname: "AlexTheGreat",
            createdDate: Date()
        ),
        Review(
            id: UUID().uuidString,
            rating: 4,
            title: "Very Good, Minor Issues",
            body: "The product works as advertised and has significantly improved my workflow. However, I encountered a minor issue with the setup process. The instructions could be clearer.",
            reviewerNickname: "TechEnthusiast89",
            createdDate: Date().addingTimeInterval(-3600) // 1 hour ago
        ),
        Review(
            id: UUID().uuidString,
            rating: 3,
            title: "Average Performance",
            body: "It's an okay product. It performs adequately but doesn't stand out in any particular way. It's worth considering if you need something basic.",
            reviewerNickname: "NeutralObserver",
            createdDate: Date().addingTimeInterval(-7200) // 2 hours ago
        ), Review(
            id: UUID().uuidString,
            rating: 5,
            title: "An In-Depth Analysis of an Exceptional Product",
            body: """
        I recently had the opportunity to thoroughly test and utilize this product over an extended period, and I must say that it has exceeded all my expectations in every conceivable way. From the moment I unboxed it, I was immediately impressed by the attention to detail in the packaging and the obvious care that went into ensuring that the product arrived in pristine condition.

        **First Impressions and Build Quality**

        The build quality is exceptional. The materials used are of the highest grade, providing both durability and a premium feel that is often lacking in comparable products. Every component feels solid and well-constructed, with no loose parts or signs of cost-cutting measures. The design is sleek and modern, yet functional, seamlessly blending into both professional and home environments.
        

        """,
            reviewerNickname: "ExpertReviewer123",
            createdDate: Date().addingTimeInterval(-3600)
        ),
        Review(
            id: UUID().uuidString,
            rating: 2,
            title: "Not as Expected",
            body: "I was excited to try this product, but unfortunately, it didn't meet my expectations. The features are limited, and I found it difficult to use.",
            reviewerNickname: "DisappointedUser",
            createdDate: Date().addingTimeInterval(-10800) // 3 hours ago
        ),
        Review(
            id: UUID().uuidString,
            rating: 1,
            title: "Poor Quality",
            body: "This is by far the worst product I've purchased. It stopped working after just two days, and customer support was unhelpful.",
            reviewerNickname: "AngryCustomer",
            createdDate: Date().addingTimeInterval(-14400) // 4 hours ago
        ),
        Review(
            id: UUID().uuidString,
            rating: 5,
            title: "Exceeded Expectations!",
            body: "Amazing product! It offers more features than advertised and has been extremely reliable. Will purchase again for my team.",
            reviewerNickname: "SatisfiedClient",
            createdDate: Date().addingTimeInterval(-18000) // 5 hours ago
        ),
        Review(
            id: UUID().uuidString,
            rating: 4,
            title: "Great Support",
            body: "I had some issues initially, but the customer support was fantastic and resolved my problems quickly.",
            reviewerNickname: "SupportFan",
            createdDate: Date().addingTimeInterval(-21600) // 6 hours ago
        ),
        Review(
            id: UUID().uuidString,
            rating: 3,
            title: "Decent, but Room for Improvement",
            body: "The product is okay, but there's definitely room for improvement, especially in terms of user interface and performance speed.",
            reviewerNickname: "AverageJoe",
            createdDate: Date().addingTimeInterval(-25200) // 7 hours ago
        ),
        Review(
            id: UUID().uuidString,
            rating: 2,
            title: "Not User-Friendly",
            body: "I found the product difficult to navigate, and it lacks essential features that are standard in other similar products.",
            reviewerNickname: "FrustratedUser",
            createdDate: Date().addingTimeInterval(-28800) // 8 hours ago
        ),
        Review(
            id: UUID().uuidString,
            rating: 5,
            title: "Highly Recommended",
            body: "This product has transformed the way I work. It's efficient, reliable, and the design is sleek. Five stars!",
            reviewerNickname: "HappyCamper",
            createdDate: Date().addingTimeInterval(-32400) // 9 hours ago
        ),
        // Add more reviews as needed
    ]

}
