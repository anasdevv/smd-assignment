import 'package:equatable/equatable.dart';
import 'package:smd_project/features/groups/domain/entities/group_entity.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<GroupEntity> groups;

  const GroupLoaded(this.groups);

  @override
  List<Object> get props => [groups];
}

class GroupError extends GroupState {
  final String message;

  const GroupError(this.message);

  @override
  List<Object> get props => [message];
}


class GroupCreating extends GroupState {}


class GroupCreated extends GroupState {}

class GroupCreationError extends GroupState {
  final String message;

  const GroupCreationError(this.message);

  @override
  List<Object> get props => [message];
}

class GroupUpdated extends GroupState {}

class GroupDeleted extends GroupState {}
