import 'package:smd_project/features/groups/domain/entities/announcement_entity.dart';
import 'package:smd_project/features/groups/domain/entities/group_entity.dart';

abstract class GroupRepository {
  Future<void> createGroup(GroupEntity group);
  Future<void> updateGroup(GroupEntity group);
  Future<void> deleteGroup(String groupId);
  Future<GroupEntity?> getGroup(String groupId);
  Future<List<GroupEntity>> getGroupsByUser(String userId);
  Future<List<GroupEntity>> getGroupsByLeader(String leaderId);
  Future<List<GroupEntity>> searchGroups(String query);
  Future<void> addMember(String groupId, String userId);
  Future<void> removeMember(String groupId, String userId);
  Future<void> updateLeader(String groupId, String newLeaderId);
  Future<void> addTag(String groupId, String tag);
  Future<void> removeTag(String groupId, String tag);
  Future<void> addTask(String groupId, String taskId);
  Future<void> removeTask(String groupId, String taskId);
  Future<void> addFile(String groupId, String fileId);
  Future<void> removeFile(String groupId, String fileId);
  Future<void> addReminder(String groupId, String reminderId);
  Future<void> removeReminder(String groupId, String reminderId);
  Stream<List<GroupEntity>> getGroupsStream(String userId);
  Stream<List<GroupEntity>> getAllGroupsStream();
  Future<GroupEntity> getGroupById(String groupId);

  // Announcement methods
  Future<void> createAnnouncement(AnnouncementEntity announcement);
  Future<void> updateAnnouncement(AnnouncementEntity announcement);
  Future<void> deleteAnnouncement(String announcementId);
  Future<List<AnnouncementEntity>> getAnnouncementsByGroup(String groupId);
  Stream<List<AnnouncementEntity>> getAnnouncementsStream(String groupId);
  Future<void> addAttachment(String announcementId, String fileId);
  Future<void> removeAttachment(String announcementId, String fileId);

  // Join by code methods
  Future<GroupEntity> getGroupByCode(String code);
  Future<void> joinGroupByCode(String code, String userId);
}
