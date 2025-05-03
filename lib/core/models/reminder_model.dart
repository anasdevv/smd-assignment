import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String createdBy;
  final DateTime reminderTime;
  final bool notifyAll;
  final List<String> notifyUsers;
  final String? relatedTaskId;

  const ReminderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    required this.reminderTime,
    required this.notifyAll,
    required this.notifyUsers,
    this.relatedTaskId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'reminderTime': Timestamp.fromDate(reminderTime),
      'notifyAll': notifyAll,
      'notifyUsers': notifyUsers,
      'relatedTaskId': relatedTaskId,
    };
  }

  factory ReminderModel.fromMap(String id, Map<String, dynamic> map) {
    return ReminderModel(
      id: id,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] as String,
      reminderTime: (map['reminderTime'] as Timestamp).toDate(),
      notifyAll: map['notifyAll'] as bool,
      notifyUsers: List<String>.from(map['notifyUsers'] ?? []),
      relatedTaskId: map['relatedTaskId'] as String?,
    );
  }

  ReminderModel copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    String? createdBy,
    DateTime? reminderTime,
    bool? notifyAll,
    List<String>? notifyUsers,
    String? relatedTaskId,
  }) {
    return ReminderModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      reminderTime: reminderTime ?? this.reminderTime,
      notifyAll: notifyAll ?? this.notifyAll,
      notifyUsers: notifyUsers ?? this.notifyUsers,
      relatedTaskId: relatedTaskId ?? this.relatedTaskId,
    );
  }
}
