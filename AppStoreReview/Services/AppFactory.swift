//
//  AppFactory.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//


/// A factory enum responsible for constructing and configuring instances of view models and services.
enum AppFactory {
    
    /// Creates and configures an instance of `ReviewsViewModel` for use in the app.
    ///
    /// - Returns: A fully initialized `ReviewsViewModel` object.
    @MainActor static func makeReviewsViewModel() -> ReviewsViewModel {
        // Initialize settings service to manage app configurations.
        let settings = UserDefaultsSettingsService()
        
        // Initialize notification service for handling notifications.
        let notificationService = SystemNotificationService()
        
        // Use a mock reviews service for testing or development purposes.
        let reviewsService: ReviewsService = MockReviewsService()
        
        // Uncomment the following lines to use the real App Store reviews service.
        // This service fetches actual reviews from the App Store Connect API.
        // let reviewsService: ReviewsService = AppStoreReviewsService(
        //     settings: settings,
        //     tokenManager: TokenManager()
        // )
        
        // Create and return the ReviewsViewModel with the configured services.
        return ReviewsViewModel(
            reviewsService: reviewsService,
            notificationService: notificationService,
            settings: settings
        )
    }
}

