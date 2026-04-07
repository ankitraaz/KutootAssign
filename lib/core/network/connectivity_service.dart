import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityServiceProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivityState = ref.watch(connectivityServiceProvider);
  return connectivityState.when(
    data: (results) => results.any((result) => result != ConnectivityResult.none),
    loading: () => true, // Assume online until proven otherwise to avoid pessimistic UI
    error: (_, _) => false,
  );
});
