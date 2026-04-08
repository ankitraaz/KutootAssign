# Kutoot Innovations - Flutter Developer Assignment 🚀

A production-ready, high-performance Flutter application built as a submission for the Flutter Developer role at Kutoot Innovations Private Limited. The project demonstrates advanced architecture, performance optimization techniques (60-120 FPS), and robust offline-first synchronization capabilities.

---

## 🎯 Task 1: The "Performance Architect" - Infinite Canvas
A high-performance infinite scrolling feed fetching data from a mock API with heavy items (high-res images & custom painted charts).

**Key Skills Demonstrated:**
- **Custom Painting:** Used `CustomPainter` to draw complex charts natively on the canvas (`_ChartPainter`), preventing the overhead of deep widget nesting.
- **Isolates:** Implemented `Isolate.run()` to offload the heavy JSON parsing and mapping from the main thread, ensuring the UI remains jank-free.
- **RepaintBoundaries:** Wrapped static and complex chart components inside `<RepaintBoundary>` to prevent the Flutter engine from repainting them when adjacent animations or scroll events trigger.
- **Smart Network Handling:** Integrated `CancelToken` from Dio to abort stale image/data requests when the user scrolls rapidly. Memory-efficient image buffering using `cached_network_image`.

## 📸 Screenshots
<p align="left">
  <img src="screenshots/feed.png" width="200" alt="Feed Screen">
  <img src="screenshots/tasks_online.png" width="200" alt="Online Task Manager">
  <img src="screenshots/tasks_offline.png" width="200" alt="Offline Offline Manager">
  <img src="screenshots/swipe_delete.png" width="200" alt="Swipe to delete task">
</p>

---

## 🔄 Task 2: State Management & Sync - Collaborative Task List
An offline-first collaborative "Task Manager" where users can add and edit items seamlessly regardless of their network connection.

**Key Skills Demonstrated:**
- **Riverpod 3.x State Management:** Utilized modern `Notifier` and `AsyncNotifier` patterns for predictable state handling and robust management of side-effects.
- **Offline-First via Hive:** Used Hive for local persistence. Newly created tasks are immediately saved locally and displayed in the UI.
- **Interactive UX:** Use the bottom-right **`+` Action Button** to quickly add a new task. To delete any task, simply **Slide/Swipe Left** on the task card to see the red delete action!
- **Optimistic UI Updates:** UI updates instantly when the user performs an action (e.g. clicking "Add" or swiping to delete), instantly displaying a "Pending" label for new items.
- **Connectivity Monitoring:** Integrated `connectivity_plus` exposed as a Riverpod `StreamProvider` to reactively monitor network state.
- **Automatic Background Sync:** Once the internet connection is restored, the app automatically syncs local pending tasks with the backend, seamlessly updating the UI status to "Synced".

---

## 🛠 Tech Stack
- **Framework:** Flutter (Latest Stable)
- **State Management:** Riverpod (flutter_riverpod)
- **Local Database:** Hive / Hive Flutter
- **Networking:** Dio (with Custom Mock Interceptor)
- **Connectivity:** connectivity_plus
- **Assets Loading:** cached_network_image

---

## 📂 Architecture Overview
Following a Feature-First Clean Architecture pattern to ensure high scalability:
```
lib/
  core/
    database/       # Hive local DB configuration
    network/        # Dio client, mock interceptors, connectivity service
    theme/          # M3 compliant App theme
  features/
    infinite_feed/
      data/         # Models, network providers
      presentation/ # Providers, screens, widgets (FeedCard, CustomPainter)
    task_manager/
      data/         # Task Models, Hive adapters
      presentation/ # Notifier providers, task screens, optimistic UI widgets
  main.dart         # Entry point, Hive init & Splash termination
  main_screen.dart  # Bottom Navigation Routing
```

---

## 🏃‍♂️ How to Run Locally

1. Clone the repository
```bash
git clone https://github.com/ankitraaz/KutootAssign.git
cd KutootAssign
```

2. Fetch Dependencies
```bash
flutter pub get
```

3. Run the App
```bash
# Debug Mode
flutter run

# Profile Mode (To analyze actual frame times without JIT overhead)
flutter run --profile
```

---
*Developed by Ankit Raaz*
