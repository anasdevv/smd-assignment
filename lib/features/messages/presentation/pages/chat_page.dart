import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_event.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_state.dart';
import 'package:smd_project/features/messages/data/models/message_model.dart';
import 'package:smd_project/features/messages/presentation/bloc/messages_bloc.dart';
import 'package:smd_project/features/messages/presentation/bloc/messages_event.dart';
import 'package:smd_project/features/messages/presentation/bloc/messages_state.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String userId;
  late String userName;
  final TextEditingController _messageTextController = TextEditingController();
  final String groupId = "test"; // replace with dynamic group ID if needed

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      userId = authState.user.id;
      userName = authState.user.displayName;
      context.read<MessagesBloc>().add(GetGroupMessages(groupId));
    } else {
      context.read<AuthBloc>().add(FetchUser());
    }
  }

  void _sendMessage(String text) {
    final uuid = Uuid();
    final message = MessageModel(
      id: uuid.v4(),
      text: text,
      senderId: userId,
      senderName: userName,
      timestamp: DateTime.now(),
      readBy: [],
    );
    context.read<MessagesBloc>().add(SendMessage(groupId, message));
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    userId = state.user.id;
                    userName = state.user.displayName;
                    context.read<MessagesBloc>().add(GetGroupMessages(groupId));
                  }
                },
                child: BlocConsumer<MessagesBloc, MessagesState>(
                  listener: (context, state) {
                    if (state is MessagesError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${state.message}")),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is MessagesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MessagesLoaded) {
                      final messages = state.messages;
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[messages.length - 1 - index];
                          final isMe = message.senderId == userId;

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color:
                                    isMe ? Colors.blue[100] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(message.text),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM d, h:mm a')
                                        .format(message.timestamp),
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is MessagesError) {
                      return Center(child: Text("Error: ${state.message}"));
                    } else {
                      return const Center(child: Text("No messages."));
                    }
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageTextController,
                    decoration:
                        const InputDecoration(hintText: "Type a message..."),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _messageTextController.text.trim();
                    if (text.isNotEmpty) {
                      _sendMessage(text);
                      _messageTextController.clear();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
