import 'package:my_planner_pro/core/usecase/usecase.dart';
import 'package:my_planner_pro/domain/models/task.dart';
import 'package:my_planner_pro/domain/repositories/task_repository.dart';

class UpdateTask implements UseCase<void, Task> {
  final TaskRepository _repository;

  UpdateTask(this._repository);

  @override
  // FIXED: Changed from a named parameter {required Task params}
  // to a positional parameter to match the base UseCase class.
  Future<void> call(Task params) {
    return _repository.updateTask(params);
  }
}
