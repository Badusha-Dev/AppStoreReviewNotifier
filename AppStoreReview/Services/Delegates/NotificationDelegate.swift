//
//  NotificationDelegate.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//


import UserNotifications

/// A singleton class that acts as the delegate for handling user notifications.
/// Conforms to `UNUserNotificationCenterDelegate` to manage notification behavior when the app is in the foreground or when the user interacts with a notification.
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    /// Shared singleton instance for use across the app.
    static let shared = NotificationDelegate()
    
    /// Called when a notification is about to be presented while the app is in the foreground.
    ///
    /// - Parameters:
    ///   - center: The `UNUserNotificationCenter` managing the notification.
    ///   - notification: The notification that is about to be presented.
    /// - Returns: The presentation options for the notification, enabling banner and sound in this case.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        // Show notification with a banner and sound, even when the app is in the foreground.
        return [.banner, .sound]
    }
    
    /// Called when the user interacts with a notification, such as tapping on it.
    ///
    /// - Parameters:
    ///   - center: The `UNUserNotificationCenter` managing the notification.
    ///   - response: The user’s response to the notification.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        // Handle notification tap, printing the notification's identifier.
        print("Notification tapped: \(response.notification.request.identifier)")
    }
}

