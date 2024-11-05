//
//  Review.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//

import Foundation

struct Review: Identifiable, Codable, Hashable  {
    let id: String
    let rating: Int
    let title: String?
    let body: String
    let reviewerNickname: String
    let createdDate: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdDate)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Review, rhs: Review) -> Bool {
        lhs.id == rhs.id
    }
}
