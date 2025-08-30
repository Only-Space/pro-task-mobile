import 'package:hive/hive.dart';
import 'task_model.dart';

part 'todo_list_model.g.dart'; // File ini akan digenerate otomatis

@HiveType(typeId: 0)
class TodoList extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  HiveList<Task> tasks;

  TodoList({
    required this.title,
    required this.tasks,
  });
}