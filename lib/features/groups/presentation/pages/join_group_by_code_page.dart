import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_event.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_state.dart';
import 'package:go_router/go_router.dart';

class JoinGroupByIdPage extends StatefulWidget {
  final String userId;

  const JoinGroupByIdPage({
    required this.userId,
    super.key,
  });

  @override
  State<JoinGroupByIdPage> createState() => _JoinGroupByIdPageState();
}

class _JoinGroupByIdPageState extends State<JoinGroupByIdPage> {
  final _formKey = GlobalKey<FormState>();
  final _groupIdController = TextEditingController();

  @override
  void dispose() {
    _groupIdController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final groupId = _groupIdController.text.trim();
      context.read<GroupBloc>().add(
            JoinGroupEvent(
              groupId: groupId,
              userId: widget.userId,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Group by ID'),
      ),
      body: BlocListener<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupJoined) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Successfully joined the group!'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/home');
          } else if (state is GroupJoinError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Enter Group ID',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ask your group leader for the group ID to join their group',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _groupIdController,
                  decoration: const InputDecoration(
                    labelText: 'Group ID',
                    hintText: 'Enter the group ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.group),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a group ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<GroupBloc, GroupState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is GroupJoining ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state is GroupJoining
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Join Group',
                              style: TextStyle(fontSize: 16),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 