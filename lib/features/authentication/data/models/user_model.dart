import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smd_project/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.displayName,
    required super.email,
    super.photoURL,
    required super.createdAt,
    required super.lastActive,
    required super.groups,
    required super.tasksAssigned,
    required super.deviceTokens,
  });

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      'groups': groups,
      'tasksAssigned': tasksAssigned,
      'deviceTokens': deviceTokens,
    };
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      photoURL: map['photoURL'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastActive: (map['lastActive'] as Timestamp).toDate(),
      groups: List<String>.from(map['groups'] ?? []),
      tasksAssigned: List<String>.from(map['tasksAssigned'] ?? []),
      deviceTokens: List<String>.from(map['deviceTokens'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'groups': groups,
      'tasksAssigned': tasksAssigned,
      'deviceTokens': deviceTokens,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      photoURL: json['photoURL'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActive: DateTime.parse(json['lastActive'] as String),
      groups: List<String>.from(json['groups'] as List),
      tasksAssigned: List<String>.from(json['tasksAssigned'] as List),
      deviceTokens: List<String>.from(json['deviceTokens'] as List),
    );
  }

  UserModel copyWith({
    String? displayName,
    String? email,
    String? photoURL,
    DateTime? createdAt,
    DateTime? lastActive,
    List<String>? groups,
    List<String>? tasksAssigned,
    List<String>? deviceTokens,
  }) {
    return UserModel(
      id: id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      groups: groups ?? this.groups,
      tasksAssigned: tasksAssigned ?? this.tasksAssigned,
      deviceTokens: deviceTokens ?? this.deviceTokens,
    );
  }
}
