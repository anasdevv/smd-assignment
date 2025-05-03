import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_model.dart';

class GroupRepository {
  final CollectionReference _groupsCollection =
      FirebaseFirestore.instance.collection('groups');

  Future<void> createGroup(GroupModel group) async {
    await _groupsCollection.doc(group.id).set(group.toMap());
  }

  Future<GroupModel?> getGroup(String groupId) async {
    final doc = await _groupsCollection.doc(groupId).get();
    if (!doc.exists) return null;
    return GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<void> updateGroup(GroupModel group) async {
    await _groupsCollection.doc(group.id).update(group.toMap());
  }

  Future<void> deleteGroup(String groupId) async {
    await _groupsCollection.doc(groupId).delete();
  }

  Future<void> addMember(String groupId, String userId) async {
    await _groupsCollection.doc(groupId).update({
      'members': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> removeMember(String groupId, String userId) async {
    await _groupsCollection.doc(groupId).update({
      'members': FieldValue.arrayRemove([userId])
    });
  }

  Future<void> updateLeader(String groupId, String newLeaderId) async {
    await _groupsCollection.doc(groupId).update({'leaderId': newLeaderId});
  }

  Future<void> updateTags(String groupId, List<String> tags) async {
    await _groupsCollection.doc(groupId).update({'tags': tags});
  }

  Stream<GroupModel> groupStream(String groupId) {
    return _groupsCollection.doc(groupId).snapshots().map((doc) =>
        GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>));
  }

  Stream<List<GroupModel>> userGroupsStream(String userId) {
    return _groupsCollection
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<GroupModel>> publicGroupsStream() {
    return _groupsCollection.where('isPublic', isEqualTo: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) =>
                GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<GroupModel>> searchGroups(String query) async {
    // Search by name, subject, or tags
    final queryLower = query.toLowerCase();
    final snapshot =
        await _groupsCollection.where('isPublic', isEqualTo: true).get();

    return snapshot.docs
        .map((doc) =>
            GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .where((group) =>
            group.name.toLowerCase().contains(queryLower) ||
            group.subject.toLowerCase().contains(queryLower) ||
            group.tags.any((tag) => tag.toLowerCase().contains(queryLower)))
        .toList();
  }
}
