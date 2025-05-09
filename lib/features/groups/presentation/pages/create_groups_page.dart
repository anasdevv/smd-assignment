import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/groups/domain/entities/group_entity.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_event.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_state.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';
<<<<<<< Updated upstream
=======
import 'package:uuid/uuid.dart';
>>>>>>> Stashed changes

// import 'package:firebase_auth/firebase_auth.dart'; // Uncomment if using Firebase

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublic = true;

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final subject = _subjectController.text.trim();
      final description = _descriptionController.text.trim();

      final authState = context.read<AuthBloc>().state;

    if (authState is! Authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    final userId = authState.user.id;
      
        

      final group = GroupEntity(
        id: UniqueKey().toString(), // Or use UUID
        name: name,
        subject: subject,
        description: description,
        createdAt: DateTime.now(),
        createdBy: userId,
        leaderId: userId,
        members: [userId],
        isPublic: _isPublic,
        tags: [], // Optional: you can add tag input if needed
      );

      context.read<GroupBloc>().add(CreateGroupEvent(group));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<GroupBloc, GroupState>(
          listener: (context, state) {
            if (state is GroupCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Group created successfully')),
              );
              context.go('/home'); // Navigate to home or group list page
            } else if (state is GroupCreationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Group Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(labelText: 'Subject'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  value: _isPublic,
                  onChanged: (value) {
                    setState(() {
                      _isPublic = value;
                    });
                  },
                  title: const Text('Public Group'),
                ),
                const SizedBox(height: 20),
                BlocBuilder<GroupBloc, GroupState>(
                  builder: (context, state) {
                    if (state is GroupCreating) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Create Group'),
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
