import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_planner_pro/presentation/providers/task_provider.dart';
import 'package:my_planner_pro/presentation/widgets/home/task_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('برنامه روزانه من'),
        centerTitle: true,
      ),
      body: tasksAsyncValue.when(
        data: (tasks) => TaskList(tasks: tasks),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('خطایی رخ داد: $error\n$stack'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // تغییر منطق: به جای دیالوگ، به صفحه جزئیات می‌رویم
        onPressed: () => context.push('/details'),
        tooltip: 'افزودن وظیفه جدید',
        child: const Icon(Icons.add),
      ),
    );
  }
}
