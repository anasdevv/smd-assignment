import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/groups/domain/repositories/group_repository.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_event.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository groupRepository;

  GroupBloc({required this.groupRepository}) : super(GroupInitial()) {
    on<GetUserGroups>(_onGetUserGroups);
  }

  Future<void> _onGetUserGroups(
    GetUserGroups event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      final groups = await groupRepository.getGroupsByUser(
        event.userId,
      );
      print(groups);
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }
}
