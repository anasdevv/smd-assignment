import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class MessageRepository {
  CollectionReference _getMessagesCollection(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages');
  }

  Future<void> sendMessage(String groupId, MessageModel message) async {
    await _getMessagesCollection(groupId).doc(message.id).set(message.toMap());
  }

  Future<void> deleteMessage(String groupId, String messageId) async {
    await _getMessagesCollection(groupId).doc(messageId).delete();
  }

  Future<void> markMessageAsRead(
      String groupId, String messageId, String userId) async {
    await _getMessagesCollection(groupId).doc(messageId).update({
      'readBy': FieldValue.arrayUnion([userId])
    });
  }

  Stream<List<MessageModel>> getGroupMessages(String groupId) {
    return _getMessagesCollection(groupId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<MessageModel>> getMessagesBefore(
      String groupId, DateTime before, int limit) async {
    final snapshot = await _getMessagesCollection(groupId)
        .orderBy('timestamp', descending: true)
        .where('timestamp', isLessThan: Timestamp.fromDate(before))
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) =>
            MessageModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<MessageModel>> searchMessages(
      String groupId, String query) async {
    final queryLower = query.toLowerCase();
    final snapshot = await _getMessagesCollection(groupId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            MessageModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .where((message) => message.text.toLowerCase().contains(queryLower))
        .toList();
  }

  Stream<List<MessageModel>> getUnreadMessages(String groupId, String userId) {
    return _getMessagesCollection(groupId)
        .where('readBy', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}
