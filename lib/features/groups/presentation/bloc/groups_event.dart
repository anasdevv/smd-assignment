import 'package:equatable/equatable.dart';
import 'package:smd_project/features/groups/domain/entities/group_entity.dart';

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

class CreateGroupEvent extends GroupEvent {
  final GroupEntity group;

  const CreateGroupEvent(this.group);

  @override
  List<Object> get props => [group];
}


class CheckAuthStatus extends GroupEvent {}
