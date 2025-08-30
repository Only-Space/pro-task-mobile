
import 'package:hive/hive.dart';

part 'task_model.g.dart'; // File ini akan digenerate otomatis

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  DateTime? deadline;

  @HiveField(3)
  int priority; // 0: Rendah, 1: Sedang, 2: Tinggi

  Task({
    required this.name,
    this.isCompleted = false,
    this.deadline,
    this.priority = 0,
  });
} 