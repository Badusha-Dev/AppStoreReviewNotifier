//
//  NoReviewSelectedView.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//


import SwiftUI

struct NoReviewSelectedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "text.bubble")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No Review Selected")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Select a review from the list to view details")
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
