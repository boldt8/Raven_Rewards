# Raven Rewards

Raven Rewards is a native iOS app built to make school participation more interactive. Students can earn and track **Raven Points**, participate in location- and QR-based activities, and interact through a social feed with posts, likes, comments, and profiles.

## Features

- **Raven Points system** for tracking rewards and participation
- **QR scanning** for point-based activities and events
- **Location-based rewards** with map functionality
- **Social feed** with posts, likes, captions, and comments
- **User profiles** and account authentication
- **Photo capture and uploads**
- **Push messaging and analytics** through Firebase

## Tech Stack

- **Swift**
- **UIKit** and **SwiftUI**
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Storage**
- **Firebase Analytics**
- **Firebase Messaging**
- **MapKit / Core Location**
- **AVFoundation**
- **CocoaPods**

## Project Structure

```text
Raven Rewards/
├── Controllers/        # Main screens and application flows
│   ├── Core Tabs/      # Feed, camera, profile, QR scanner, shop
│   └── Other/          # Authentication, map, post, and utility screens
├── Models/             # User, post, comment, and view-model types
├── Resources/          # Firebase managers, storage, analytics, app lifecycle
├── TheMap/             # Location-based rewards and map components
└── Views/              # Reusable views and collection/table cells
```

## Architecture

The app separates Firebase operations into dedicated managers for authentication, Firestore data, storage, and analytics. The UI is organized around feature-specific view controllers and reusable views, while shared models represent users, posts, comments, points, and locations.

A typical flow looks like:

```text
User action
   ↓
UIKit / SwiftUI screen
   ↓
AuthManager / DatabaseManager / StorageManager
   ↓
Firebase
```

## Running Locally

### Requirements

- macOS
- Xcode
- CocoaPods
- iOS simulator or physical iPhone
- Firebase configuration for the services used by the app

### Setup

```bash
git clone https://github.com/boldt8/Raven_Rewards.git
cd Raven_Rewards
pod install
open "Raven Rewards.xcworkspace"
```

Then build and run the **Raven Rewards** target from Xcode.

If you are connecting the project to a different Firebase backend, use the Firebase configuration for your own project and enable the required Authentication, Firestore, Storage, Analytics, and Messaging services.

## What I Learned

This project gave me experience building a larger iOS application with multiple screens and data flows, integrating a cloud backend, handling asynchronous Firebase operations, working with camera and location APIs, and organizing reusable UI and application logic in Swift.

## Status

Raven Rewards is a student-built project and reflects the application as developed for its original school-community use case. It is not currently packaged as a general-purpose production app.
