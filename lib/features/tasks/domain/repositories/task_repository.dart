import 'package:smd_project/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> createTask(String groupId, TaskEntity task);
  Future<void> updateTask(String groupId, TaskEntity task);
  Future<void> deleteTask(String groupId, String taskId);
  Future<TaskEntity?> getTask(String groupId, String taskId);
  Stream<List<TaskEntity>> getGroupTasks(String groupId);
  Stream<List<TaskEntity>> getUserTasks(String groupId, String userId);
  Future<List<TaskEntity>> getOverdueTasks(String groupId);
  Future<void> updateTaskStatus(String groupId, String taskId, String status);
  Future<void> assignTask(String groupId, String taskId, String userId);
  Future<void> unassignTask(String groupId, String taskId, String userId);
  Future<void> addTaskAttachment(
  String groupId, String taskId, String attachmentUrl);
  Future<void> removeTaskAttachment(
  String groupId, String taskId, String attachmentUrl);
}
