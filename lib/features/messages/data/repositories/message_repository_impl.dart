import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smd_project/features/messages/data/models/message_model.dart';
import 'package:smd_project/features/messages/domain/entities/message_entity.dart';
import 'package:smd_project/features/messages/domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final FirebaseFirestore _firestore;

  MessageRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference _getMessagesCollection(String groupId) {
    return _firestore.collection('groups').doc(groupId).collection('messages');
  }

  @override
  Future<void> sendMessage(String groupId, MessageEntity message) async {
    final messageModel = MessageModel(
      id: message.id,
      text: message.text,
      senderId: message.senderId,
      senderName: message.senderName,
      timestamp: message.timestamp,
      readBy: message.readBy,
    );

    await _getMessagesCollection(groupId)
        .doc(message.id)
        .set(messageModel.toMap());
  }

  @override
  Future<void> deleteMessage(String groupId, String messageId) async {
    await _getMessagesCollection(groupId).doc(messageId).delete();
  }

  @override
  Future<void> markMessageAsRead(
      String groupId, String messageId, String userId) async {
    await _getMessagesCollection(groupId).doc(messageId).update({
      'readBy': FieldValue.arrayUnion([userId])
    });
  }

  @override
  Stream<List<MessageEntity>> getGroupMessages(String groupId) {
    return _getMessagesCollection(groupId).orderBy('timestamp').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<List<MessageEntity>> getMessagesBefore(
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

  @override
  Future<List<MessageEntity>> searchMessages(
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

  @override
  Stream<List<MessageEntity>> getUnreadMessages(String groupId, String userId) {
    return _getMessagesCollection(groupId)
        .where('readBy', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}
