import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smd_project/features/messages/domain/repositories/message_repository.dart';
import 'package:smd_project/features/messages/data/models/message_model.dart';

import '../../mocks/mocks.mocks.dart';

void main() {
  late MockMessageRepository mockMessageRepository;

  setUp(() {
    mockMessageRepository = MockMessageRepository();
  });

  final testMessage = MessageModel(
    id: 'm1',
    text: 'Hello team!',
    senderId: 'user123',
    senderName: 'Alice',
    timestamp: DateTime.now(),
    readBy: ['user123'],
  );

  group('MessageRepository', () {
    test('sendMessage stores a message', () async {
      when(mockMessageRepository.sendMessage('g1', testMessage))
          .thenAnswer((_) async => null);

      await mockMessageRepository.sendMessage('g1', testMessage);

      verify(mockMessageRepository.sendMessage('g1', testMessage)).called(1);
    });

    test('deleteMessage removes a message', () async {
      when(mockMessageRepository.deleteMessage('g1', 'm1'))
          .thenAnswer((_) async => null);

      await mockMessageRepository.deleteMessage('g1', 'm1');

      verify(mockMessageRepository.deleteMessage('g1', 'm1')).called(1);
    });
  });
}
