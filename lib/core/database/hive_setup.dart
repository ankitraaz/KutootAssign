import 'package:hive_flutter/hive_flutter.dart';
import '../../features/task_manager/data/task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiveProvider = Provider<Box<TaskModel>>((ref) {
  throw UnimplementedError('hive not initialized');
});

class HiveSetup {
  static Future<Box<TaskModel>> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    return await Hive.openBox<TaskModel>('tasks_box');
  }
}
