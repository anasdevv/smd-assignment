import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smd_project/features/groups/domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.id,
    required super.name,
    required super.subject,
    required super.description,
    required super.createdAt,
    required super.createdBy,
    required super.leaderId,
    required super.members,
    required super.isPublic,
    required super.tags,
    required super.isJoined,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subject': subject,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'leaderId': leaderId,
      'members': members,
      'isPublic': isPublic,
      'tags': tags,
      'isJoined': isJoined,
    };
  }

  factory GroupModel.fromMap(String id, Map<String, dynamic> map) {
    return GroupModel(
      id: id,
      name: map['name'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      description: map['description'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: map['createdBy'] as String? ?? '',
      leaderId: map['leaderId'] as String? ?? '',
      members: List<String>.from(map['members'] ?? []),
      isPublic: map['isPublic'] as bool? ?? false,
      tags: List<String>.from(map['tags'] ?? []),
      isJoined: map['isJoined'] as bool? ?? false,
    );
  }

  GroupModel copyWith({
    String? name,
    String? subject,
    String? description,
    DateTime? createdAt,
    String? createdBy,
    String? leaderId,
    List<String>? members,
    bool? isPublic,
    List<String>? tags,
    bool? isJoined,
  }) {
    return GroupModel(
      id: id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      leaderId: leaderId ?? this.leaderId,
      members: members ?? this.members,
      isPublic: isPublic ?? this.isPublic,
      tags: tags ?? this.tags,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}
