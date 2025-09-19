import 'package:my_planner_pro/core/usecase/usecase.dart';
import 'package:my_planner_pro/domain/models/task.dart';
import 'package:my_planner_pro/domain/repositories/task_repository.dart';

// پارامتر ورودی این UseCase یک شیء Task است
class AddTask implements UseCase<void, Task> {
  final TaskRepository repository;

  AddTask(this.repository);

  @override
  Future<void> call(Task params) async {
    return await repository.addTask(params);
  }
}
