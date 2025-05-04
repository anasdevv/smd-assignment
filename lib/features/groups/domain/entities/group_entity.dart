import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  final String id;
  final String name;
  final String subject;
  final String description;
  final DateTime createdAt;
  final String createdBy;
  final String leaderId;
  final List<String> members;
  final bool isPublic;
  final List<String> tags;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.subject,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    required this.leaderId,
    required this.members,
    required this.isPublic,
    required this.tags,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        subject,
        description,
        createdAt,
        createdBy,
        leaderId,
        members,
        isPublic,
        tags,
      ];
}
