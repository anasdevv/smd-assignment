import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smd_project/features/authentication/data/models/user_model.dart';
import 'package:smd_project/features/authentication/domain/entities/user_entity.dart';
import 'package:smd_project/features/authentication/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    final userModel = UserModel(
      id: user.id,
      displayName: user.displayName,
      email: user.email,
      photoURL: user.photoURL,
      createdAt: user.createdAt,
      lastActive: user.lastActive,
      groups: user.groups,
      tasksAssigned: user.tasksAssigned,
      deviceTokens: user.deviceTokens,
    );

    await _firestore.collection('users').doc(user.id).set(userModel.toMap());
    return userModel;
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    final userModel = UserModel(
      id: user.id,
      displayName: user.displayName,
      email: user.email,
      photoURL: user.photoURL,
      createdAt: user.createdAt,
      lastActive: user.lastActive,
      groups: user.groups,
      tasksAssigned: user.tasksAssigned,
      deviceTokens: user.deviceTokens,
    );

    await _firestore.collection('users').doc(user.id).update(userModel.toMap());
    return userModel;
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  @override
  Future<UserEntity> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) {
      throw Exception('User not found');
    }
    return UserModel.fromMap(userId, doc.data()!);
  }

  @override
  Future<UserEntity> getUserByEmail(String email) async {
    final query = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (query.docs.isEmpty) {
      throw Exception('User not found');
    }
    return UserModel.fromMap(query.docs.first.id, query.docs.first.data());
  }

  @override
  Future<List<UserEntity>> getUsersByGroup(String groupId) async {
    final query = await _firestore
        .collection('users')
        .where('groups', arrayContains: groupId)
        .get();
    return query.docs
        .map((doc) => UserModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> updateUserLastActive(String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({'lastActive': Timestamp.now()});
  }

  @override
  Future<void> addUserToGroup(String userId, String groupId) async {
    await _firestore.collection('users').doc(userId).update({
      'groups': FieldValue.arrayUnion([groupId])
    });
  }

  @override
  Future<void> removeUserFromGroup(String userId, String groupId) async {
    await _firestore.collection('users').doc(userId).update({
      'groups': FieldValue.arrayRemove([groupId])
    });
  }

  @override
  Future<void> addTaskToUser(String userId, String taskId) async {
    await _firestore.collection('users').doc(userId).update({
      'tasksAssigned': FieldValue.arrayUnion([taskId])
    });
  }

  @override
  Future<void> removeTaskFromUser(String userId, String taskId) async {
    await _firestore.collection('users').doc(userId).update({
      'tasksAssigned': FieldValue.arrayRemove([taskId])
    });
  }

  @override
  Future<void> addDeviceToken(String userId, String token) async {
    await _firestore.collection('users').doc(userId).update({
      'deviceTokens': FieldValue.arrayUnion([token])
    });
  }

  @override
  Future<void> removeDeviceToken(String userId, String token) async {
    await _firestore.collection('users').doc(userId).update({
      'deviceTokens': FieldValue.arrayRemove([token])
    });
  }

  @override
  Stream<UserEntity> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => UserModel.fromMap(userId, doc.data()!));
  }
}
