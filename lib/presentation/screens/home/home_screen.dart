import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            child: Text('خطایی رخ داد: $error'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, ref),
        tooltip: 'افزودن وظیفه جدید',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('وظیفه جدید'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان',
                    hintText: 'مثلا: خرید شیر',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'عنوان نمی‌تواند خالی باشد';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'توضیحات (اختیاری)',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('لغو'),
            ),
            FilledButton(
              onPressed: () {
                // Here we check if the form is valid
                if (formKey.currentState!.validate()) {
                  // CORRECT USAGE: We pass two separate strings to the addTask method.
                  ref.read(taskListProvider.notifier).addTask(
                        titleController.text,
                        descriptionController.text,
                      );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('افزودن'),
            ),
          ],
        );
      },
    );
  }
}
