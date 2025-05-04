import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String createdBy;
  final DateTime dueDate;
  final String priority;
  final String status;
  final List<String> assignedTo;
  final List<String> attachments;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.assignedTo,
    required this.attachments,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        createdAt,
        createdBy,
        dueDate,
        priority,
        status,
        assignedTo,
        attachments,
      ];
}
