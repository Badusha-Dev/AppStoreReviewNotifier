//
//  SystemNotificationService.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//

import UserNotifications

/// A protocol defining the methods required for sending and requesting authorization for notifications.
protocol NotificationService {
    /// Sends a notification for a specific app review.
    /// - Parameter review: The `Review` object containing information about the app review.
    func sendNotification(for review: Review) async
    
    /// Requests authorization for sending notifications.
    /// - Returns: A `Bool` indicating whether authorization was granted.
    /// - Throws: An error if authorization fails.
    func requestAuthorization() async throws -> Bool
}

/// A concrete implementation of `NotificationService` that manages system notifications using `UNUserNotificationCenter`.
class SystemNotificationService: NotificationService {
    
    /// Requests authorization to send notifications with alert and sound options.
    /// - Returns: A `Bool` indicating if the user granted notification permissions.
    /// - Throws: An error if the authorization request fails.
    func requestAuthorization() async throws -> Bool {
        // Set the delegate to handle notification events (usually necessary for handling incoming notifications)
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        
        // Request authorization for alerts and sounds
        return try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound])
    }
    
    /// Sends a notification for a given app review, provided that notification permissions have been granted.
    /// - Parameter review: A `Review` object representing the review for which the notification will be sent.
    func sendNotification(for review: Review) async {
        do {
            // Check the current notification settings to verify authorization
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            guard settings.authorizationStatus == .authorized else {
                print("Notifications not authorized")
                return
            }
            
            // Create the notification content with the review details
            let content = UNMutableNotificationContent()
            content.title = "New App Store Review"
            content.subtitle = "Rating: \(review.rating) stars"
            content.body = "\(review.reviewerNickname): \(review.body)"
            content.sound = .default
            
            // Create a trigger for immediate delivery (1-second delay)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            // Create the notification request with a unique identifier
            let request = UNNotificationRequest(
                identifier: "review-\(review.id)",
                content: content,
                trigger: trigger
            )
            
            // Schedule the notification
            try await UNUserNotificationCenter.current().add(request)
            print("Notification scheduled for review: \(review.id)")
        } catch {
            // Handle errors in scheduling the notification
            print("Failed to schedule notification: \(error.localizedDescription)")
        }
    }
}
