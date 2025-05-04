import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smd_project/features/reminders/data/models/reminder_model.dart';
import 'package:smd_project/features/reminders/domain/entities/reminder_entity.dart';
import 'package:smd_project/features/reminders/domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final FirebaseFirestore _firestore;

  ReminderRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference _getRemindersCollection(String groupId) {
    return _firestore.collection('groups').doc(groupId).collection('reminders');
  }

  @override
  Future<void> createReminder(String groupId, ReminderEntity reminder) async {
    final reminderModel = ReminderModel(
      id: reminder.id,
      title: reminder.title,
      description: reminder.description,
      createdAt: reminder.createdAt,
      createdBy: reminder.createdBy,
      reminderTime: reminder.reminderTime,
      notifyAll: reminder.notifyAll,
      notifyUsers: reminder.notifyUsers,
      relatedTaskId: reminder.relatedTaskId,
    );

    await _getRemindersCollection(groupId)
        .doc(reminder.id)
        .set(reminderModel.toMap());
  }

  @override
  Future<void> updateReminder(String groupId, ReminderEntity reminder) async {
    final reminderModel = ReminderModel(
      id: reminder.id,
      title: reminder.title,
      description: reminder.description,
      createdAt: reminder.createdAt,
      createdBy: reminder.createdBy,
      reminderTime: reminder.reminderTime,
      notifyAll: reminder.notifyAll,
      notifyUsers: reminder.notifyUsers,
      relatedTaskId: reminder.relatedTaskId,
    );

    await _getRemindersCollection(groupId)
        .doc(reminder.id)
        .update(reminderModel.toMap());
  }

  @override
  Future<void> deleteReminder(String groupId, String reminderId) async {
    await _getRemindersCollection(groupId).doc(reminderId).delete();
  }

  @override
  Future<ReminderEntity?> getReminder(String groupId, String reminderId) async {
    final doc = await _getRemindersCollection(groupId).doc(reminderId).get();
    if (!doc.exists) return null;
    return ReminderModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  @override
  Stream<List<ReminderEntity>> getGroupReminders(String groupId) {
    return _getRemindersCollection(groupId)
        .orderBy('reminderTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReminderModel.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Stream<List<ReminderEntity>> getUserReminders(String groupId, String userId) {
    return _getRemindersCollection(groupId)
        .where('notifyUsers', arrayContains: userId)
        .orderBy('reminderTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReminderModel.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<List<ReminderEntity>> getUpcomingReminders(String groupId) async {
    final now = DateTime.now();
    final snapshot = await _getRemindersCollection(groupId)
        .where('reminderTime', isGreaterThan: Timestamp.fromDate(now))
        .orderBy('reminderTime')
        .get();

    return snapshot.docs
        .map((doc) =>
            ReminderModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addUserToNotify(
      String groupId, String reminderId, String userId) async {
    await _getRemindersCollection(groupId).doc(reminderId).update({
      'notifyUsers': FieldValue.arrayUnion([userId])
    });
  }

  @override
  Future<void> removeUserFromNotify(
      String groupId, String reminderId, String userId) async {
    await _getRemindersCollection(groupId).doc(reminderId).update({
      'notifyUsers': FieldValue.arrayRemove([userId])
    });
  }

  @override
  Future<void> toggleNotifyAll(
      String groupId, String reminderId, bool notifyAll) async {
    await _getRemindersCollection(groupId)
        .doc(reminderId)
        .update({'notifyAll': notifyAll});
  }
}
