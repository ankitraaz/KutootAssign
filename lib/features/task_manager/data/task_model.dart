import 'package:hive/hive.dart';

class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final String syncStatus; // 'synced', 'pending'

  const TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.syncStatus = 'pending',
  });

  TaskModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? syncStatus,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    return TaskModel(
      id: reader.readString(),
      title: reader.readString(),
      isCompleted: reader.readBool(),
      syncStatus: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeBool(obj.isCompleted);
    writer.writeString(obj.syncStatus);
  }
}
