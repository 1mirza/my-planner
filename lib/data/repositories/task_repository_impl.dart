import 'package:my_planner_pro/data/datasources/task_local_datasource.dart';
import 'package:my_planner_pro/data/models/task_model.dart';
import 'package:my_planner_pro/domain/models/task.dart';
import 'package:my_planner_pro/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await localDataSource.addTask(taskModel);
  }

  @override
  Future<void> deleteTask(int id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<List<Task>> getAllTasks() async {
    final taskModels = await localDataSource.getAllTasks();
    // Sort tasks by creation date (ID in this case) descending, so newest are first.
    return taskModels.map((model) => model.toEntity()).toList()
      ..sort((a, b) => b.id.compareTo(a.id));
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await localDataSource.updateTask(taskModel);
  }
}
