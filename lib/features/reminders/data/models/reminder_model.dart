import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smd_project/features/reminders/domain/entities/reminder_entity.dart';

class ReminderModel extends ReminderEntity {
  const ReminderModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.createdBy,
    required super.reminderTime,
    required super.notifyAll,
    required super.notifyUsers,
    super.relatedTaskId,
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
