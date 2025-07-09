# my_flutter_project

A sample Flutter application demonstrating a login flow, dashboard with multiple sections, and various UI components for testing.

## Getting Started

This project is a starting point for a Flutter application with added features.

### Prerequisites

Before you begin, ensure you have the Flutter SDK installed on your system. You can find detailed installation instructions on the official Flutter website:

*   [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

Make sure your Flutter environment is set up correctly by running:

```bash
flutter doctor
```

### Installation

1.  **Clone the repository (if applicable) or navigate to the project directory:**

    ```bash
    cd my_flutter_project
    ```

2.  **Get Flutter dependencies:**

    ```bash
    flutter pub get
    ```

### Building the Application

#### For Web (Chrome)

To run the application in a Chrome browser:

```bash
flutter run -d chrome
```

#### For Android

To build an Android application package (APK) for release:

```bash
flutter build apk --release
```

The generated release APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

To build an Android App Bundle (AAB) for publishing to Google Play:

```bash
flutter build appbundle --release
```

The generated AAB will be located at `build/app/outputs/bundle/release/app-release.aab`.

To run the application on a connected Android device or emulator:

```bash
flutter run
```

#### For iOS

To build an iOS application for release (requires a Mac with Xcode):

```bash
flutter build ios --release
```

The generated iOS app bundle will be located at `build/ios/iphoneos/Runner.app`. You can then archive this in Xcode for distribution.

To build an iOS archive for App Store Connect (requires a Mac with Xcode):

```bash
flutter build ipa --release
```

The generated IPA file will be located at `build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app` (within the archive).

To run the application on a connected iOS device or simulator (requires a Mac with Xcode):

```bash
flutter run
```

##### Installing CI/CD Build Artifacts on Device

After a successful CI/CD run, you can download the generated build artifacts (APK for Android, .app bundle for iOS) from the GitHub Actions workflow run summary.

###### For Android (APK)

1.  **Download the `android-apk` artifact:** From your GitHub Actions workflow run, download the artifact named `android-apk`. This will be a `.zip` file containing `app-release.apk`.
2.  **Extract the APK:** Unzip the downloaded file to get `app-release.apk`.
3.  **Transfer to your Android device:**
    *   **USB:** Connect your Android device to your computer via USB and copy the `app-release.apk` file to the device's storage.
    *   **Cloud Storage/Email:** Upload the APK to a cloud storage service (e.g., Google Drive, Dropbox) or email it to yourself, then download it on your device.
4.  **Enable "Install unknown apps":** On your Android device, you might need to enable installation from unknown sources for your file browser or Chrome (depending on how you transfer/open the APK). This setting is usually found in `Settings > Apps & notifications > Special app access > Install unknown apps`.
5.  **Install the APK:** Locate the `app-release.apk` file using a file manager on your device and tap it to install.

###### For iOS (.app bundle)

Installing an unsigned `.app` bundle directly onto a physical iOS device is generally not straightforward and typically requires Xcode or specific command-line tools with a valid development profile.

*   **For iOS Simulators:**
    1.  **Download the `ios-app` artifact:** From your GitHub Actions workflow run, download the artifact named `ios-app`. This will be a `.zip` file containing `Runner.app`.
    2.  **Extract the `.app` bundle:** Unzip the downloaded file to get `Runner.app`.
    3.  **Install to Simulator:** Open your terminal and use `xcrun simctl` to install the app to a running simulator. First, list your available simulators to get a device ID:

        ```bash
        xcrun simctl list devices
        ```

    4.  Then, install the app using a simulator's UDID (e.g., `XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`):

        ```bash
        xcrun simctl install <simulator_UDID> /path/to/your/Runner.app
        ```

*   **For Physical iOS Devices:**
    For physical devices, the `--no-codesign` build is primarily for CI validation or for further processing by tools like Fastlane. To install on a physical device, you typically need to:
    *   **Sign the app:** Use Xcode to sign the `.app` bundle with a valid Apple Developer account and provisioning profile.
    *   **Distribute via TestFlight/Ad Hoc:** For easier distribution to testers, consider using Apple's TestFlight or an Ad Hoc distribution method, which requires proper signing during the build process (e.g., using `flutter build ipa --release` with correct Xcode signing settings).



##### Building for iOS without Code Signing (for development/testing)

If you want to build and run the iOS application on a simulator or a physical device without a full Apple Developer Program membership (i.e., without automatic code signing), you can follow these steps:

1.  **Open the iOS project in Xcode:**
    Navigate to the `ios` folder within your Flutter project and open the `Runner.xcworkspace` file.

    ```bash
    open ios/Runner.xcworkspace
    ```

2.  **Select the Runner project:**
    In Xcode, select `Runner` from the Project Navigator on the left sidebar.

3.  **Configure Signing & Capabilities:**
    *   Go to the `Signing & Capabilities` tab.
    *   **Uncheck** "Automatically manage signing".
    *   For the "Team" dropdown, select "None" (if you don't have a personal team) or your personal team if it appears.
    *   Ensure the "Bundle Identifier" is unique (e.g., `com.yourcompany.myflutterproject`). If you encounter issues, try changing it to something like `com.example.myflutterprojectdev`.

4.  **Select a target and run:**
    *   Choose your desired simulator or a connected physical device from the scheme dropdown next to the "Run" and "Stop" buttons.
    *   Click the "Run" button (play icon) or go to `Product > Run`.

    You might see warnings about code signing, but the app should build and run on the selected simulator or device for development purposes.

## GitHub Actions CI/CD and Releases

This project uses GitHub Actions for Continuous Integration/Continuous Deployment (CI/CD). The workflow is configured to automatically build Android APKs and iOS `.app` bundles (unsigned) and create a GitHub Release when a specific tag is pushed.

### Triggering a Release

To trigger a new release, you need to create and push a Git tag following the `v*.*.*` convention (e.g., `v1.0.0`, `v1.0.1-beta`).

1.  **Create a new Git tag:**

    ```bash
    git tag vX.Y.Z
    ```
    Replace `vX.Y.Z` with your desired version number (e.g., `v1.0.0`).

2.  **Push the tag to GitHub:**

    ```bash
    git push origin vX.Y.Z
    ```

Once the tag is pushed, the GitHub Actions workflow will automatically start, build the applications, and create a new release on your GitHub repository with the built artifacts attached.

### App Overview and Usage

This application features a simple login system and a dashboard with a bottom navigation bar.

#### Login Screen

The application starts with a login screen. You must enter valid credentials to proceed to the dashboard.

*   **Username:** `user`
*   **Password:** `password`

#### Dashboard

After successful login, you will be redirected to the Dashboard, which features a bottom navigation bar with three main sections:

1.  **Testing (Bug Icon):**
    *   **Sample of components for automation testing:** This page displays various UI components (Text, TextField, Buttons, Checkbox, Radio, Switch, Slider, Dropdown, Progress Indicators, Image Placeholder) that can be useful for automation testing.
    *   **Calculator App:** A basic calculator application.

2.  **Game (Gamepad Icon):**
    *   **Simple Clicker Game:** A game where you click as many times as possible within a selected time limit (10, 30, or 60 seconds). There is a 3-second countdown before the game starts.

3.  **Profile (Person Icon):**
    *   **User Profile:** A placeholder screen for user profile information.
    *   **Credits:** Displays credits for the application, including "Vibe Coder" and "Noppon Mon".

#### Logout

From the "Testing" tab on the Dashboard, you can find a "Logout" button (Floating Action Button) that will return you to the Login Screen.

## Resources

*   [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
*   [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
*   [Online documentation](https://docs.flutter.dev/)