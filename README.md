<div align="center">

# 🏥 CareConnect

### Home Care, Made Simple

A beautiful, feature-rich home-care nursing booking application built with Flutter

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-blueviolet?style=for-the-badge)]()

<p align="center">
  <img src="assets/care_connect.png" alt="CareConnect Logo" width="200"/>
</p>

**Find certified caregivers, book home visits, and manage your care — all from your pocket.**

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Tech Stack](#-tech-stack) • [Architecture](#-architecture) • [Contributing](#-contributing)

</div>

---

## ✨ Features

### 👤 **Authentication & Onboarding**
- 🔐 Email/password authentication via Firebase Auth
- 🗺️ 3-page onboarding carousel for first-time users
- 🔑 Forgot password flow with email reset
- 📸 Profile photo picker during registration

### 🔍 **Caregiver Discovery**
- 👩‍⚕️ Browse certified caregivers with detailed profiles
- 🏷️ Filter by specialty (General Nursing, Elderly Care, Pediatric Care, etc.)
- 🔎 Search caregivers by name or keyword
- ⭐ View ratings, experience, hourly rates, and skills

### 📅 **Smart Booking Flow**
- 📋 4-step booking wizard: Service → Date/Time → Details → Review
- 🕐 Pick available time slots with configurable duration
- 📍 Add address and special notes for each booking
- ✅ Instant booking confirmation with summary

### 📊 **Dashboard & Analytics**
- 🏠 Personalized greeting with user info
- 📈 Stats grid: active requests, upcoming visits, completed, total bookings
- ⚡ Quick actions: Book Nurse, Records, History, Support
- 📰 Recent activity feed for quick status updates

### 📜 **Booking Management**
- 📂 Booking history with segmented filters (Upcoming / Past / Cancelled)
- ❌ Cancel active bookings with ease
- 🔄 Pull-to-refresh for live updates
- 🔔 Alerts & notifications for booking updates

### 👤 **Profile Management**
- 🖼️ Editable avatar with camera/gallery image picker
- ✏️ Update name, email, and phone number
- ⚙️ Account & preferences menu (support, about, logout)
- 📱 Responsive design across all screen sizes

---

## 📱 Screenshots

<div align="center">

<!-- Add screenshots here -->
<!-- ![Onboarding](screenshots/onboarding.png)
![Login](screenshots/login.png)
![Dashboard](screenshots/dashboard.png)
![Caregivers](screenshots/caregivers.png)
![Booking](screenshots/booking.png) -->

</div>

---

## 🛠️ Tech Stack

<table>
<tr>
<td align="center" width="150">

**State Management**

</td>
<td align="center" width="150">

**Backend**

</td>
<td align="center" width="150">

**Navigation**

</td>
<td align="center" width="150">

**Architecture**

</td>
</tr>
<tr>
<td align="center">

![BLoC](https://img.shields.io/badge/BLoC-02569B?style=flat-square&logo=flutter&logoColor=white)

</td>
<td align="center">

![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![Firestore](https://img.shields.io/badge/Firestore-FFCA28?style=flat-square&logo=firebase&logoColor=black)

</td>
<td align="center">

![GoRouter](https://img.shields.io/badge/GoRouter-02569B?style=flat-square&logo=flutter&logoColor=white)

</td>
<td align="center">

![Clean Arch](https://img.shields.io/badge/Clean%20Arch-6DB33F?style=flat-square&logo=flutter&logoColor=white)

</td>
</tr>
</table>

### Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management with Cubits |
| `get_it` | Dependency injection / service locator |
| `go_router` | Declarative routing with auth guards |
| `firebase_core` | Firebase initialization |
| `firebase_auth` | Email/password authentication |
| `cloud_firestore` | Real-time user & booking data |
| `dartz` | Functional error handling (Either) |
| `dio` | HTTP client for REST API calls |
| `cached_network_image` | Efficient image loading & caching |
| `image_picker` | Camera & gallery for profile photos |
| `shared_preferences` | Local persistence (onboarding, session) |
| `google_fonts` | Inter font family |
| `intl` | Date formatting & localization |
| `equatable` | Value equality for entities & states |

---

## 🏗️ Architecture

The project follows **Clean Architecture** principles with **Feature-First** organization:

```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # Firebase platform config
├── core/                        # Shared components
│   ├── config/                  # App configuration (API, mock flag)
│   ├── di/                      # GetIt service locator
│   ├── error/                   # Exceptions & failures
│   ├── network/                 # Dio HTTP client with auth interceptor
│   ├── router/                  # GoRouter setup with auth guards
│   ├── theme/                   # Material 3 theme (colors, typography, spacing)
│   ├── usecase/                 # Base UseCase contract
│   ├── utils/                   # Validators, image utilities
│   └── widgets/                 # Reusable widgets (cards, loaders, badges)
└── features/                    # Feature modules
    ├── splash/                  # Animated splash screen
    ├── onboarding/              # 3-page onboarding flow
    ├── auth/                    # Authentication (login, register, forgot password)
    ├── dashboard/               # Main shell with tabs (Home, Services, History, Profile)
    ├── booking/                 # Caregiver search, detail, booking flow, history
    └── profile/                 # User profile management
```

### Design Patterns

| Pattern | Usage |
|---------|-------|
| **Clean Architecture** | 3-layer separation: `data/` → `domain/` → `presentation/` |
| **Repository Pattern** | Abstract repositories with concrete implementations |
| **Use Cases** | Single-responsibility business logic classes |
| **Cubit (BLoC)** | Lightweight state management per feature |
| **Dependency Injection** | `get_it` service locator for all dependencies |
| **Auth Guard** | GoRouter redirect based on `AuthCubit` state |

---

## 📂 Service Categories

| Service | Description |
|---------|-------------|
| 🏥 General Nursing | Comprehensive nursing care at home |
| 👴 Elderly Care | Specialized care for senior citizens |
| 👶 Pediatric Care | Professional care for infants & children |
| 🩺 Post-Surgery Care | Recovery assistance after surgical procedures |
| 💪 Physical Therapy | In-home rehabilitation & therapy sessions |

---

## 🚀 Installation

### Prerequisites

- Flutter SDK `^3.10.0`
- Dart SDK `^3.0.0`
- Android Studio / VS Code
- Git
- A Firebase project (for auth & Firestore)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Mahmoudelnagar5/care_connect_app.git
   cd care_connect_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Or run `flutterfire configure` to auto-generate

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## 📁 Environment Configuration

The app uses `AppConfig` in `lib/core/config/app_config.dart`:

| Variable | Default | Description |
|----------|---------|-------------|
| `API_BASE_URL` | `https://api.careconnect.example.com/v1` | REST API endpoint |
| `useMockData` | `true` | Toggle between mock & real backend |
| `mockDelay` | `700ms` | Simulated network latency |
| `connectTimeout` | `20s` | HTTP connection timeout |

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 👨‍💻 Author

<div align="center">

**Mahmoud Elnagar**

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Mahmoudelnagar5)

</div>

---

<div align="center">

### ⭐ Star this repo if you find it useful!

Made with ❤️ and Flutter

</div>
