# Online Store App

This is an iOS app that allows users to browse and purchase products from an online store. The app is built using SwiftUI and integrates with Firebase to handle user authentication, real-time data synchronization, analytics, messaging, and storage. It also uses the CachedAsyncImage framework for caching product images.

## Features
The app includes the following features:

- User authentication using Firebase Authentication
- Real-time product data synchronization using Firestore Database
- Shopping cart functionality to add and remove items
- Checkout flow to enter payment and shipping information
- Order history to view past purchases
- Analytics tracking using Firebase Analytics
- Push notifications using Firebase Messaging
- Image storage using Firebase Storage
- Image caching using CachedAsyncImage

## Requirements

- iOS 16 or later
- Xcode 14 or later

## Installation

1. Clone the repository: git clone https://github.com/ShvydkyiOleksandr/Online-Store
2. Open the Online Store App.xcodeproj file in Xcode.
3. Xcode should automatically fetch the necessary dependencies using Swift Package Manager. If not, go to File -> Swift Packages -> Resolve Package Versions.

## Configuration

Before running the app, you'll need to configure Firebase. Here's how to do it:

1. Create a new Firebase project at https://console.firebase.google.com/.
2. Add an iOS app to your Firebase project.
3. Follow the instructions to download the GoogleService-Info.plist file and add it to the Xcode project.
4. Enable Firebase Authentication, Firestore Database, Firebase Analytics, Firebase Messaging, and Firebase Storage for your Firebase project.

## Usage

To use the app, simply build and run it in Xcode. The app will launch on the iOS simulator or on a connected iOS device. You can browse the products, add items to your cart, and checkout using the payment and shipping information.

Firebase Analytics and Firebase Messaging will automatically track user events and send push notifications based on app usage.

Firebase Storage is used to store and retrieve images for the products in the app.

The CachedAsyncImage framework is used to cache product images for faster loading times and better user experience.

## Acknowledgements

- The app uses Firebase for authentication, real-time data synchronization, analytics, messaging, and storage.
- The app UI is built using SwiftUI.
- The app uses CachedAsyncImage for caching product images.
