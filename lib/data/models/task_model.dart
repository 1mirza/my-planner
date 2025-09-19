import 'package:isar/isar.dart';
import 'package:my_planner_pro/domain/models/task.dart';

part 'task_model.g.dart';

@Collection()
class TaskModel {
  Id id = Isar.autoIncrement;

  late String title;
  late String description;
  late bool isCompleted;
  DateTime? dueDate;

  // This unnamed constructor is required by the Isar generator.
  TaskModel();

  // Converts a domain model (Task) to a data model (TaskModel) for saving to DB
  factory TaskModel.fromEntity(Task entity) {
    return TaskModel()
      ..id = entity.id
      ..title = entity.title
      ..description = entity.description
      ..isCompleted = entity.isCompleted
      ..dueDate = entity.dueDate;
  }

  // Converts a data model (TaskModel) to a domain model (Task) for use in the app
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      dueDate: dueDate,
    );
  }
}
