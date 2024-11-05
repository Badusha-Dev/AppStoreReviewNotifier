//
//  ReviewRow.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//


import SwiftUI

struct ReviewRow: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                StarsView(rating: review.rating)
                Spacer()
                Text(review.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let title = review.title {
                Text(title)
                    .font(.headline)
            }
            
            Text(review.body)
                .font(.body)
            
            Text("By \(review.reviewerNickname)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct StarsView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}
