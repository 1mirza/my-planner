import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_planner_pro/domain/models/task.dart';
import 'package:my_planner_pro/presentation/providers/task_provider.dart';
import 'package:my_planner_pro/presentation/widgets/shared/confirmation_dialog.dart';
import 'package:shamsi_date/shamsi_date.dart'; // <-- ایمپورت پکیج تاریخ شمسی

class TaskListItem extends ConsumerWidget {
  final Task task;
  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: InkWell(
        onTap: () {
          // Navigate to details screen for editing
          context.push('/details', extra: task);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (_) {
                  ref.read(taskListProvider.notifier).toggleCompletion(task);
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: textTheme.titleMedium?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            // <-- تبدیل و فرمت تاریخ به شمسی
                            _formatShamsiDate(task.dueDate!),
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () async {
                  final confirmed = await showConfirmationDialog(
                    context,
                    title: 'تایید حذف',
                    content:
                        'آیا از حذف این وظیفه اطمینان دارید؟ این عمل قابل بازگشت نیست.',
                  );

                  // Check if the widget is still mounted before using the ref.
                  if (confirmed == true && context.mounted) {
                    ref.read(taskListProvider.notifier).deleteTask(task.id);
                  }
                },
                tooltip: 'حذف',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to format Jalali date
  String _formatShamsiDate(DateTime date) {
    final jalaliDate = Jalali.fromDateTime(date);
    final formatter = jalaliDate.formatter;
    return '${formatter.wN}، ${formatter.d} ${formatter.mN} ${formatter.yyyy}';
    // -> مثال خروجی: شنبه، ۲۰ اردیبهشت ۱۴۰۴
  }
}
