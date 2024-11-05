//
//  UserDefaultsSettingsService.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//

import SwiftUI

/// A protocol that defines the settings properties for managing app configuration.
/// It includes properties for the app's unique identifier and the notification settings.
protocol SettingsService {
    /// The opaque resource ID that uniquely identifies the app resource representing your app.
    /// Obtain the app resource ID from the List Apps response or backend service.
    var appId: String { get set }
    
    /// A Boolean property to enable or disable notifications for the app.
    var notificationsEnabled: Bool { get set }
}

/// A concrete implementation of `SettingsService` that uses `UserDefaults` to persist settings.
/// Conforms to `ObservableObject` to allow SwiftUI views to observe changes.
class UserDefaultsSettingsService: SettingsService, ObservableObject {
    
    /// The unique identifier for the app, initialized with a default value.
    ///  Replace with your appId
    var appId: String = "100100100"
    
    /// A Boolean value that indicates whether notifications are enabled.
    /// Stored in `AppStorage`, which syncs with `UserDefaults` and allows easy integration with SwiftUI.
    @AppStorage("notificationsEnabled") var notificationsEnabled = false
}

