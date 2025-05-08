import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_event.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_state.dart';
import 'package:smd_project/features/messages/presentation/bloc/messages_bloc.dart';
import 'package:smd_project/features/messages/presentation/bloc/messages_event.dart';
import 'package:smd_project/features/messages/presentation/bloc/messages_state.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String userId;
  @override
  void initState() {
    super.initState();
    // Only fetch the user here
    context.read<AuthBloc>().add(FetchUser());
  }

  void _getGroupMessages() {
    context.read<MessagesBloc>().add(GetGroupMessages("test"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            userId = state.user.id; // Now we have the user ID
            _getGroupMessages(); // Fetch messages after user ID is available
          }
        },
        child: BlocBuilder<MessagesBloc, MessagesState>(
          builder: (context, state) {
            if (state is MessagesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MessagesLoaded) {
              final messages = state.messages;
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: message.senderId == userId
                          ? MainAxisAlignment
                              .end // Align the entire row to the right if it's the current user
                          : MainAxisAlignment
                              .start, // Align to the left for other users
                      children: [
                        Text(
                          message.text,
                          textAlign: message.senderId == userId
                              ? TextAlign.right
                              : TextAlign.left,
                        ),
                        SizedBox(
                            width: 8), // Space between message and timestamp
                        Text(
                          DateFormat('MMM d, h:mm a').format(message.timestamp),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is MessageError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const Center(child: Text("No messages."));
            }
          },
        ),
      ),
    );
  }
}
