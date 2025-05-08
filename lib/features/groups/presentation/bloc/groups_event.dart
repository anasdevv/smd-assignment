import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class GetUserGroups extends GroupEvent {
  final String userId;

  const GetUserGroups(this.userId);

  @override
  List<Object> get props => [userId];
}

class CheckAuthStatus extends GroupEvent {}
