import 'package:equatable/equatable.dart';

class AnnouncementEntity extends Equatable {
  final String id;
  final String groupId;
  final String title;
  final String content;
  final String createdById;
  final String createdBy;
  final DateTime createdAt;
  final List<String> attachments;
  final String? creatorPhotoURL;

  const AnnouncementEntity({
    required this.id,
    required this.groupId,
    required this.title,
    required this.content,
    required this.createdBy,
    required this.createdAt,
    required this.createdById,
    this.attachments = const [],
    this.creatorPhotoURL,
  });

  @override
  List<Object?> get props => [
        id,
        groupId,
        title,
        content,
        createdBy,
        createdAt,
        attachments,
        createdById,
        creatorPhotoURL
      ];
}
