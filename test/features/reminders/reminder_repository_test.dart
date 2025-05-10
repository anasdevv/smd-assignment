import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smd_project/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:smd_project/features/reminders/data/models/reminder_model.dart';

import '../../mocks/mocks.mocks.dart';

void main() {
  late MockReminderRepository mockReminderRepository;

  setUp(() {
    mockReminderRepository = MockReminderRepository();
  });

  final reminder = ReminderModel(
    id: 'r1',
    title: 'Submit Assignment',
    description: 'Due next week',
    createdAt: DateTime.now(),
    createdBy: 'user123',
    reminderTime: DateTime.now().add(Duration(hours: 12)),
    notifyAll: false,
    notifyUsers: ['user123'],
  );

  group('ReminderRepository', () {
    test('createReminder works', () async {
      when(mockReminderRepository.createReminder('g1', reminder))
          .thenAnswer((_) async => null);

      await mockReminderRepository.createReminder('g1', reminder);

      verify(mockReminderRepository.createReminder('g1', reminder)).called(1);
    });

    test('deleteReminder works', () async {
      when(mockReminderRepository.deleteReminder('g1', 'r1'))
          .thenAnswer((_) async => null);

      await mockReminderRepository.deleteReminder('g1', 'r1');

      verify(mockReminderRepository.deleteReminder('g1', 'r1')).called(1);
    });

    test('toggleNotifyAll updates notify setting', () async {
      when(mockReminderRepository.toggleNotifyAll('g1', 'r1', true))
          .thenAnswer((_) async => null);

      await mockReminderRepository.toggleNotifyAll('g1', 'r1', true);

      verify(mockReminderRepository.toggleNotifyAll('g1', 'r1', true))
          .called(1);
    });
  });
}
