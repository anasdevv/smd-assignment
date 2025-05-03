import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
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

  const GroupModel({
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
    };
  }

  factory GroupModel.fromMap(String id, Map<String, dynamic> map) {
    return GroupModel(
      id: id,
      name: map['name'] as String,
      subject: map['subject'] as String,
      description: map['description'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] as String,
      leaderId: map['leaderId'] as String,
      members: List<String>.from(map['members'] ?? []),
      isPublic: map['isPublic'] as bool,
      tags: List<String>.from(map['tags'] ?? []),
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
    );
  }
}
