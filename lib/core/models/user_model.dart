import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastActive;
  final List<String> groups;
  final List<String> tasksAssigned;
  final List<String> deviceTokens;

  const UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoURL,
    required this.createdAt,
    required this.lastActive,
    required this.groups,
    required this.tasksAssigned,
    required this.deviceTokens,
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
