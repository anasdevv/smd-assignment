import 'package:equatable/equatable.dart';
import 'package:smd_project/features/groups/domain/entities/group_entity.dart';
import 'package:smd_project/features/groups/domain/entities/announcement_entity.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class GetUserGroups extends GroupEvent {
  final String userId;

  const GetUserGroups(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateGroupEvent extends GroupEvent {
  final GroupEntity group;

  const CreateGroupEvent(this.group);

  @override
  List<Object> get props => [group];
}

class JoinGroupEvent extends GroupEvent {
  final String groupId;
  final String userId;

  const JoinGroupEvent({
    required this.groupId,
    required this.userId,
  });

  @override
  List<Object> get props => [groupId, userId];
}

class GetAllGroupsEvent extends GroupEvent {
  final String userId;

  const GetAllGroupsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetGroupByIdEvent extends GroupEvent {
  final String groupId;

  const GetGroupByIdEvent(this.groupId);
}

class CheckAuthStatus extends GroupEvent {}

// Announcement events
class GetGroupAnnouncements extends GroupEvent {
  final String groupId;

  const GetGroupAnnouncements(this.groupId);

  @override
  List<Object> get props => [groupId];
}

class CreateAnnouncement extends GroupEvent {
  final AnnouncementEntity announcement;

  const CreateAnnouncement(this.announcement);

  @override
  List<Object> get props => [announcement];
}

class UpdateAnnouncement extends GroupEvent {
  final AnnouncementEntity announcement;

  const UpdateAnnouncement(this.announcement);

  @override
  List<Object> get props => [announcement];
}

class DeleteAnnouncement extends GroupEvent {
  final String announcementId;

  const DeleteAnnouncement(this.announcementId);

  @override
  List<Object> get props => [announcementId];
}

class AddAnnouncementAttachment extends GroupEvent {
  final String announcementId;
  final String fileId;

  const AddAnnouncementAttachment({
    required this.announcementId,
    required this.fileId,
  });

  @override
  List<Object> get props => [announcementId, fileId];
}

class RemoveAnnouncementAttachment extends GroupEvent {
  final String announcementId;
  final String fileId;

  const RemoveAnnouncementAttachment({
    required this.announcementId,
    required this.fileId,
  });

  @override
  List<Object> get props => [announcementId, fileId];
}

class JoinGroupByCodeEvent extends GroupEvent {
  final String code;
  final String userId;

  const JoinGroupByCodeEvent({
    required this.code,
    required this.userId,
  });

  @override
  List<Object> get props => [code, userId];
}
