import 'package:isar/isar.dart';
import 'package:my_planner_pro/data/models/task_model.dart';

// This is the contract for our local data source.
// It defines what operations can be performed.
abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<void> addTask(TaskModel task);
  Future<void> deleteTask(int id);
  Future<void> updateTask(TaskModel task);
}

// This is the concrete implementation of the data source using Isar.
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Isar isar;

  TaskLocalDataSourceImpl({required this.isar});

  @override
  Future<List<TaskModel>> getAllTasks() async {
    // Finds all TaskModel objects stored in the Isar database.
    return await isar.taskModels.where().findAll();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    // Executes a transaction to write the new task to the database.
    await isar.writeTxn(() async {
      await isar.taskModels.put(task);
    });
  }

  @override
  Future<void> deleteTask(int id) async {
    // Executes a transaction to delete the task with the given id.
    await isar.writeTxn(() async {
      await isar.taskModels.delete(id);
    });
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    // Isar's `put` method handles both creation and updating.
    // If a task with the same ID exists, it will be updated.
    await isar.writeTxn(() async {
      await isar.taskModels.put(task);
    });
  }
}
