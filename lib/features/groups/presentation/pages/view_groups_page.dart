import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is Authenticated) {
          final userId = state.user.id;
          context.read<GroupBloc>().add(GetUserGroups(userId));

          return BlocBuilder<GroupBloc, GroupState>(
            builder: (context, groupState) {
              if (groupState is GroupLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (groupState is GroupLoaded) {
                final groups = groupState.groups;

                if (groups.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Groups Yet',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create or join a group to get started',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _GroupCard(
                        group: group,
                        onTap: () {
                          context.push('/home/group/${group.id}');
                        },
                      ),
                    );
                  },
                );
              }
              if (groupState is GroupError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Groups',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        groupState.message,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        }

        return const Center(
          child: Text(
            "Please log in to view your groups",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}

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
