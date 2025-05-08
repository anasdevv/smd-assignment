import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smd_project/features/groups/domain/entities/group_entity.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_event.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_state.dart';
import 'package:smd_project/features/tasks/domain/repositories/task_repository.dart';
import 'package:smd_project/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:smd_project/features/tasks/presentation/bloc/tasks_event.dart';
import 'package:smd_project/features/tasks/presentation/bloc/tasks_state.dart';
import 'package:smd_project/features/tasks/presentation/pages/assign_task_page.dart';

class GroupDetailPage extends StatelessWidget {
  final String groupId;

  const GroupDetailPage({required this.groupId, super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<GroupBloc>(context)..add(GetGroupByIdEvent(groupId)),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(taskRepository: TaskRepositoryImpl())..add(LoadTasks(groupId)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text("Group Details")),
        body: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            if (state is GroupLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GroupLoadedSingle) {
              final group = state.group;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${group.name}", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text("Subject: ${group.subject}"),
                    const SizedBox(height: 8),
                    Text("Description: ${group.description}"),
                    const SizedBox(height: 16),
                    if (group.leaderId == currentUserId)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AssignTaskPage(
                                groupId: groupId,
                                groupMembers: group.members,
                              ),
                            ),
                          );
                        },
                        child: const Text("Assign Task"),
                      ),
                    const SizedBox(height: 24),
                    const Text("Tasks for this group", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    /// BlocBuilder for tasks
                    Expanded(
                      child: BlocBuilder<TaskBloc, TaskState>(
                        builder: (context, taskState) {
                          if (taskState is TaskLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (taskState is TaskLoaded) {
                            if (taskState.tasks.isEmpty) {
                              return const Text("No tasks assigned yet.");
                            }

                            return ListView.builder(
                              itemCount: taskState.tasks.length,
                              itemBuilder: (context, index) {
                                final task = taskState.tasks[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(task.title),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(task.description),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Due: ${task.dueDate.toString().split(' ')[0]}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          'Priority: ${task.priority}',
                                          style: TextStyle(
                                            color: task.priority == 'High'
                                                ? Colors.red
                                                : task.priority == 'Medium'
                                                    ? Colors.orange
                                                    : Colors.green,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      task.status,
                                      style: TextStyle(
                                        color: task.status == 'completed'
                                            ? Colors.green
                                            : task.status == 'pending'
                                                ? Colors.orange
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (taskState is TaskError) {
                            return Text("Error: ${taskState.message}");
                          } else {
                            return const Text("Unknown state.");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is GroupError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("No group found."));
            }
          },
        ),
      ),
    );
  }
}
