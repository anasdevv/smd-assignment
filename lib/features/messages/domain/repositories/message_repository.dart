import 'package:smd_project/features/messages/domain/entities/message_entity.dart';

abstract class MessageRepository {
  Future<void> sendMessage(String groupId, MessageEntity message);
  Future<void> deleteMessage(String groupId, String messageId);
  Future<void> markMessageAsRead(
      String groupId, String messageId, String userId);
  Stream<List<MessageEntity>> getGroupMessages(String groupId);
  Future<List<MessageEntity>> getMessagesBefore(
      String groupId, DateTime before, int limit);
  Future<List<MessageEntity>> searchMessages(String groupId, String query);
  Stream<List<MessageEntity>> getUnreadMessages(String groupId, String userId);
}
