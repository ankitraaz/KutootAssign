import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/hive_setup.dart';
import '../../../core/network/dio_client.dart';
import 'task_model.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(
    ref.watch(hiveProvider),
    ref.watch(dioProvider),
  );
});

class TaskRepository {
  final Box<TaskModel> _taskBox;
  final Dio _dio;

  TaskRepository(this._taskBox, this._dio);

  List<TaskModel> getTasks() {
    return _taskBox.values.toList();
  }

  Future<TaskModel> addTask(String title) async {
    final task = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      syncStatus: 'pending',
    );
    await _taskBox.put(task.id, task);
    return task;
  }

  Future<void> updateTask(TaskModel task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  Future<bool> syncTask(TaskModel task) async {
    try {
      final response = await _dio.post('/sync_cyber_ticket', data: {
        'id': task.id,
        'title': task.title,
        'isCompleted': task.isCompleted,
      });

      if (response.statusCode == 200) {
        final syncedTask = task.copyWith(syncStatus: 'synced');
        await updateTask(syncedTask);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
