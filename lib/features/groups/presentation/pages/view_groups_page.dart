import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_state.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_event.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_state.dart';

class ViewGroupsPage extends StatelessWidget {
  const ViewGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularProgressIndicator();
        }

        if (state is Authenticated) {
<<<<<<< Updated upstream
          final userId =
              state.user.id; // Access the userId from Authenticated state

          // Dispatch the event to fetch groups for the authenticated user
          context.read<GroupBloc>().add(GetUserGroups(userId));
=======
          final userId = state.user.id;

          // Only trigger fetch if groups haven't been loaded yet
          final groupState = context.watch<GroupBloc>().state;
          if (groupState is! GroupLoaded) {
            context.read<GroupBloc>().add(GetUserGroups(userId));
          }
>>>>>>> Stashed changes

          return BlocBuilder<GroupBloc, GroupState>(
            builder: (context, groupState) {
              if (groupState is GroupLoading) {
                return const CircularProgressIndicator();
              }
              if (groupState is GroupLoaded) {
                final groups = groupState.groups;
                return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
<<<<<<< Updated upstream
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(group.name),
                        subtitle: Text(group.subject),
                        trailing: const Icon(Icons.group),
=======
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _GroupCard(
                        group: group,
                        onTap: () {
                          context.go('/home/group/${group.id}');
                        },
>>>>>>> Stashed changes
                      ),
                    );
                  },
                );
              }
              if (groupState is GroupError) {
                return Text("Error: ${groupState.message}");
              }
              return Container();
            },
          );
        }

        return const Center(
            child: Text("User not logged in.")); // Fallback state
      },
    );
  }
}
<<<<<<< Updated upstream
=======

class _GroupCard extends StatelessWidget {
  final dynamic group;
  final VoidCallback onTap;

  const _GroupCard({
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          // ignore: deprecated_member_use
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.group,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          group.subject,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              if (group.description != null &&
                  group.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  group.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${group.members.length} members',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    group.isPublic ? Icons.public : Icons.lock,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    group.isPublic ? 'Public' : 'Private',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
>>>>>>> Stashed changes
