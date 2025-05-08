import 'package:equatable/equatable.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object?> get props => [];
}

class GetGroupMessages extends MessagesEvent {
  final String groupId;

  const GetGroupMessages(this.groupId);

  @override
  List<Object> get props => [groupId];
}
