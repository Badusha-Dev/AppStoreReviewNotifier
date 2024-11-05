//
//  SettingsView.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var settings = UserDefaultsSettingsService()
    
    var body: some View {
        VStack(spacing: 24) {
            // Title
            Text("Settings")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Notifications Toggle
            HStack {
                Text("Enable Notifications")
                    .foregroundColor(.primary)
                Spacer()
                Toggle("", isOn: $settings.notificationsEnabled)
                    .labelsHidden()
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Done Button
            Button("Done") {
                dismiss()
            }
            .keyboardShortcut(.return)
            .buttonStyle(.borderedProminent)
        }
        .padding(.vertical, 24)
        .frame(width: 300, height: 150)
    }
}
