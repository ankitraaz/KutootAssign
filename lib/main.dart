import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/hive_setup.dart';
import 'core/theme/app_theme.dart';
import 'main_screen.dart';

/// Simple notifier to toggle the Flutter performance overlay at runtime.
class PerformanceOverlayNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final showPerformanceOverlayProvider =
    NotifierProvider<PerformanceOverlayNotifier, bool>(
  PerformanceOverlayNotifier.new,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local database before runApp
  final taskBox = await HiveSetup.init();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the opened Hive box into Riverpod
        hiveProvider.overrideWithValue(taskBox),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showOverlay = ref.watch(showPerformanceOverlayProvider);

    return MaterialApp(
      title: 'High Performance App',
      theme: AppTheme.theme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
      // Flutter's built-in performance overlay (rasterizer + UI thread timing)
      showPerformanceOverlay: showOverlay,
    );
  }
}
