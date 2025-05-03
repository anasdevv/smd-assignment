import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    try {
      print('🔄 Attempting to create user document with ID: ${user.id}');
      print('📝 User data to be saved: ${user.toMap()}');

      await _usersCollection.doc(user.id).set(user.toMap());
      print('✅ Successfully created user document for: ${user.displayName}');
    } catch (e, stackTrace) {
      print('❌ Error creating user document: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _usersCollection.doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<void> updateUser(UserModel user) async {
    await _usersCollection.doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String userId) async {
    await _usersCollection.doc(userId).delete();
  }

  Future<void> addGroupToUser(String userId, String groupId) async {
    await _usersCollection.doc(userId).update({
      'groups': FieldValue.arrayUnion([groupId])
    });
  }

  Future<void> removeGroupFromUser(String userId, String groupId) async {
    await _usersCollection.doc(userId).update({
      'groups': FieldValue.arrayRemove([groupId])
    });
  }

  Future<void> addTaskToUser(String userId, String taskId) async {
    await _usersCollection.doc(userId).update({
      'tasksAssigned': FieldValue.arrayUnion([taskId])
    });
  }

  Future<void> removeTaskFromUser(String userId, String taskId) async {
    await _usersCollection.doc(userId).update({
      'tasksAssigned': FieldValue.arrayRemove([taskId])
    });
  }

  Future<void> updateDeviceToken(String userId, String token) async {
    await _usersCollection.doc(userId).update({
      'deviceTokens': FieldValue.arrayUnion([token])
    });
  }

  Future<void> removeDeviceToken(String userId, String token) async {
    await _usersCollection.doc(userId).update({
      'deviceTokens': FieldValue.arrayRemove([token])
    });
  }

  Stream<UserModel> userStream(String userId) {
    return _usersCollection.doc(userId).snapshots().map(
        (doc) => UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>));
  }
}
