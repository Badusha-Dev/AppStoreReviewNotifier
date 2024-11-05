//
//  ReviewsViewModel.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//

import Foundation


@MainActor
class ReviewsViewModel: ObservableObject {
    @Published private(set) var reviews: [Review] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let reviewsService: ReviewsService
    private let notificationService: NotificationService
    private var settings: SettingsService
    private var refreshTask: Task<Void, Never>?
    private var latestReviewDate: Date = .distantPast
    private var reviewsDict: [String: Review] = [:]
    
    init(
        reviewsService: ReviewsService,
        notificationService: NotificationService,
        settings: SettingsService
    ) {
        self.reviewsService = reviewsService
        self.notificationService = notificationService
        self.settings = settings
        setupInitialState()
    }
    
    private func setupInitialState() {
        Task {
            await requestNotificationPermission()
            await fetchReviews()
            startPeriodicRefresh()
        }
    }
    
    private func requestNotificationPermission() async {
        do {
            settings.notificationsEnabled = try await notificationService.requestAuthorization()
        } catch {
            self.error = error
        }
    }
    
    func fetchReviews(isRefresh: Bool = false) async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            if isRefresh {
                reviewsDict.removeAll()
            }
            let fetchedReviews = try await reviewsService.fetchReviews()
            await processFetchedReviews(fetchedReviews)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    private func processFetchedReviews(_ fetchedReviews: [Review]) async {
        var newReviews: [Review] = []
        
        for review in fetchedReviews {
            if reviewsDict[review.id] == nil {
                // New review
                reviewsDict[review.id] = review
                newReviews.append(review)
                
                // Send notification if the review is newer
                if review.createdDate > latestReviewDate {
                    latestReviewDate = review.createdDate
                    if settings.notificationsEnabled {
                        await notificationService.sendNotification(for: review)
                    }
                }
            }
        }
        
        // Update the reviews array and sort it
        reviews = Array(reviewsDict.values).sorted(by: { $0.createdDate > $1.createdDate })
    }
   
    func loadMoreReviews(currentReview: Review) {
        guard let index = reviews.firstIndex(where: { $0.id == currentReview.id }) else { return }
        
        let thresholdIndex = reviews.index(reviews.endIndex, offsetBy: -2)
        guard index >= thresholdIndex else { return }
        Task {
            await fetchMoreReviews()
        }
    }
    func fetchMoreReviews() async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            let fetchedReviews = try await reviewsService.fetchNextReviews()
            await processFetchedReviews(fetchedReviews)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    private func startPeriodicRefresh() {
        refreshTask?.cancel()
        refreshTask = Task {
            let refreshInterval = UInt64(120 * 1_000_000_000) // 120 seconds in nanoseconds
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: refreshInterval)
                await fetchReviews()
            }
        }
    }
    
    deinit {
        refreshTask?.cancel()
    }
}
