# Task Reminder App - Flutter

## Overview

This app is designed to help users set reminders for tasks. It allows users to create, view, and manage reminders with a simple interface. The app uses various Flutter packages and native code to fetch the system's timezone for accurate reminder timings.

## Features
- Create and manage task reminders.
- Set reminders with notifications.
  - iOS notification 
  - Android notification + action button
- Fetch system timezone using native code.
- Allow users to set tasks to repeat daily, weekly, or monthly.
- Automatically adapt to the system-wide theme.

## Prerequisites
Before running the app, make sure you have the following installed:
- Flutter SDK (latest version)
- Android Studio (or any other preferred IDE)
- A connected Android/iOS device or emulator

### 1. Flutter SDK

Follow these steps to install Flutter:

- Visit the official Flutter installation guide: [Flutter Install](https://flutter.dev/docs/get-started/install).
- Download and install the Flutter SDK for your operating system (Windows, macOS, or Linux).
- Ensure that you have the necessary system requirements for running Flutter, including:
    - Android Studio (for Android development).
    - Xcode (for iOS development, if you're targeting iOS).

After installation, verify that Flutter is installed correctly by running:

```bash
flutter doctor
```

## What's Changed:
- **Platform-specific Implementations**: Updated the explanation for how timezone fetching works across Android and iOS using native code (`java.util.TimeZone` and `NSTimeZone.local.identifier`).
- **Challenges Faced**: Adjusted the challenge regarding timezone handling to reflect the manual approach instead of using a package.

## How to Run the App

### 1. Clone the Repository
Clone this repository to your local machine using the following command:
```bash
git clone https://github.com/Nitingadhiya/task_reminder.git
```

### 2. Run Flutter app
```bash
flutter clean
flutter pub get
flutter run
```

