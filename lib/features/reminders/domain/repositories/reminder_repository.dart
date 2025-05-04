import 'package:smd_project/features/reminders/domain/entities/reminder_entity.dart';

abstract class ReminderRepository {
  Future<void> createReminder(String groupId, ReminderEntity reminder);
  Future<void> updateReminder(String groupId, ReminderEntity reminder);
  Future<void> deleteReminder(String groupId, String reminderId);
  Future<ReminderEntity?> getReminder(String groupId, String reminderId);
  Stream<List<ReminderEntity>> getGroupReminders(String groupId);
  Stream<List<ReminderEntity>> getUserReminders(String groupId, String userId);
  Future<List<ReminderEntity>> getUpcomingReminders(String groupId);
  Future<void> addUserToNotify(
      String groupId, String reminderId, String userId);
  Future<void> removeUserFromNotify(
      String groupId, String reminderId, String userId);
  Future<void> toggleNotifyAll(
      String groupId, String reminderId, bool notifyAll);
}
