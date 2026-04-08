import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/task_manager/data/task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiveProvider = Provider<Box<TaskModel>>((ref) {
  throw UnimplementedError('hive not initialized');
});

class HiveSetup {
  static Future<Box<TaskModel>> init() async {
    // Use path_provider directly instead of Hive.initFlutter()
    // to avoid PathUtils JNI crash in release mode on some devices
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(TaskModelAdapter());
    return await Hive.openBox<TaskModel>('tasks_box');
  }
}
