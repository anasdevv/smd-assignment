import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/groups/domain/repositories/group_repository.dart';
import 'package:smd_project/features/groups/domain/usecases/join_group.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_event.dart';
import 'package:smd_project/features/groups/presentation/bloc/groups_state.dart';
import 'package:smd_project/features/groups/data/models/group_model.dart';
import 'package:smd_project/features/groups/domain/entities/group_entity.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository groupRepository;
  final JoinGroup joinGroupUseCase; // Assuming you have a JoinGroup use case

  GroupBloc({required this.groupRepository, required this.joinGroupUseCase})
      : super(GroupInitial()) {
    on<GetUserGroups>(_onGetUserGroups);
    on<CreateGroupEvent>(_onCreateGroup);
    on<JoinGroupEvent>(_onJoinGroup);
    on<GetAllGroupsEvent>(_onGetAllGroups);
    on<GetGroupByIdEvent>(_onGetGroupById);

    on<GetGroupAnnouncements>(_onGetGroupAnnouncements);
    on<CreateAnnouncement>(_onCreateAnnouncement);
    on<UpdateAnnouncement>(_onUpdateAnnouncement);
    on<DeleteAnnouncement>(_onDeleteAnnouncement);
    on<AddAnnouncementAttachment>(_onAddAnnouncementAttachment);
    on<RemoveAnnouncementAttachment>(_onRemoveAnnouncementAttachment);
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

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupCreating());
    try {
      await groupRepository.createGroup(event.group);
      emit(GroupCreated());
    } catch (e) {
      emit(GroupCreationError(e.toString()));
    }
  }

  Future<void> _onJoinGroup(
    JoinGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupJoining());
    try {
      await groupRepository.addMember(event.groupId, event.userId);

      if (state is GroupLoaded) {
        final currentGroups = (state as GroupLoaded).groups;

        final updatedGroups = currentGroups.map((group) {
          if (group.id == event.groupId && group is GroupModel) {
            return group.copyWith(isJoined: true); // ✅ Use copyWith
          }
          return group;
        }).toList();

        emit(GroupLoaded(updatedGroups));
      } else {
        emit(const GroupError("Unable to join group. Group list not loaded."));
      }
    } catch (e) {
      emit(GroupJoinError(e.toString()));
    }
  }

  Future<void> _onGetAllGroups(
    GetAllGroupsEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      final groups = await groupRepository.getAllGroupsStream().first;

      final userGroups = await groupRepository.getGroupsByUser(event.userId);

      final joinedGroupIds = userGroups.map((g) => g.id).toSet();

      final updatedGroups = groups.map((group) {
        final isJoined = joinedGroupIds.contains(group.id);
        final groupModel = group as GroupModel;
        return GroupModel.fromMap(
          group.id,
          {
            ...groupModel.toMap(),
            'isJoined': isJoined,
          },
        );
      }).toList();

      emit(GroupLoaded(updatedGroups));
    } catch (e) {
      emit(GroupError('Failed to fetch all groups: $e'));
    }
  }

  Future<void> _onGetGroupById(
    GetGroupByIdEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      final group = await groupRepository.getGroupById(event.groupId);
      emit(GroupLoadedSingle(group));
    } catch (e) {
      emit(GroupError("Failed to load group: $e"));
    }
  }

  Future<void> _onGetGroupAnnouncements(
    GetGroupAnnouncements event,
    Emitter<GroupState> emit,
  ) async {
    emit(AnnouncementsLoading());
    try {
      final announcements = await groupRepository.getAnnouncementsByGroup(
        event.groupId,
      );
      emit(AnnouncementsLoaded(announcements));
    } catch (e) {
      print('e ${e}');
      emit(AnnouncementsError(e.toString()));
    }
  }

  Future<void> _onCreateAnnouncement(
    CreateAnnouncement event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await groupRepository.createAnnouncement(event.announcement);
      emit(AnnouncementCreated());
      add(GetGroupAnnouncements(event.announcement.groupId));
    } catch (e) {
      emit(AnnouncementsError(e.toString()));
    }
  }

  Future<void> _onUpdateAnnouncement(
    UpdateAnnouncement event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await groupRepository.updateAnnouncement(event.announcement);
      emit(AnnouncementUpdated());
      add(GetGroupAnnouncements(event.announcement.groupId));
    } catch (e) {
      emit(AnnouncementsError(e.toString()));
    }
  }

  Future<void> _onDeleteAnnouncement(
    DeleteAnnouncement event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await groupRepository.deleteAnnouncement(event.announcementId);
      emit(AnnouncementDeleted());
    } catch (e) {
      emit(AnnouncementsError(e.toString()));
    }
  }

  Future<void> _onAddAnnouncementAttachment(
    AddAnnouncementAttachment event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await groupRepository.addAttachment(
        event.announcementId,
        event.fileId,
      );
    } catch (e) {
      emit(AnnouncementsError(e.toString()));
    }
  }

  Future<void> _onRemoveAnnouncementAttachment(
    RemoveAnnouncementAttachment event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await groupRepository.removeAttachment(
        event.announcementId,
        event.fileId,
      );
    } catch (e) {
      emit(AnnouncementsError(e.toString()));
    }
  }
}
