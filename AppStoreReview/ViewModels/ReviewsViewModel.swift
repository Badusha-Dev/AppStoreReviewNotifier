//
//  ReviewsViewModel.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//

import Foundation

/// A view model responsible for managing and displaying customer reviews, handling periodic refreshes,
/// and sending notifications for new reviews. Uses `MainActor` to ensure that UI updates are made on the main thread.
@MainActor
class ReviewsViewModel: ObservableObject {
    
    @Published private(set) var reviews: [Review] = []        // List of fetched reviews
    @Published private(set) var isLoading = false             // Indicates loading state
    @Published private(set) var error: Error?                 // Holds any error that occurs during fetching
    
    private let reviewsService: ReviewsService                // Service for fetching reviews
    private let notificationService: NotificationService      // Service for sending notifications
    private var settings: SettingsService                     // Manages user settings for notifications
    private var refreshTask: Task<Void, Never>?               // Task that periodically refreshes reviews
    private var latestReviewDate: Date = .distantPast         // Tracks the date of the latest review
    private var reviewsDict: [String: Review] = [:]           // Dictionary to store reviews by ID
    
    /// Initializes the view model with the necessary services.
    /// - Parameters:
    ///   - reviewsService: The service to fetch reviews.
    ///   - notificationService: The service to send notifications.
    ///   - settings: The settings service to manage user preferences.
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
    
    /// Sets up the initial state by requesting notification permissions, fetching initial reviews, and starting the refresh task.
    private func setupInitialState() {
        Task {
            await requestNotificationPermission()
            await fetchReviews()
            startPeriodicRefresh()
        }
    }
    
    /// Requests notification authorization from the user and updates settings accordingly.
    private func requestNotificationPermission() async {
        do {
            settings.notificationsEnabled = try await notificationService.requestAuthorization()
        } catch {
            self.error = error
        }
    }
    
    /// Fetches the first page of reviews or refreshes them if `isRefresh` is true.
    /// - Parameter isRefresh: A Boolean indicating whether to refresh the reviews.
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
    
    /// Processes the fetched reviews, adds new ones, and sends notifications if there are newer reviews.
    /// - Parameter fetchedReviews: An array of `Review` objects fetched from the API.
    private func processFetchedReviews(_ fetchedReviews: [Review]) async {
        var newReviews: [Review] = []
        
        for review in fetchedReviews {
            if reviewsDict[review.id] == nil {
                // New review
                reviewsDict[review.id] = review
                newReviews.append(review)
                
                // Send notification if the review is newer than the latest review date
                if review.createdDate > latestReviewDate {
                    latestReviewDate = review.createdDate
                    if settings.notificationsEnabled {
                        await notificationService.sendNotification(for: review)
                    }
                }
            }
        }
        
        // Update the reviews array, sorting by creation date in descending order
        reviews = Array(reviewsDict.values).sorted(by: { $0.createdDate > $1.createdDate })
    }
   
    /// Loads more reviews when the user reaches the end of the currently displayed list.
    /// - Parameter currentReview: The last review displayed, triggering a load of additional reviews.
    func loadMoreReviews(currentReview: Review) {
        guard let index = reviews.firstIndex(where: { $0.id == currentReview.id }) else { return }
        
        let thresholdIndex = reviews.index(reviews.endIndex, offsetBy: -2)
        guard index >= thresholdIndex else { return }
        Task {
            await fetchMoreReviews()
        }
    }
    
    /// Fetches the next page of reviews if available.
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
    
    /// Starts a periodic refresh task that fetches reviews at regular intervals.
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
    
    /// Cancels the periodic refresh task when the view model is deallocated.
    deinit {
        refreshTask?.cancel()
    }
}
