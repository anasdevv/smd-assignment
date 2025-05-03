import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reminder_model.dart';

class ReminderRepository {
  CollectionReference _getRemindersCollection(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('reminders');
  }

  Future<void> createReminder(String groupId, ReminderModel reminder) async {
    await _getRemindersCollection(groupId)
        .doc(reminder.id)
        .set(reminder.toMap());
  }

  Future<void> updateReminder(String groupId, ReminderModel reminder) async {
    await _getRemindersCollection(groupId)
        .doc(reminder.id)
        .update(reminder.toMap());
  }

  Future<void> deleteReminder(String groupId, String reminderId) async {
    await _getRemindersCollection(groupId).doc(reminderId).delete();
  }

  Future<ReminderModel?> getReminder(String groupId, String reminderId) async {
    final doc = await _getRemindersCollection(groupId).doc(reminderId).get();
    if (!doc.exists) return null;
    return ReminderModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Stream<List<ReminderModel>> getGroupReminders(String groupId) {
    return _getRemindersCollection(groupId)
        .orderBy('reminderTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReminderModel.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<ReminderModel>> getUserReminders(String groupId, String userId) {
    return _getRemindersCollection(groupId)
        .where('notifyUsers', arrayContains: userId)
        .orderBy('reminderTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReminderModel.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<ReminderModel>> getUpcomingReminders(String groupId) async {
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

  Future<void> addUserToNotify(
      String groupId, String reminderId, String userId) async {
    await _getRemindersCollection(groupId).doc(reminderId).update({
      'notifyUsers': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> removeUserFromNotify(
      String groupId, String reminderId, String userId) async {
    await _getRemindersCollection(groupId).doc(reminderId).update({
      'notifyUsers': FieldValue.arrayRemove([userId])
    });
  }

  Future<void> toggleNotifyAll(
      String groupId, String reminderId, bool notifyAll) async {
    await _getRemindersCollection(groupId)
        .doc(reminderId)
        .update({'notifyAll': notifyAll});
  }
}
