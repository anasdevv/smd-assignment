import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/messages/domain/entities/message_entity.dart';
import 'package:smd_project/features/messages/domain/repositories/message_repository.dart';
import 'package:smd_project/features/messages/presentation/bloc/messages_event.dart';
import 'package:smd_project/features/messages/presentation/bloc/messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final MessageRepository messagesRepository;

  MessagesBloc({required this.messagesRepository}) : super(MessagesInitial()) {
    on<GetGroupMessages>(_onGetGroupMessages);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onGetGroupMessages(
    GetGroupMessages event,
    Emitter<MessagesState> emit,
  ) async {
    emit(MessagesLoading());

    await emit.forEach<List<MessageEntity>>(
      messagesRepository
          .getGroupMessages(event.groupId), // Stream<List<MessageEntity>>
      onData: (messages) => MessagesLoaded(messages),
      onError: (error, _) => MessagesError(error.toString()),
    );
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<MessagesState> emit,
  ) async {
    try {
      await messagesRepository.sendMessage(event.groupId, event.message);
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }
}
