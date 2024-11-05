//
//  ReviewDetailView.swift
//  AppStoreReview
//
//  Created by Badusha Basheer on 25/10/24.
//


import SwiftUI

struct ReviewDetailView: View {
    let review: Review
    @State private var showResponseField = false
    @State private var responseText = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        StarsView(rating: review.rating)
                            .font(.title2)
                        
                        Spacer()
                        
                        Text(review.formattedDate)
                            .foregroundColor(.secondary)
                    }
                    
                    if let title = review.title {
                        Text(title)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Text("By \(review.reviewerNickname)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Review Content
                Text(review.body)
                    .font(.body)
                    .lineSpacing(4)
                
                Divider()
                
                // Actions
                HStack(spacing: 16) {
                    Button(action: { showResponseField.toggle() }) {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.left.fill")
                            Text("Respond")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: copyReviewToClipboard) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copy")
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    ShareLink(
                        item: shareText,
                        preview: SharePreview("App Review")
                    )
                    .buttonStyle(.bordered)
                }
                
                // Response Field
                if showResponseField {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Response")
                            .font(.headline)
                        
                        TextEditor(text: $responseText)
                            .font(.body)
                            .frame(height: 100)
                            .border(Color.secondary.opacity(0.2))
                        
                        HStack {
                            Spacer()
                            Button("Send Response") {
                                showResponseField = false
                                responseText = ""
                            }
                            .disabled(responseText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
            .padding()
        }
        .frame(minWidth: 400, minHeight: 300)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                ShareLink(
                    item: shareText,
                    preview: SharePreview("App Review")
                )
                
                Button(action: copyReviewToClipboard) {
                    Image(systemName: "doc.on.doc")
                }
                .help("Copy Review")
            }
        }
    }
    
    private var shareText: String {
        """
        App Store Review
        Rating: \(review.rating) stars
        \(review.title ?? "")
        
        \(review.body)
        
        By \(review.reviewerNickname)
        \(review.formattedDate)
        """
    }
    
    private func copyReviewToClipboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(shareText, forType: .string)
    }
}
