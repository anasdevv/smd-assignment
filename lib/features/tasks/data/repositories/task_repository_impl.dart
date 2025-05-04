import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smd_project/features/tasks/data/models/task_model.dart';
import 'package:smd_project/features/tasks/domain/entities/task_entity.dart';
import 'package:smd_project/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference _getTasksCollection(String groupId) {
    return _firestore.collection('groups').doc(groupId).collection('tasks');
  }

  @override
  Future<void> createTask(String groupId, TaskEntity task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      createdAt: task.createdAt,
      createdBy: task.createdBy,
      dueDate: task.dueDate,
      priority: task.priority,
      status: task.status,
      assignedTo: task.assignedTo,
      attachments: task.attachments,
    );

    await _getTasksCollection(groupId).doc(task.id).set(taskModel.toMap());
  }

  @override
  Future<void> updateTask(String groupId, TaskEntity task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      createdAt: task.createdAt,
      createdBy: task.createdBy,
      dueDate: task.dueDate,
      priority: task.priority,
      status: task.status,
      assignedTo: task.assignedTo,
      attachments: task.attachments,
    );

    await _getTasksCollection(groupId).doc(task.id).update(taskModel.toMap());
  }

  @override
  Future<void> deleteTask(String groupId, String taskId) async {
    await _getTasksCollection(groupId).doc(taskId).delete();
  }

  @override
  Future<TaskEntity?> getTask(String groupId, String taskId) async {
    final doc = await _getTasksCollection(groupId).doc(taskId).get();
    if (!doc.exists) return null;
    return TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  @override
  Stream<List<TaskEntity>> getGroupTasks(String groupId) {
    return _getTasksCollection(groupId).orderBy('dueDate').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) =>
                TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Stream<List<TaskEntity>> getUserTasks(String groupId, String userId) {
    return _getTasksCollection(groupId)
        .where('assignedTo', arrayContains: userId)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<List<TaskEntity>> getOverdueTasks(String groupId) async {
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

  @override
  Future<void> updateTaskStatus(
      String groupId, String taskId, String status) async {
    await _getTasksCollection(groupId).doc(taskId).update({'status': status});
  }

  @override
  Future<void> assignTask(String groupId, String taskId, String userId) async {
    await _getTasksCollection(groupId).doc(taskId).update({
      'assignedTo': FieldValue.arrayUnion([userId])
    });
  }

  @override
  Future<void> unassignTask(
      String groupId, String taskId, String userId) async {
    await _getTasksCollection(groupId).doc(taskId).update({
      'assignedTo': FieldValue.arrayRemove([userId])
    });
  }

  @override
  Future<void> addTaskAttachment(
      String groupId, String taskId, String attachmentUrl) async {
    await _getTasksCollection(groupId).doc(taskId).update({
      'attachments': FieldValue.arrayUnion([attachmentUrl])
    });
  }

  @override
  Future<void> removeTaskAttachment(
      String groupId, String taskId, String attachmentUrl) async {
    await _getTasksCollection(groupId).doc(taskId).update({
      'attachments': FieldValue.arrayRemove([attachmentUrl])
    });
  }
}
