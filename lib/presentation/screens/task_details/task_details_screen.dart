import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_planner_pro/domain/models/task.dart';
import 'package:my_planner_pro/presentation/providers/task_provider.dart';

class TaskDetailsScreen extends ConsumerStatefulWidget {
  // Task can be null if we are creating a new one
  final Task? task;

  const TaskDetailsScreen({super.key, this.task});

  @override
  ConsumerState<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  DateTime? _selectedDate;
  late bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.task != null;
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _selectedDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskNotifier = ref.read(taskListProvider.notifier);
      if (_isEditMode) {
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _selectedDate,
        );
        taskNotifier.updateTask(updatedTask);
      } else {
        taskNotifier.addTask(
          _titleController.text,
          _descriptionController.text,
          dueDate: _selectedDate,
        );
      }
      context.pop(); // Go back to home screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'ویرایش وظیفه' : 'وظیفه جدید'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTask,
            tooltip: 'ذخیره',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان',
                  border: OutlineInputBorder(),
                  hintText: 'مثلا: تماس با شرکت',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'عنوان نمی‌تواند خالی باشد.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'توضیحات (اختیاری)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              const Text('تاریخ سررسید (اختیاری)',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'تاریخی انتخاب نشده'
                          : DateFormat.yMMMMd('fa').format(_selectedDate!),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                    tooltip: 'انتخاب تاریخ',
                  ),
                  if (_selectedDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.red),
                      onPressed: () => setState(() => _selectedDate = null),
                      tooltip: 'حذف تاریخ',
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
