import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smd_project/features/groups/domain/entities/announcement_entity.dart';

class AnnouncementModel extends AnnouncementEntity {
  const AnnouncementModel({
    required super.id,
    required super.groupId,
    required super.title,
    required super.content,
    required super.createdBy,
    required super.createdAt,
    required super.createdById,
    super.attachments = const [],
    super.creatorPhotoURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'title': title,
      'content': content,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'attachments': attachments,
      'creatorPhotoURL': creatorPhotoURL,
    };
  }

  factory AnnouncementModel.fromMap(String id, Map<String, dynamic> map) {
    print('Map ${map}');
    return AnnouncementModel(
        id: id,
        groupId: map['groupId'] as String,
        title: map['title'] as String,
        content: map['content'] as String,
        createdBy: map['createdBy'] as String,
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        attachments: List<String>.from(map['attachments'] ?? []),
        createdById: map['createdById'] ?? '',
        creatorPhotoURL: map['creatorPhotoURL'] ?? '');
  }

  AnnouncementModel copyWith({
    String? title,
    String? content,
    List<String>? attachments,
  }) {
    return AnnouncementModel(
        id: id,
        groupId: groupId,
        title: title ?? this.title,
        content: content ?? this.content,
        createdBy: createdBy,
        createdAt: createdAt,
        attachments: attachments ?? this.attachments,
        createdById: createdById);
  }
}
