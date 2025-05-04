import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smd_project/features/messages/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.text,
    required super.senderId,
    required super.senderName,
    required super.timestamp,
    required super.readBy,
    super.attachmentUrl,
    super.attachmentType,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': Timestamp.fromDate(timestamp),
      'readBy': readBy,
      'attachmentUrl': attachmentUrl,
      'attachmentType': attachmentType,
    };
  }

  factory MessageModel.fromMap(String id, Map<String, dynamic> map) {
    return MessageModel(
      id: id,
      text: map['text'] as String,
      senderId: map['senderId'] as String,
      senderName: map['senderName'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      readBy: List<String>.from(map['readBy'] ?? []),
      attachmentUrl: map['attachmentUrl'] as String?,
      attachmentType: map['attachmentType'] as String?,
    );
  }

  MessageModel copyWith({
    String? text,
    String? senderId,
    String? senderName,
    DateTime? timestamp,
    List<String>? readBy,
    String? attachmentUrl,
    String? attachmentType,
  }) {
    return MessageModel(
      id: id,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      timestamp: timestamp ?? this.timestamp,
      readBy: readBy ?? this.readBy,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentType: attachmentType ?? this.attachmentType,
    );
  }
}
