//
//  ReviewsList.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//


import SwiftUI

struct ReviewsList: View {
    @ObservedObject var viewModel: ReviewsViewModel
    @Binding var selectedReview: Review?
    
    var body: some View {
        if viewModel.isLoading {
            HStack {
                Spacer()
                ProgressView("Loading reviews...")
                Spacer()
            }
            .listRowBackground(Color.clear)
        }
        
        if let error = viewModel.error {
            Text(error.localizedDescription)
                .foregroundColor(.red)
                .listRowBackground(Color.clear)
        }
        List(selection: $selectedReview) {
            
            ForEach(viewModel.reviews) { review in
                ReviewRow(review: review)
                    .tag(review)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)).onAppear {
                        viewModel.loadMoreReviews(currentReview: review)
                    }
            }
        }
        .listStyle(.inset)
        .frame(minWidth: 300)
        .navigationTitle("Reviews")
    }
}
