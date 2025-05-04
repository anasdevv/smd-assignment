import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smd_project/features/groups/data/models/group_model.dart';
import 'package:smd_project/features/groups/domain/entities/group_entity.dart';
import 'package:smd_project/features/groups/domain/repositories/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  final FirebaseFirestore _firestore;

  GroupRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _groupsCollection => _firestore.collection('groups');

  @override
  Future<void> createGroup(GroupEntity group) async {
    final groupModel = GroupModel(
      id: group.id,
      name: group.name,
      subject: group.subject,
      description: group.description,
      createdAt: group.createdAt,
      createdBy: group.createdBy,
      leaderId: group.leaderId,
      members: group.members,
      isPublic: group.isPublic,
      tags: group.tags,
    );

    await _groupsCollection.doc(group.id).set(groupModel.toMap());
  }

  @override
  Future<void> updateGroup(GroupEntity group) async {
    final groupModel = GroupModel(
      id: group.id,
      name: group.name,
      subject: group.subject,
      description: group.description,
      createdAt: group.createdAt,
      createdBy: group.createdBy,
      leaderId: group.leaderId,
      members: group.members,
      isPublic: group.isPublic,
      tags: group.tags,
    );

    await _groupsCollection.doc(group.id).update(groupModel.toMap());
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await _groupsCollection.doc(groupId).delete();
  }

  @override
  Future<GroupEntity?> getGroup(String groupId) async {
    final doc = await _groupsCollection.doc(groupId).get();
    if (!doc.exists) return null;
    return GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  @override
  Future<List<GroupEntity>> getGroupsByUser(String userId) async {
    final snapshot =
        await _groupsCollection.where('members', arrayContains: userId).get();
    return snapshot.docs
        .map((doc) =>
            GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<GroupEntity>> getGroupsByLeader(String leaderId) async {
    final snapshot =
        await _groupsCollection.where('leaderId', isEqualTo: leaderId).get();
    return snapshot.docs
        .map((doc) =>
            GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<GroupEntity>> searchGroups(String query) async {
    final snapshot = await _groupsCollection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    return snapshot.docs
        .map((doc) =>
            GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addMember(String groupId, String userId) async {
    await _groupsCollection.doc(groupId).update({
      'members': FieldValue.arrayUnion([userId])
    });
  }

  @override
  Future<void> removeMember(String groupId, String userId) async {
    await _groupsCollection.doc(groupId).update({
      'members': FieldValue.arrayRemove([userId])
    });
  }

  @override
  Future<void> updateLeader(String groupId, String newLeaderId) async {
    await _groupsCollection.doc(groupId).update({'leaderId': newLeaderId});
  }

  @override
  Future<void> addTag(String groupId, String tag) async {
    await _groupsCollection.doc(groupId).update({
      'tags': FieldValue.arrayUnion([tag])
    });
  }

  @override
  Future<void> removeTag(String groupId, String tag) async {
    await _groupsCollection.doc(groupId).update({
      'tags': FieldValue.arrayRemove([tag])
    });
  }

  @override
  Stream<List<GroupEntity>> getGroupsStream(String userId) {
    return _groupsCollection
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<void> addTask(String groupId, String taskId) async {
    await _groupsCollection.doc(groupId).update({
      'tasks': FieldValue.arrayUnion([taskId])
    });
  }

  @override
  Future<void> removeTask(String groupId, String taskId) async {
    await _groupsCollection.doc(groupId).update({
      'tasks': FieldValue.arrayRemove([taskId])
    });
  }

  @override
  Future<void> addFile(String groupId, String fileId) async {
    await _groupsCollection.doc(groupId).update({
      'files': FieldValue.arrayUnion([fileId])
    });
  }

  @override
  Future<void> removeFile(String groupId, String fileId) async {
    await _groupsCollection.doc(groupId).update({
      'files': FieldValue.arrayRemove([fileId])
    });
  }

  @override
  Future<void> addReminder(String groupId, String reminderId) async {
    await _groupsCollection.doc(groupId).update({
      'reminders': FieldValue.arrayUnion([reminderId])
    });
  }

  @override
  Future<void> removeReminder(String groupId, String reminderId) async {
    await _groupsCollection.doc(groupId).update({
      'reminders': FieldValue.arrayRemove([reminderId])
    });
  }
}
