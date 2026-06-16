# Flutter MVC Folder Structure

```text
lib/
│
├── models/
│   ├── user_model.dart
│   ├── product_model.dart
│
├── views/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │
│   ├── login/
│   │   ├── login_screen.dart
│   │   └── widgets/
│
├── controllers/
│   ├── auth_controller.dart
│   ├── product_controller.dart
│
├── services/
│   ├── api_service.dart
│   ├── firebase_service.dart
│
├── utils/
│   ├── colors.dart
│   ├── constants.dart
│   ├── helpers.dart
│
├── routes/
│   └── app_routes.dart
│
├── widgets/
│   ├── custom_button.dart
│   ├── loading_widget.dart
│
└── main.dart
```

## Folder Explanation

* **models/** → Data models and API response classes
* **views/** → UI screens and screen specific widgets
* **controllers/** → Business logic and state management
* **services/** → API, Firebase, database and external services
* **utils/** → Constants, colors, helpers and utility files
* **routes/** → App navigation and route management
* **widgets/** → Reusable common widgets
* **main.dart** → Application entry point










# hacathon_2026

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
