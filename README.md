# AppStoreReviewNotifier

**AppStoreReviewNotifier** is a macOS app that aggregates customer reviews for your app, fetching new reviews periodically and notifying you of fresh feedback. This tool is ideal for customer support teams without iPhones who need easy access to the latest reviews, as it offers similar functionality to the App Store Connect app on iOS.

## Features
- **Real-Time Review Fetching**: Automatically retrieves the latest customer reviews from App Store Connect.
- **Customizable Notifications**: Receive notifications when new reviews are added.
- **Efficient Pagination and Storage**: Ensures minimal data usage by storing and accessing reviews efficiently.

## Security Note
This app utilizes JWT tokens for authentication. JWT token generation is handled securely using Swift JWT SDK, but it’s best to generate tokens server-side when possible. A Ruby code snippet for secure backend-based JWT generation is included.

## Dependencies
- **Swift**
- **SwiftUI**
- **async/await**
- **Swift JWT SDK**
- **UserNotifications**

## Contributing
Feedback and contributions are welcome! Submit issues or pull requests to help improve the app.


## Screenshots
<img width="1440" alt="Screenshot 2024-11-05 at 10 04 06 PM" src="https://github.com/user-attachments/assets/7ded0086-320d-4d91-9ad4-3a2d49d8fdc5">
<img width="1440" alt="Screenshot 2024-11-05 at 9 22 41 PM" src="https://github.com/user-attachments/assets/4c6e7509-6ba6-4602-8b73-7d79ced1c13a">
