import 'package:my_planner_pro/core/usecase/usecase.dart';
import 'package:my_planner_pro/domain/repositories/task_repository.dart';

// پارامتر ورودی این UseCase شناسه وظیفه (یک عدد) است
class DeleteTask implements UseCase<void, int> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<void> call(int params) async {
    return await repository.deleteTask(params);
  }
}
