import 'package:go_router/go_router.dart';
import 'package:my_planner_pro/domain/models/task.dart';
import 'package:my_planner_pro/presentation/screens/home/home_screen.dart';
import 'package:my_planner_pro/presentation/screens/task_details/task_details_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) {
        // Pass the task object if it exists (for editing)
        final task = state.extra as Task?;
        return TaskDetailsScreen(task: task);
      },
    ),
  ],
);
