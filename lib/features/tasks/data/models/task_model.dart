import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smd_project/features/tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.createdBy,
    required super.dueDate,
    required super.priority,
    required super.status,
    required super.assignedTo,
    required super.attachments,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority,
      'status': status,
      'assignedTo': assignedTo,
      'attachments': attachments,
    };
  }

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] as String,
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      priority: map['priority'] as String,
      status: map['status'] as String,
      assignedTo: List<String>.from(map['assignedTo'] ?? []),
      attachments: List<String>.from(map['attachments'] ?? []),
    );
  }

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    String? createdBy,
    DateTime? dueDate,
    String? priority,
    String? status,
    List<String>? assignedTo,
    List<String>? attachments,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      attachments: attachments ?? this.attachments,
    );
  }
}
