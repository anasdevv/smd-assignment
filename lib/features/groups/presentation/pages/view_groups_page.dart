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
          final userId =
              state.user.id; // Access the userId from Authenticated state

          // Dispatch the event to fetch groups for the authenticated user
          context.read<GroupBloc>().add(GetUserGroups(userId));

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
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(group.name),
                        subtitle: Text(group.subject),
                        trailing: const Icon(Icons.group),
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
