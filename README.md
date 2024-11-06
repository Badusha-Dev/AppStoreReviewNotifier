# AppStoreReviewNotifier

**AppStoreReviewNotifier** is a macOS app that aggregates customer reviews for your app, fetching new reviews periodically and notifying you of fresh feedback. This tool is ideal for customer support teams without iPhones who need easy access to the latest reviews, as it offers similar functionality to the App Store Connect app on iOS.

## Features
- **Real-Time Review Fetching**: Automatically retrieves the latest customer reviews from App Store Connect.
- **Customizable Notifications**: Receive notifications when new reviews are added.
- **Efficient Pagination and Storage**: Ensures minimal data usage by storing and accessing reviews efficiently.

## Security Note
This app utilizes JWT tokens for authentication. JWT token generation is handled securely using Swift JWT SDK, but it’s best to generate tokens server-side when possible. A Ruby code snippet for secure backend-based JWT generation is included.

## Requirements
To use this app, you will need:
- **App Store Connect API Key**: The private key file for JWT authentication (in `.p8` format).
- **Issuer ID**: Your App Store Connect issuer identifier.
- **Key ID**: The ID of the private key associated with your App Store Connect API Key.

## Dependencies
- **Swift**
- **SwiftUI**
- **async/await**
- **Swift JWT SDK**
- **UserNotifications**

## Contributing
Feedback and contributions are welcome! Submit issues or pull requests to help improve the app.


## Screenshots
<img width="1440" alt="Screenshot 2024-11-05 at 9 22 41 PM" src="https://github.com/user-attachments/assets/051435b8-75e9-4678-add5-a212d77870b0">
<img width="1440" alt="Screenshot 2024-11-05 at 10 04 06 PM" src="https://github.com/user-attachments/assets/0e4593f2-b3a1-40bc-bdc1-192a6f5c3bb8">
