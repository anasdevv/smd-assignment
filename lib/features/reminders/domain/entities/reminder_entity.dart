import 'package:equatable/equatable.dart';

class ReminderEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String createdBy;
  final DateTime reminderTime;
  final bool notifyAll;
  final List<String> notifyUsers;
  final String? relatedTaskId;

  const ReminderEntity({
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

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        createdAt,
        createdBy,
        reminderTime,
        notifyAll,
        notifyUsers,
        relatedTaskId,
      ];
}
