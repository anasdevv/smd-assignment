import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/tasks/domain/entities/task_entity.dart';
import 'package:smd_project/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:smd_project/features/tasks/presentation/bloc/tasks_event.dart';
import 'package:smd_project/features/tasks/presentation/bloc/tasks_state.dart';
import 'package:uuid/uuid.dart';

class AssignTaskPage extends StatefulWidget {
  final String groupId;
  final List<String> groupMembers;

  const AssignTaskPage({
    required this.groupId,
    required this.groupMembers,
    super.key,
  });

  @override
  State<AssignTaskPage> createState() => _AssignTaskPageState();
}

class _AssignTaskPageState extends State<AssignTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  String _priority = 'Medium';
  List<String> _selectedMembers = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _submitTask() {
    if (_formKey.currentState!.validate() && _selectedMembers.isNotEmpty) {
      final task = TaskEntity(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
        createdBy: 'current_user_id', // TODO: Get from auth
        dueDate: _dueDate,
        priority: _priority,
        status: 'pending',
        assignedTo: _selectedMembers,
        attachments: [],
      );

      context.read<TaskBloc>().add(CreateTask(widget.groupId, task));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign New Task'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(_dueDate.toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: ['Low', 'Medium', 'High']
                  .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _priority = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Assign to Members:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widget.groupMembers.map((memberId) {
              return CheckboxListTile(
                title: Text(memberId), // TODO: Replace with actual user name
                value: _selectedMembers.contains(memberId),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedMembers.add(memberId);
                    } else {
                      _selectedMembers.remove(memberId);
                    }
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitTask,
              child: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
} 