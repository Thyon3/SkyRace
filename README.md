# SkyRace ✈️

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.9.2+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)

**A modern, feature-rich flight booking mobile application built with Flutter**

[Features](#features) • [Screenshots](#screenshots) • [Getting Started](#getting-started) • [Architecture](#architecture) • [Documentation](#documentation)

</div>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Running the App](#running-the-app)
- [Architecture](#architecture)
- [Backend Integration](#backend-integration)
- [State Management](#state-management)
- [Routing](#routing)
- [UI/UX Design](#uiux-design)
- [Testing](#testing)
- [Build & Deployment](#build--deployment)
- [Contributing](#contributing)
- [License](#license)

---

## 🌟 Overview

**SkyRace** is a comprehensive flight booking mobile application that provides users with a seamless experience for searching, booking, and managing flights. Built with Flutter, it offers a beautiful, responsive UI that works across iOS, Android, and web platforms.

The app follows modern software development practices including clean architecture, feature-first organization, and state management with Riverpod. It integrates with a REST API backend for real-time flight data, user authentication, and booking management.

---

## ✨ Features

### 🔐 **Authentication & User Management**
- **User Registration & Login** - Secure authentication with JWT tokens
- **Profile Management** - Edit user information and preferences
- **Persistent Sessions** - Auto-login with stored credentials
- **Logout** - Secure session termination

### ✈️ **Flight Search & Booking**
- **Smart Flight Search** - Search flights by origin, destination, and date
- **Real-time Flight Data** - Live flight information and availability
- **Advanced Filters** - Filter by price, duration, airline, and more
- **Flight Details** - Comprehensive flight information including:
  - Departure/arrival times and airports
  - Flight duration and direct/connecting status
  - Airline information
  - Fare rules and refund policies
- **Interactive Seat Selection** - Visual seat map with real-time availability
- **Multi-passenger Booking** - Book for multiple passengers in one transaction
- **Booking Confirmation** - Digital ticket generation with QR code

### 📱 **My Bookings**
- **Booking History** - View all past and upcoming bookings
- **Ticket Management** - Access digital tickets anytime
- **Check-in** - Online check-in functionality
- **Booking Details** - Complete booking information with passenger details

### 🎫 **Flight Status Tracking**
- **Real-time Flight Status** - Check live flight status by flight number
- **Gate & Terminal Information** - Up-to-date gate assignments
- **Delay Notifications** - Real-time updates on flight delays

### 🏆 **Loyalty Program (SkyRewards)**
- **Points Tracking** - Earn and track loyalty points
- **Tier System** - Bronze, Silver, Gold, Platinum tiers
- **Transaction History** - Complete points earning/redemption history
- **Benefits Overview** - View tier-specific benefits and perks

### 🔔 **Notifications**
- **Push Notifications** - Real-time alerts for:
  - Booking confirmations
  - Flight status changes
  - Check-in reminders
  - Special offers and promotions
- **In-app Notification Center** - View all notifications in one place
- **Mark as Read/Unread** - Manage notification status

### 💬 **Customer Support**
- **Help Center** - Comprehensive FAQ and help articles
- **Support Tickets** - Create and track support requests
- **Live Chat** - Real-time chat with support agents
- **Priority Support** - Based on loyalty tier
- **Ticket Categories** - Organized by issue type (booking, payment, technical, etc.)

### ⚙️ **Settings & Preferences**
- **Theme Selection** - Light/Dark mode support
- **Language Preferences** - Multi-language support
- **Currency Selection** - Multiple currency options
- **Notification Settings** - Customize notification preferences
- **Saved Passengers** - Quick access to frequently traveled companions

### 🎨 **UI/UX Features**
- **Modern Material Design 3** - Clean, intuitive interface
- **Smooth Animations** - Polished transitions and interactions
- **Shimmer Loading States** - Beautiful loading placeholders
- **Responsive Design** - Adapts to all screen sizes
- **Glass Morphism Effects** - Modern glassmorphic UI elements
- **Custom Color Scheme** - Branded color palette with gradients
- **Google Fonts Integration** - Beautiful typography with Inter font family

---

## 📸 Screenshots

<div align="center">

### **Authentication & Onboarding**

<table>
  <tr>
    <td align="center">
      <img src="screenshots/login.png" alt="Login Screen" width="250"/>
      <br />
      <b>Login Screen</b>
      <br />
      <sub>Secure user authentication</sub>
    </td>
    <td align="center">
      <img src="screenshots/register.png" alt="Register Screen" width="250"/>
      <br />
      <b>Register Screen</b>
      <br />
      <sub>New user registration</sub>
    </td>
    <td align="center">
      <img src="screenshots/profile.png" alt="Profile Screen" width="250"/>
      <br />
      <b>Profile Screen</b>
      <br />
      <sub>User profile management</sub>
    </td>
  </tr>
</table>

### **Flight Search & Discovery**

<table>
  <tr>
    <td align="center">
      <img src="screenshots/search.png" alt="Search Screen" width="250"/>
      <br />
      <b>Search Screen</b>
      <br />
      <sub>Find your perfect flight</sub>
    </td>
    <td align="center">
      <img src="screenshots/search_results.png" alt="Search Results" width="250"/>
      <br />
      <b>Search Results</b>
      <br />
      <sub>Browse available flights</sub>
    </td>
    <td align="center">
      <img src="screenshots/flight_details.png" alt="Flight Details" width="250"/>
      <br />
      <b>Flight Details</b>
      <br />
      <sub>Complete flight information</sub>
    </td>
  </tr>
</table>

### **Booking & Tickets**

<table>
  <tr>
    <td align="center">
      <img src="screenshots/seat_selection.png" alt="Seat Selection" width="250"/>
      <br />
      <b>Seat Selection</b>
      <br />
      <sub>Choose your preferred seat</sub>
    </td>
    <td align="center">
      <img src="screenshots/booking.png" alt="Booking Screen" width="250"/>
      <br />
      <b>Booking Screen</b>
      <br />
      <sub>Complete your booking</sub>
    </td>
    <td align="center">
      <img src="screenshots/ticket.png" alt="Digital Ticket" width="250"/>
      <br />
      <b>Digital Ticket</b>
      <br />
      <sub>Your boarding pass</sub>
    </td>
  </tr>
</table>

### **Bookings & Status**

<table>
  <tr>
    <td align="center">
      <img src="screenshots/my_bookings.png" alt="My Bookings" width="250"/>
      <br />
      <b>My Bookings</b>
      <br />
      <sub>Manage your trips</sub>
    </td>
    <td align="center">
      <img src="screenshots/flight_status.png" alt="Flight Status" width="250"/>
      <br />
      <b>Flight Status</b>
      <br />
      <sub>Real-time flight tracking</sub>
    </td>
    <td align="center">
      <img src="screenshots/checkin.png" alt="Check-in" width="250"/>
      <br />
      <b>Online Check-in</b>
      <br />
      <sub>Check-in before you fly</sub>
    </td>
  </tr>
</table>

### **Loyalty & Rewards**

<table>
  <tr>
    <td align="center">
      <img src="screenshots/loyalty.png" alt="Loyalty Program" width="250"/>
      <br />
      <b>SkyRewards</b>
      <br />
      <sub>Loyalty program dashboard</sub>
    </td>
    <td align="center">
      <img src="screenshots/loyalty_history.png" alt="Points History" width="250"/>
      <br />
      <b>Points History</b>
      <br />
      <sub>Track your rewards</sub>
    </td>
    <td align="center">
      <img src="screenshots/notifications.png" alt="Notifications" width="250"/>
      <br />
      <b>Notifications</b>
      <br />
      <sub>Stay updated</sub>
    </td>
  </tr>
</table>

### **Support & Settings**

<table>
  <tr>
    <td align="center">
      <img src="screenshots/help_center.png" alt="Help Center" width="250"/>
      <br />
      <b>Help Center</b>
      <br />
      <sub>FAQ and support</sub>
    </td>
    <td align="center">
      <img src="screenshots/support_tickets.png" alt="Support Tickets" width="250"/>
      <br />
      <b>Support Tickets</b>
      <br />
      <sub>Track your inquiries</sub>
    </td>
    <td align="center">
      <img src="screenshots/settings.png" alt="Settings" width="250"/>
      <br />
      <b>Settings</b>
      <br />
      <sub>Customize your experience</sub>
    </td>
  </tr>
</table>

### **Dark Mode Support**

<table>
  <tr>
    <td align="center">
      <img src="screenshots/dark_mode_search.png" alt="Dark Mode - Search" width="250"/>
      <br />
      <b>Dark Mode - Search</b>
    </td>
    <td align="center">
      <img src="screenshots/dark_mode_results.png" alt="Dark Mode - Results" width="250"/>
      <br />
      <b>Dark Mode - Results</b>
    </td>
    <td align="center">
      <img src="screenshots/dark_mode_profile.png" alt="Dark Mode - Profile" width="250"/>
      <br />
      <b>Dark Mode - Profile</b>
    </td>
  </tr>
</table>

</div>

### 📷 **How to Add Screenshots**

To populate this section with actual screenshots from your app:

1. **Create the screenshots directory:**
   ```bash
   mkdir screenshots
   ```

2. **Capture screenshots from your app:**
   - **Android Emulator:** Use the camera icon or `Ctrl+S` (Windows/Linux) / `Cmd+S` (Mac)
   - **iOS Simulator:** Use `Cmd+S` or Device → Screenshot
   - **Physical Device:** Use device screenshot method and transfer to computer

3. **Recommended Screenshot Specifications:**
   - **Resolution:** 1080x2400 (9:19.5 aspect ratio) or device native resolution
   - **Format:** PNG (for quality) or JPG (for smaller file size)
   - **File Size:** Keep under 500KB per image for faster loading
   - **Background:** Use consistent device frames (optional)

4. **Name and organize screenshots:**
   ```
   screenshots/
   ├── login.png
   ├── register.png
   ├── profile.png
   ├── search.png
   ├── search_results.png
   ├── flight_details.png
   ├── seat_selection.png
   ├── booking.png
   ├── ticket.png
   ├── my_bookings.png
   ├── flight_status.png
   ├── checkin.png
   ├── loyalty.png
   ├── loyalty_history.png
   ├── notifications.png
   ├── help_center.png
   ├── support_tickets.png
   ├── settings.png
   ├── dark_mode_search.png
   ├── dark_mode_results.png
   └── dark_mode_profile.png
   ```

5. **Optional: Use device frames**
   - Use tools like [Mockuphone](https://mockuphone.com/) or [Screenly](https://www.screely.com/)
   - Or [Device Frames](https://deviceframes.com/) for professional-looking screenshots

6. **Optimize images before committing:**
   ```bash
   # Using ImageOptim (Mac)
   # or TinyPNG (Web)
   # or pngquant (CLI)
   pngquant screenshots/*.png --ext .png --force
   ```

7. **Commit screenshots to repository:**
   ```bash
   git add screenshots/
   git commit -m "Add app screenshots"
   git push
   ```

### 🎥 **Optional: Create an App Demo Video**

Consider creating a short demo video (30-60 seconds) showcasing the app's key features:

1. **Record screen:**
   - **Android:** Use built-in screen recorder or `adb screenrecord`
   - **iOS:** Use built-in screen recording (Control Center)
   - **Desktop:** Use OBS Studio or QuickTime (Mac)

2. **Edit and compress:**
   - Use [HandBrake](https://handbrake.fr/) for compression
   - Keep video under 10MB or host on YouTube/Vimeo

3. **Add to README:**
   ```markdown
   ### 🎬 Demo Video
   
   [![SkyRace Demo](https://img.youtube.com/vi/YOUR_VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=YOUR_VIDEO_ID)
   ```

---

## 🛠 Tech Stack

### **Frontend Framework**
- **Flutter 3.9.2+** - Cross-platform mobile framework
- **Dart 3.9.2+** - Programming language

### **State Management**
- **Riverpod 3.1.0** - Reactive state management solution

### **Navigation**
- **GoRouter 17.0.1** - Declarative routing with deep linking support

### **UI & Design**
- **Material Design 3** - Modern design system
- **Google Fonts 6.3.3** - Custom typography (Inter font family)
- **Flutter SVG 2.2.3** - SVG rendering
- **Shimmer 3.0.0** - Loading state animations

### **Networking**
- **HTTP 1.6.0** - REST API communication
- **JSON Serialization** - Manual JSON parsing

### **Local Storage**
- **SharedPreferences 2.5.4** - Persistent local storage for tokens and preferences

### **Utilities**
- **Intl 0.20.2** - Internationalization and date formatting

### **Development Tools**
- **Flutter Lints 5.0.0** - Linting and code quality
- **Flutter Test** - Unit and widget testing

---

## 📁 Project Structure

The project follows a **feature-first architecture** with clear separation of concerns:

```
lib/
├── main.dart                          # Application entry point
├── src/
│   ├── app.dart                       # Main app widget with theme & routing setup
│   │
│   ├── constants/                     # App-wide constants
│   │   ├── app_colors.dart           # Color palette and gradients
│   │   └── design_system.dart        # Design tokens (spacing, shadows, text styles)
│   │
│   ├── routing/                       # Navigation configuration
│   │   └── app_router.dart           # GoRouter setup with auth guards
│   │
│   ├── utils/                         # Utility classes
│   │   ├── theme.dart                # Light/Dark theme definitions
│   │   └── theme_controller.dart     # Theme state management
│   │
│   └── features/                      # Feature modules
│       │
│       ├── auth/                      # Authentication & User Management
│       │   ├── data/
│       │   │   └── auth_repository.dart        # API calls for auth
│       │   ├── domain/
│       │   │   └── user.dart                   # User & UserPreferences models
│       │   └── presentation/
│       │       ├── auth_controller.dart        # Auth state management
│       │       ├── login_screen.dart           # Login UI
│       │       ├── register_screen.dart        # Registration UI
│       │       └── edit_profile_screen.dart    # Profile editing UI
│       │
│       ├── search/                    # Flight Search & Discovery
│       │   ├── data/
│       │   │   └── flights_repository.dart     # Flight search API
│       │   ├── domain/
│       │   │   ├── flight.dart                 # Flight & Seat models
│       │   │   ├── location.dart               # Location data
│       │   │   └── search_state.dart           # Search state model
│       │   └── presentation/
│       │       ├── search_screen.dart          # Search form UI
│       │       ├── search_results_screen.dart  # Search results list
│       │       ├── flight_details_screen.dart  # Flight details view
│       │       ├── flight_status_screen.dart   # Flight status tracker
│       │       ├── location_picker.dart        # Location selection widget
│       │       ├── passenger_selector.dart     # Passenger count selector
│       │       ├── flight_card_shimmer.dart    # Loading skeleton
│       │       ├── search_controller.dart      # Search state management
│       │       ├── search_history_controller.dart  # Search history
│       │       └── search_results_controller.dart  # Results state
│       │
│       ├── bookings/                  # Booking Management
│       │   ├── data/
│       │   │   ├── bookings_repository.dart    # Booking API calls
│       │   │   └── checkin_repository.dart     # Check-in API
│       │   ├── domain/
│       │   │   └── booking.dart                # Booking & Passenger models
│       │   └── presentation/
│       │       ├── booking_screen.dart         # Booking form
│       │       ├── seat_selection_screen.dart  # Seat selection UI
│       │       ├── my_bookings_screen.dart     # Booking history
│       │       ├── ticket_screen.dart          # Digital ticket view
│       │       ├── checkin_screen.dart         # Check-in flow
│       │       └── booking_controller.dart     # Booking state
│       │
│       ├── home/                      # Home & Navigation
│       │   ├── data/
│       │   │   ├── loyalty_repository.dart     # Loyalty program API
│       │   │   └── notification_repository.dart # Notifications API
│       │   └── presentation/
│       │       ├── main_screen.dart            # Bottom nav container
│       │       ├── loyalty_screen.dart         # Loyalty program UI
│       │       ├── notifications_screen.dart   # Notification center
│       │       ├── help_center_screen.dart     # Help & FAQ
│       │       ├── settings_screen.dart        # App settings
│       │       └── navigation_controller.dart  # Bottom nav state
│       │
│       ├── profile/                   # Profile Management
│       │   └── presentation/
│       │       └── saved_passengers_screen.dart # Saved travelers
│       │
│       ├── support/                   # Customer Support
│       │   ├── data/
│       │   │   └── support_repository.dart     # Support tickets API
│       │   ├── domain/
│       │   │   └── support_ticket.dart         # Ticket & Response models
│       │   └── presentation/
│       │       ├── support_tickets_screen.dart # Ticket list
│       │       ├── create_ticket_screen.dart   # Create new ticket
│       │       └── ticket_chat_screen.dart     # Ticket conversation
│       │
│       └── settings/                  # App Settings
│           └── presentation/
│               └── theme_controller.dart       # Theme preference state
```

### **Architecture Highlights**

#### **Feature Organization**
Each feature module is organized into three layers:

1. **Data Layer** (`data/`)
   - Repository classes for API communication
   - Data source implementations
   - Network request/response handling

2. **Domain Layer** (`domain/`)
   - Business models (entities)
   - Pure Dart classes with no framework dependencies
   - JSON serialization/deserialization

3. **Presentation Layer** (`presentation/`)
   - UI screens and widgets
   - State management controllers (Riverpod providers)
   - User interaction handling

This structure provides:
- ✅ **Clear separation of concerns**
- ✅ **Easy testability**
- ✅ **Scalable codebase**
- ✅ **Independent feature development**

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK 3.9.2 or higher**
  ```bash
  flutter --version
  ```
  
- **Dart SDK 3.9.2 or higher** (included with Flutter)

- **Android Studio** (for Android development) with:
  - Android SDK
  - Android Emulator
  
- **Xcode** (for iOS development, macOS only)

- **VS Code** or **Android Studio** with Flutter/Dart plugins

- **Git** for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/skyrace.git
   cd skyrace
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter installation**
   ```bash
   flutter doctor
   ```
   Resolve any issues reported by `flutter doctor`.

### Configuration

#### **1. Backend API Configuration**

The app is configured to connect to a backend API running on `http://10.0.2.2:5000/api` (Android emulator localhost).

**Update API endpoint for your environment:**

Edit the `baseUrl` in repository files:
- `lib/src/features/auth/data/auth_repository.dart`
- `lib/src/features/search/data/flights_repository.dart`
- `lib/src/features/bookings/data/bookings_repository.dart`
- `lib/src/features/support/data/support_repository.dart`
- `lib/src/features/home/data/loyalty_repository.dart`
- `lib/src/features/home/data/notification_repository.dart`

```dart
// For Android Emulator
final String baseUrl = 'http://10.0.2.2:5000/api';

// For iOS Simulator
final String baseUrl = 'http://localhost:5000/api';

// For Physical Device (use your computer's IP)
final String baseUrl = 'http://192.168.1.XXX:5000/api';

// For Production
final String baseUrl = 'https://api.skyrace.com/api';
```

**Recommendation:** Create a configuration file for environment-specific settings:

```dart
// lib/src/config/api_config.dart
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:5000/api',
  );
}
```

#### **2. Android Configuration**

**Update package name** (optional):
- Edit `android/app/build.gradle.kts`
- Change `applicationId` to your package name

**Permissions:**
The app requires internet permission (already configured in `AndroidManifest.xml`).

#### **3. iOS Configuration**

**Update bundle identifier** (optional):
- Open `ios/Runner.xcodeproj` in Xcode
- Select Runner target → General → Bundle Identifier

**Permissions:**
Add required permissions in `ios/Runner/Info.plist` if needed.

### Running the App

#### **Development Mode**

**Run on Android Emulator:**
```bash
flutter run
```

**Run on iOS Simulator:**
```bash
flutter run -d ios
```

**Run on specific device:**
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

**Hot Reload:**
Press `r` in the terminal or use your IDE's hot reload button.

**Hot Restart:**
Press `R` in the terminal or use your IDE's hot restart button.

#### **Release Mode**

**Android APK:**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

**iOS (requires macOS & Xcode):**
```bash
flutter build ios --release
```
Then open `ios/Runner.xcworkspace` in Xcode to archive and upload.

**Web:**
```bash
flutter build web --release
```
Output: `build/web/`

---

## 🏗 Architecture

### **Clean Architecture Principles**

The app follows clean architecture with clear boundaries between layers:

```
┌─────────────────────────────────────┐
│     Presentation Layer              │
│  (UI, Widgets, Controllers)         │
│  - ConsumerWidgets (Riverpod)       │
│  - StateNotifiers                   │
│  - UI Components                    │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│     Domain Layer                    │
│  (Business Logic, Models)           │
│  - Entities                         │
│  - Business Models                  │
│  - Pure Dart classes                │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│     Data Layer                      │
│  (Repositories, Data Sources)       │
│  - API Integration                  │
│  - Local Storage                    │
│  - Data Transformation              │
└─────────────────────────────────────┘
```

### **Key Architectural Decisions**

1. **Feature-First Organization**
   - Each feature is self-contained
   - Easy to locate and modify feature code
   - Supports parallel development

2. **Riverpod for State Management**
   - Type-safe providers
   - Compile-time safety
   - Better testing support
   - No BuildContext dependency

3. **GoRouter for Navigation**
   - Declarative routing
   - Deep linking support
   - Type-safe navigation
   - Auth guards and redirects

4. **Repository Pattern**
   - Abstraction over data sources
   - Easy to mock for testing
   - Centralized error handling

---

## 🔌 Backend Integration

### **API Endpoints**

The app integrates with a RESTful backend API. All endpoints are prefixed with `/api`.

#### **Authentication Endpoints**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/auth/register` | Register new user | No |
| POST | `/auth/login` | Login user | No |
| PUT | `/auth/profile` | Update profile | Yes |
| PUT | `/auth/preferences` | Update preferences | Yes |

**Example Request (Login):**
```json
POST /api/auth/login
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Example Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "_id": "123456",
    "name": "John Doe",
    "email": "user@example.com",
    "preferences": {
      "language": "en",
      "currency": "USD",
      "theme": "light"
    },
    "loyaltyPoints": 1500,
    "loyaltyTier": "Gold"
  }
}
```

#### **Flight Endpoints**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/flights/search?from=NYC&to=LAX&date=2024-01-01` | Search flights | No |

#### **Booking Endpoints**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/bookings` | Create booking | Yes |
| GET | `/bookings` | Get user bookings | Yes |

#### **Support Endpoints**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/support` | Get user tickets | Yes |
| POST | `/support` | Create ticket | Yes |
| POST | `/support/:id/response` | Add response | Yes |

#### **Loyalty Endpoints**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/loyalty/history` | Get points history | Yes |

#### **Notification Endpoints**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/notifications` | Get notifications | Yes |
| PUT | `/notifications/:id/read` | Mark as read | Yes |
| PUT | `/notifications/read-all` | Mark all as read | Yes |

### **Authentication**

The app uses **JWT (JSON Web Tokens)** for authentication:

1. User logs in with email/password
2. Backend returns JWT token
3. Token is stored in SharedPreferences
4. Token is sent in Authorization header: `Bearer <token>`
5. Token is validated on protected endpoints

---

## 🎯 State Management

### **Riverpod Providers**

The app uses various Riverpod provider types:

#### **Provider Types Used**

1. **Provider** - Immutable, read-only values
   ```dart
   final authRepositoryProvider = Provider<AuthRepository>((ref) {
     return AuthRepository();
   });
   ```

2. **StateNotifierProvider** - Mutable state with business logic
   ```dart
   final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
     return AuthController(ref.read(authRepositoryProvider));
   });
   ```

3. **StateProvider** - Simple mutable state
   ```dart
   final navigationControllerProvider = StateProvider<int>((ref) => 0);
   ```

#### **Key Controllers**

- **AuthController** - User authentication state
- **SearchController** - Flight search parameters
- **SearchResultsController** - Flight search results
- **BookingController** - Booking flow state
- **NavigationController** - Bottom navigation state
- **ThemeController** - App theme preference

---

## 🧭 Routing

### **Route Definitions**

The app uses GoRouter with the following routes:

| Path | Screen | Auth Required | Parameters |
|------|--------|---------------|------------|
| `/` | MainScreen | No | - |
| `/login` | LoginScreen | No | - |
| `/register` | RegisterScreen | No | - |
| `/results` | SearchResultsScreen | No | - |
| `/results/details` | FlightDetailsScreen | No | Flight object |
| `/booking` | BookingScreen | Yes | Flight object |
| `/ticket` | TicketScreen | Yes | Booking object |
| `/edit-profile` | EditProfileScreen | Yes | - |
| `/loyalty` | LoyaltyScreen | Yes | - |
| `/help-center` | HelpCenterScreen | Yes | - |
| `/settings` | SettingsScreen | Yes | - |

### **Auth Guards**

Routes are protected based on authentication state:
- Unauthenticated users are redirected to `/login` when accessing protected routes
- Authenticated users are redirected to `/` when accessing auth routes

---

## 🎨 UI/UX Design

### **Design System**

#### **Color Palette**
```dart
// Primary Colors
primary: Color(0xFF6366F1)  // Indigo
secondary: Color(0xFF8B5CF6) // Purple

// Gradients
primaryGradient: LinearGradient(
  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]
)

// Semantic Colors
success: Color(0xFF10B981)  // Green
warning: Color(0xFFF59E0B)  // Amber
error: Color(0xFFEF4444)    // Red

// Neutrals
textDark: Color(0xFF1F2937)
textMedium: Color(0xFF6B7280)
textLight: Color(0xFF9CA3AF)
background: Color(0xFFF9FAFB)
```

#### **Typography**
- **Font Family:** Inter (via Google Fonts)
- **Heading 1:** 32px, Bold
- **Heading 2:** 24px, Bold
- **Body Large:** 16px, Regular
- **Body Medium:** 14px, Regular
- **Caption:** 12px, Regular

#### **Spacing Scale**
- **XS:** 4px
- **S:** 8px
- **M:** 16px
- **L:** 24px
- **XL:** 32px

#### **Border Radius**
- **Small:** 8px
- **Medium:** 16px
- **Large:** 24px
- **Full:** 100px

#### **Shadows**
- **Soft Shadow:** Subtle elevation for cards
- **Medium Shadow:** Moderate elevation for modals

---

## 🧪 Testing

### **Running Tests**

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### **Test Structure**

```
test/
├── unit/                    # Unit tests
│   ├── models/             # Model tests
│   ├── repositories/       # Repository tests
│   └── controllers/        # Controller tests
├── widget/                 # Widget tests
│   └── screens/           # Screen widget tests
└── integration/           # Integration tests
```

### **Writing Tests**

**Example Unit Test:**
```dart
test('User model fromJson', () {
  final json = {
    '_id': '123',
    'name': 'Test User',
    'email': 'test@example.com',
  };
  
  final user = User.fromJson(json);
  
  expect(user.id, '123');
  expect(user.name, 'Test User');
  expect(user.email, 'test@example.com');
});
```

---

## 📦 Build & Deployment

### **Version Management**

Update version in `pubspec.yaml`:
```yaml
version: 1.0.0+1  # version+build_number
```

### **Android Deployment**

1. **Configure signing:**
   - Create `android/key.properties`
   - Generate keystore
   - Update `android/app/build.gradle.kts`

2. **Build release:**
   ```bash
   flutter build appbundle --release
   ```

3. **Upload to Play Console:**
   - Go to Google Play Console
   - Create app and upload AAB
   - Fill store listing details
   - Submit for review

### **iOS Deployment**

1. **Configure in Xcode:**
   - Open `ios/Runner.xcworkspace`
   - Set team and bundle identifier
   - Configure signing & capabilities

2. **Build archive:**
   ```bash
   flutter build ios --release
   ```

3. **Upload to App Store Connect:**
   - Archive in Xcode
   - Upload to App Store Connect
   - Fill app information
   - Submit for review

### **Web Deployment**

```bash
flutter build web --release --web-renderer html
```

Deploy `build/web/` to:
- Firebase Hosting
- Netlify
- Vercel
- GitHub Pages

---

## 🤝 Contributing

### **Development Workflow**

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Run tests**
   ```bash
   flutter test
   ```
5. **Check formatting**
   ```bash
   flutter format .
   ```
6. **Run analyzer**
   ```bash
   flutter analyze
   ```
7. **Commit your changes**
   ```bash
   git commit -m 'Add amazing feature'
   ```
8. **Push to branch**
   ```bash
   git push origin feature/amazing-feature
   ```
9. **Open a Pull Request**

### **Code Style**

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter format` for consistent formatting
- Write meaningful commit messages
- Add comments for complex logic
- Keep functions small and focused

### **Pull Request Guidelines**

- Provide clear description of changes
- Link related issues
- Include screenshots for UI changes
- Ensure all tests pass
- Update documentation if needed

---

## 📄 License

This project is private and not licensed for public use.

---

## 👥 Authors

**Your Team Name**

---

## 📞 Support

For issues and questions:
- Create an issue in the repository
- Contact: support@skyrace.com

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for state management
- Google Fonts for typography
- All contributors and testers

---

<div align="center">

**Built with ❤️ using Flutter**

[⬆ Back to Top](#skyrace-)

</div>
