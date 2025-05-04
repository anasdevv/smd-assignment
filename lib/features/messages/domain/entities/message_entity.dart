import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final List<String> readBy;
  final String? attachmentUrl;
  final String? attachmentType;

  const MessageEntity({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    required this.readBy,
    this.attachmentUrl,
    this.attachmentType,
  });

  @override
  List<Object?> get props => [
        id,
        text,
        senderId,
        senderName,
        timestamp,
        readBy,
        attachmentUrl,
        attachmentType,
      ];
}
