import 'package:smd_project/features/authentication/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> createUser(UserEntity user);
  Future<UserEntity> updateUser(UserEntity user);
  Future<void> deleteUser(String userId);
  Future<UserEntity> getUser(String userId);
  Future<UserEntity> getUserByEmail(String email);
  Future<List<UserEntity>> getUsersByGroup(String groupId);
  Future<void> updateUserLastActive(String userId);
  Future<void> addUserToGroup(String userId, String groupId);
  Future<void> removeUserFromGroup(String userId, String groupId);
  Future<void> addTaskToUser(String userId, String taskId);
  Future<void> removeTaskFromUser(String userId, String taskId);
  Future<void> addDeviceToken(String userId, String token);
  Future<void> removeDeviceToken(String userId, String token);
  Stream<UserEntity> getUserStream(String userId);
}
