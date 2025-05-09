import 'package:equatable/equatable.dart';
import 'package:smd_project/features/messages/domain/entities/message_entity.dart';

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

class SendMessage extends MessagesEvent {
  final String groupId;
  final MessageEntity message;

  const SendMessage(this.groupId, this.message);

  @override
  List<Object> get props => [groupId, message];
}
