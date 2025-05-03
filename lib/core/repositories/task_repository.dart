import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskRepository {
  CollectionReference _getTasksCollection(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('tasks');
  }

  Future<void> createTask(String groupId, TaskModel task) async {
    await _getTasksCollection(groupId).doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(String groupId, TaskModel task) async {
    await _getTasksCollection(groupId).doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String groupId, String taskId) async {
    await _getTasksCollection(groupId).doc(taskId).delete();
  }

  Future<TaskModel?> getTask(String groupId, String taskId) async {
    final doc = await _getTasksCollection(groupId).doc(taskId).get();
    if (!doc.exists) return null;
    return TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Stream<List<TaskModel>> getGroupTasks(String groupId) {
    return _getTasksCollection(groupId).orderBy('dueDate').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) =>
                TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<TaskModel>> getUserTasks(String groupId, String userId) {
    return _getTasksCollection(groupId)
        .where('assignedTo', arrayContains: userId)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<TaskModel>> getOverdueTasks(String groupId) async {
    final now = DateTime.now();
    final snapshot = await _getTasksCollection(groupId)
        .where('dueDate', isLessThan: Timestamp.fromDate(now))
        .where('status', isNotEqualTo: 'completed')
        .get();

    return snapshot.docs
        .map((doc) =>
            TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateTaskStatus(
      String groupId, String taskId, String status) async {
    await _getTasksCollection(groupId).doc(taskId).update({'status': status});
  }

  Future<void> assignTask(String groupId, String taskId, String userId) async {
    await _getTasksCollection(groupId).doc(taskId).update({
      'assignedTo': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> unassignTask(
      String groupId, String taskId, String userId) async {
    await _getTasksCollection(groupId).doc(taskId).update({
      'assignedTo': FieldValue.arrayRemove([userId])
    });
  }

  Future<void> addTaskAttachment(
      String groupId, String taskId, String attachmentUrl) async {
    await _getTasksCollection(groupId).doc(taskId).update({
      'attachments': FieldValue.arrayUnion([attachmentUrl])
    });
  }

  Future<void> removeTaskAttachment(
      String groupId, String taskId, String attachmentUrl) async {
    await _getTasksCollection(groupId).doc(taskId).update({
      'attachments': FieldValue.arrayRemove([attachmentUrl])
    });
  }
}
