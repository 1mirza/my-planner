import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? dueDate; // <-- باید '?' داشته باشد

  const Task({
    this.id = 0,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.dueDate, // <-- اینجا هم چون اختیاری است، null-able است
  });

  @override
  List<Object?> get props => [id, title, description, isCompleted, dueDate];

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate, // <-- پارامتر ورودی هم باید '?' داشته باشد
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
