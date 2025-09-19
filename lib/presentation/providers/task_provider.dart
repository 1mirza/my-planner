import 'package:isar/isar.dart';
import 'package:my_planner_pro/data/datasources/task_local_datasource.dart';
import 'package:my_planner_pro/data/repositories/task_repository_impl.dart';
import 'package:my_planner_pro/domain/models/task.dart';
import 'package:my_planner_pro/domain/repositories/task_repository.dart';
import 'package:my_planner_pro/domain/usecases/add_task.dart';
import 'package:my_planner_pro/domain/usecases/delete_task.dart';
import 'package:my_planner_pro/domain/usecases/get_all_tasks.dart';
import 'package:my_planner_pro/domain/usecases/update_task.dart';
import 'package:riverpod/riverpod.dart';

// ------------------- Data Layer Providers -------------------

// Provider for Isar instance
final isarProvider = Provider<Isar>((_) => throw UnimplementedError());

// Provider for TaskLocalDataSource
final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  return TaskLocalDataSourceImpl(isar: ref.watch(isarProvider));
});

// Provider for TaskRepository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
      localDataSource: ref.watch(taskLocalDataSourceProvider));
});

// ------------------- Domain Layer (Use Cases) Providers -------------------

final getAllTasksUseCaseProvider = Provider<GetAllTasks>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return GetAllTasks(repository);
});

final addTaskUseCaseProvider = Provider<AddTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return AddTask(repository);
});

final deleteTaskUseCaseProvider = Provider<DeleteTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return DeleteTask(repository);
});

final updateTaskUseCaseProvider = Provider<UpdateTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return UpdateTask(repository);
});

// ------------------- Presentation Layer (State Notifier) -------------------

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, AsyncValue<List<Task>>>((ref) {
  return TaskListNotifier(ref);
});

class TaskListNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final Ref _ref;

  TaskListNotifier(this._ref) : super(const AsyncLoading()) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _ref.read(getAllTasksUseCaseProvider).call(null);
      state = AsyncData(tasks);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // FIXED: Added optional named parameter dueDate
  Future<void> addTask(String title, String description,
      {DateTime? dueDate}) async {
    try {
      final newTask = Task(
        id: 0,
        title: title,
        description: description,
        isCompleted: false,
        dueDate: dueDate, // Pass the date to the model
      );
      await _ref.read(addTaskUseCaseProvider).call(newTask);
      await _loadTasks();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _ref.read(deleteTaskUseCaseProvider).call(id);
      await _loadTasks();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _ref.read(updateTaskUseCaseProvider).call(task);
      await _loadTasks();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> toggleCompletion(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _ref.read(updateTaskUseCaseProvider).call(updatedTask);
      await _loadTasks();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
