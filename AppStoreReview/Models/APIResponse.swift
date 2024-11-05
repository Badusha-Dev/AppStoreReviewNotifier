//
//  APIResponse 2.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//

import Foundation


struct APIResponse: Codable {
    let data: [APIReview]
    let links: APILinks
}
struct APILinks: Codable {
    let `self`: String
    let next: String?
}
struct APIReview: Codable {
    let id: String
    let attributes: APIReviewAttributes
    
    func toReview() -> Review {
        Review(
            id: id,
            rating: attributes.rating,
            title: attributes.title,
            body: attributes.body ?? "",
            reviewerNickname: attributes.reviewerNickname ?? "",
            createdDate: ISO8601DateFormatter().date(from: attributes.createdDate ?? "") ?? Date()
        )
    }
}

struct APIReviewAttributes: Codable {
    let rating: Int
    let title: String?
    let body: String?
    let reviewerNickname: String?
    let createdDate: String?
}
