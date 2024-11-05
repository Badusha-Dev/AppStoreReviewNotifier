//
//  ReviewsViewModel.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ReviewsViewModel
    @State private var showingSettings = false
    @State private var selectedReview: Review?
    init() {
        _viewModel = StateObject(
            wrappedValue: AppFactory.makeReviewsViewModel()
        )
    }
    
    var body: some View {
        NavigationSplitView {
            ReviewsList(viewModel: viewModel, selectedReview: $selectedReview)
                .navigationTitle("App Store Reviews")
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            Task {
                                await viewModel.fetchReviews(isRefresh: true)
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                    
                    ToolbarItem(placement: .automatic) {
                        Button(action: { showingSettings.toggle() }) {
                            Image(systemName: "gear")
                        }
                    }
                }
        } detail: {
            if let review = selectedReview {
                ReviewDetailView(review: review)
            } else {
                NoReviewSelectedView()
            }
        }.sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}
