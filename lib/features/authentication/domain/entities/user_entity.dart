import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String displayName;
  final String email;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastActive;
  final List<String> groups;
  final List<String> tasksAssigned;
  final List<String> deviceTokens;

  const UserEntity({
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

  @override
  List<Object?> get props => [
        id,
        displayName,
        email,
        photoURL,
        createdAt,
        lastActive,
        groups,
        tasksAssigned,
        deviceTokens,
      ];
}
