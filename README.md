# Flutter Application Template

A comprehensive Flutter application template with authentication, home page, and profile settings
functionality.

## Table of Contents

- [Features](#features)
- [Environment Setup](#environment-setup)
    - [Prerequisites](#prerequisites)
    - [Project Structure](#project-structure)
- [State Management](#state-management)
- [Key Packages](#key-packages)
- [Building and Deployment](#building-and-deployment)
    - [Android](#android)
    - [iOS](#ios)
- [Development Guidelines](#development-guidelines)
    - [Branch Naming Convention](#branch-naming-convention)
    - [Commit Message Format](#commit-message-format)
    - [Pull Request Process](#pull-request-process)
- [Getting Started](#getting-started)

## Features

- User Authentication (Login/Signup)
- Home Dashboard
- Profile Settings
- Responsive Design [link](./READMEScreenutil.md)
- Internationalization Support [link](./READMELanguage.md)
- Provider State Management

## Environment Setup

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK
- Android Studio / VS Code
- Git

### Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── route_constants.dart
│   ├── services/
│   │   ├── storage_service.dart
│   │   └── navigation_service.dart
│   └── utils/
│       └── validators.dart
├── generated/
│   └── l10n/  # Internationalization
├── features/
│   ├── auth/
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   ├── screens/
│   │   │   └── login_screen.dart
│   │   ├── widgets/
│   │   │   └── login_widget.dart
├── router/
│   └── app_router.dart
├── utils/
│   └── utils.dart
├── custom_widget/
│   └── custom_button.dart
└── main.dart
```

## State Management

The application uses Provider for state management. Here's a basic example:

```dart
// UI Class
class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModel: LoginViewModel(),
      onModelReady: (model) {
        model.init();
      },
      buildAppBar: Container(),
      onPageBuilder: (BuildContext context, LoginViewModel viewModel) {
        final loginApiResponse = viewModel.getResponse(LoginViewModel.loginApi);
        return LoadingWidget(
          isLoading: false,
          child: Container(),
        );
      },
    );
  }
}

// Provider Class
class LoginViewModel extends BaseProvider {
  @override
  void init() {
    // Initialize your screens model
  }
}
```

## Key Packages

- **flutter_screenutil**: For responsive design
- **intl_utils**: For internationalization
- **provider**: For state management

## Building and Deployment

### Android

1. Update version in pubspec.yaml
2. Build APK:


### iOS

1. Update version in pubspec.yaml
2. Setup certificates in Xcode
3. Build IPA:

## Development Guidelines

### Branch Naming Convention

- `feature/feature-name`
- `bugfix/bug-description`
- `hotfix/issue-description`

### Commit Message Format

- `feat:` Add new feature
- `fix:` Bug fix
- `docs:` Documentation updates
- `style:` Code style changes
- `refactor:` Code refactoring

### Pull Request Process

1. Create feature branch
2. Implement changes
3. Add tests
4. Update documentation
5. Create pull request
6. Code review
7. Merge after approval

## Getting Started

1. Clone the repository

```bash
git clone https://git.trantorinc.com/visa/amigoapp.git
```

2. Install dependencies

```bash
flutter pub get
```

3. Run the app

```bash
flutter run -t lib/main_dev.dart --flavor dev  
```

Deeplink
```bash
 adb shell am start -a android.intent.action.VIEW -d "https://visa.dev.com/signup?email=dhruvil.dhulia@trantorinc.com" com.visa.eva.dev
```

```bash
 xcrun simctl openurl booted "https://visa.dev.com/signup?email=dhruvil.dhulia@trantorinc.com"
```

```bash
  flutter build apk --flavor prod --release -t lib/main_prod.dart 
```

QA Build

```bash
flutter clean
flutter pub get
flutter build apk --flavor qa --release -t lib/main_qa.dart --obfuscate --split-debug-info=build/qa/debug-info
```

Prod Build

```bash
flutter clean
flutter pub get
 flutter build apk --flavor prod --release -t lib/main_prod.dart --obfuscate --split-debug-info=build/prod/debug-info
```

UAT Build

```bash
flutter clean
flutter pub get
 flutter build apk --flavor dev --release -t lib/main_dev.dart --obfuscate --split-debug-info=build/qa/debug-info
```

```bash
flutter clean
flutter pub get
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```
