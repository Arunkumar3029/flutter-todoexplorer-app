# Todos Explorer

A clean, high-performance Flutter application designed for exploring and managing tasks with ease. This project prioritizes a smooth user experience, solid state management, and a highly maintainable code structure.

## Key Features

- **Live Data Fetching**: Seamlessly retrieves todos from the JSONPlaceholder API with robust error handling and automatic retry options.
- **Interactive Tasks**: Instantly toggle any task's status between **Completed** and **Pending** by tapping its status icon.
- **Precision Search**: Find exactly what you're looking for with real-time keyword search and clear visual highlighting.
- **Smart Filtering**: Quickly narrow down your list by task status—view all, only completed, or only pending tasks.
- **Flexible Sorting**: Multiple sorting options, including alphabetical order and status-based priority, to help you organize your workflow.
- **Infinite Scrolling**: Optimized pagination that dynamically loads more tasks as you browse, ensuring the app stays fast even with large datasets.
- **Offline Reliability**: Locally caches your tasks so you can continue using the app even without an active internet connection.
- **Responsive Layout**: Intelligently adapts your view—switching between a clean single-column list for mobile and a structured grid for larger screens.
- **Personalized Favorites**: Mark your most important tasks with a star and view them all in one place on a dedicated screen.

## Technical Overview

### Architecture
The project is built with a modular, layered architecture that keeps the codebase predictable and easy to scale:

- **Models**: Immutable data structures using `copyWith` for safe and predictable state changes.
- **Services**: A dedicated layer for all network traffic, isolating external dependencies and handling custom `ApiException` cases.
- **State Management**: Uses the **Provider** pattern to handle data flow reactively across the entire application.
- **Widgets**: Reusable, lightweight components designed to keep the UI consistent and performant.
- **Design System**: A centralized system for all **Colors** and **Constants**, making the app's look and feel easy to change from a single file.

### Tech Stack
- **Flutter Framework**
- **Provider** (State Orchestration)
- **Http** (API Communications)
- **Shared Preferences** (Persistent Cache)

## Getting Started

### Installation
1. Make sure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
2. Clone this repository to your computer.
3. Run `flutter pub get` in the project folder to install dependencies.
4. Launch the app on your emulator or device with `flutter run`.

### Running Tests
To verify everything is working perfectly as planned:

```bash
flutter test
```



