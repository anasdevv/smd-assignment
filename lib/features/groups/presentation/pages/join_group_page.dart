import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_event.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_state.dart';

class JoinGroupScreen extends StatelessWidget {
  final String userId;

  const JoinGroupScreen({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<GroupBloc>(context)
        ..add(GetGroupsUserIsNotInEvent(userId)),
      child: Scaffold(
        appBar: AppBar(title: Text("Join a Group")),
        body: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            if (state is GroupLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GroupLoaded) {
              return ListView.builder(
                itemCount: state.groups.length,
                itemBuilder: (context, index) {
                  final group = state.groups[index];
                  return ListTile(
                    title: Text(group.name),
                    subtitle: Text(group.subject),
                    trailing: group.isJoined
                        ? Icon(Icons.check, color: Colors.green)
                        : ElevatedButton(
                            onPressed: () {
                              context.read<GroupBloc>().add(
                                    JoinGroupEvent(
                                      groupId: group.id,
                                      userId: userId,
                                    ),
                                  );
                            },
                            child: Text('Join'),
                          ),
                  );
                },
              );
            } else if (state is GroupError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('No groups found.'));
            }
          },
        ),
      ),
    );
  }
}
