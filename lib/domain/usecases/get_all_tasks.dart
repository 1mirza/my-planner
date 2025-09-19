import 'package:my_planner_pro/core/usecase/usecase.dart';
import 'package:my_planner_pro/domain/models/task.dart';
import 'package:my_planner_pro/domain/repositories/task_repository.dart';

// چون این UseCase پارامتر ورودی ندارد، از void استفاده می‌کنیم
class GetAllTasks implements UseCase<List<Task>, void> {
  final TaskRepository repository;

  GetAllTasks(this.repository);

  @override
  Future<List<Task>> call(void params) async {
    return await repository.getAllTasks();
  }
}
