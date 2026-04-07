# KutootAssign

A high-performance Flutter application demonstrating advanced architecture, performance optimization, and offline-first capabilities.

## Features

### 1. Infinite Performance Feed
- Infinite scrolling feed with paginated mock API
- `CustomPainter` for lightweight chart rendering
- `Isolate.run()` for background JSON parsing
- `RepaintBoundary` to prevent unnecessary repaints
- `CancelToken` to abort stale network requests on fast scroll
- `CachedNetworkImage` for memory-efficient image loading
- Pull-to-refresh support

### 2. Offline-First Task Manager
- Add, complete, and delete tasks
- Local persistence using Hive
- Optimistic UI updates — instant feedback on actions
- Automatic sync with mock backend when connectivity restores
- Real-time online/offline status indicator
- Snackbar notifications on connectivity changes
- Sync status badges (Synced / Pending) per task

## Tech Stack
- **Flutter** (latest stable)
- **Riverpod 3.x** (Notifier pattern)
- **Hive** (local database)
- **Dio** (networking + mock interceptor)
- **connectivity_plus** (network monitoring)
- **cached_network_image** (image caching)

## Architecture
Feature-first clean architecture:
```
lib/
  core/
    database/       # Hive setup
    network/        # Dio client, connectivity service
    theme/          # App theme
  features/
    infinite_feed/
      data/         # Models, repository
      presentation/ # Providers, screens, widgets
    task_manager/
      data/         # Models, repository
      presentation/ # Providers, screens, widgets
  main.dart
  main_screen.dart
```

## Performance Optimizations
- `ListView.builder` with `cacheExtent` for smooth scrolling
- `Isolate.run()` moves JSON parsing off the main thread
- `RepaintBoundary` isolates chart repaints from scroll events
- `shouldRepaint` override prevents redundant canvas draws
- `CancelToken` cancels pending API calls during refresh
- `const` constructors and `ValueKey` for efficient widget reuse

## How to Run
```bash
flutter pub get
flutter run
```
