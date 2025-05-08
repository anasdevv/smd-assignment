import 'package:equatable/equatable.dart';
import 'package:smd_project/features/messages/domain/entities/message_entity.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object?> get props => [];
}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final List<MessageEntity> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageError extends MessagesState {
  final String message;

  const MessageError(this.message);

  @override
  List<Object> get props => [message];
}

class MessageCreated extends MessagesState {}

class MessageUpdated extends MessagesState {}

class MessageDeleted extends MessagesState {}
