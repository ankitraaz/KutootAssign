import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/task_model.dart';
import '../data/task_repository.dart';
import '../../../core/network/connectivity_service.dart';

/// Uses modern Riverpod Notifier (Riverpod 3.x).
/// Manages tasks with optimistic UI updates and auto-sync on connectivity restore.
class TaskNotifier extends Notifier<List<TaskModel>> {
  late TaskRepository _repository;
  late bool _isOnline;

  @override
  List<TaskModel> build() {
    _repository = ref.watch(taskRepositoryProvider);
    _isOnline = ref.watch(isOnlineProvider);

    // Listen for connectivity changes and auto-sync when back online
    ref.listen<bool>(isOnlineProvider, (previous, next) {
      if (next) {
        syncPendingTasks();
      }
    });

    // Load from local Hive on init
    final tasks = _repository.getTasks();

    // If online at start, sync pending tasks
    if (_isOnline) {
      Future.microtask(() => syncPendingTasks());
    }

    return tasks;
  }

  Future<void> addTask(String title) async {
    // Optimistic: add to UI immediately
    final task = await _repository.addTask(title);
    state = [...state, task];

    if (_isOnline) {
      await _syncTask(task);
    }
  }

  Future<void> toggleTask(TaskModel task) async {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      syncStatus: 'pending',
    );
    await _repository.updateTask(updatedTask);

    // Optimistic update
    state = state.map((t) => t.id == task.id ? updatedTask : t).toList();

    if (_isOnline) {
      await _syncTask(updatedTask);
    }
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    state = state.where((t) => t.id != id).toList();
  }

  Future<void> _syncTask(TaskModel task) async {
    final success = await _repository.syncTask(task);
    if (success) {
      // Reload from Hive to reflect synced status
      state = _repository.getTasks();
    }
  }

  Future<void> syncPendingTasks() async {
    final pendingTasks = state.where((t) => t.syncStatus == 'pending').toList();
    for (final task in pendingTasks) {
      await _syncTask(task);
    }
  }
}

final taskProvider = NotifierProvider<TaskNotifier, List<TaskModel>>(
  TaskNotifier.new,
);
