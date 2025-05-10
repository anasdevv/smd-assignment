import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smd_project/features/tasks/domain/repositories/task_repository.dart';
import 'package:smd_project/features/tasks/data/models/task_model.dart';

import '../../mocks/mocks.mocks.dart';

void main() {
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
  });

  final TaskModel testTask = TaskModel(
    id: 't1',
    title: 'Study Flutter',
    description: 'Complete UI section',
    createdAt: DateTime.now(),
    createdBy: 'user123',
    dueDate: DateTime.now().add(const Duration(days: 2)),
    priority: 'High',
    status: 'incomplete',
    assignedTo: ['user123'],
    attachments: [],
  );

  group('TaskRepository', () {
    test('createTask adds a task to a group', () async {
      when(mockTaskRepository.createTask('g1', any))
          .thenAnswer((_) async => null);

      await mockTaskRepository.createTask('g1', testTask);

      verify(mockTaskRepository.createTask('g1', testTask)).called(1);
    });

    test('updateTask modifies task in group', () async {
      when(mockTaskRepository.updateTask('g1', testTask))
          .thenAnswer((_) async => null);

      await mockTaskRepository.updateTask('g1', testTask);

      verify(mockTaskRepository.updateTask('g1', testTask)).called(1);
    });

    test('deleteTask removes task from group', () async {
      when(mockTaskRepository.deleteTask('g1', 't1'))
          .thenAnswer((_) async => null);

      await mockTaskRepository.deleteTask('g1', 't1');

      verify(mockTaskRepository.deleteTask('g1', 't1')).called(1);
    });

    test('getTask returns a task by ID', () async {
      when(mockTaskRepository.getTask('g1', 't1'))
          .thenAnswer((_) async => testTask);

      final result = await mockTaskRepository.getTask('g1', 't1');

      expect(result, isA<TaskModel>());
      expect(result?.title, 'Study Flutter');
    });

    test('updateTaskStatus changes status', () async {
      when(mockTaskRepository.updateTaskStatus('g1', 't1', 'complete'))
          .thenAnswer((_) async => null);

      await mockTaskRepository.updateTaskStatus('g1', 't1', 'complete');

      verify(mockTaskRepository.updateTaskStatus('g1', 't1', 'complete'))
          .called(1);
    });

    test('assignTask assigns user to task', () async {
      when(mockTaskRepository.assignTask('g1', 't1', 'user123'))
          .thenAnswer((_) async => null);

      await mockTaskRepository.assignTask('g1', 't1', 'user123');

      verify(mockTaskRepository.assignTask('g1', 't1', 'user123')).called(1);
    });

    test('unassignTask removes user from task', () async {
      when(mockTaskRepository.unassignTask('g1', 't1', 'user123'))
          .thenAnswer((_) async => null);

      await mockTaskRepository.unassignTask('g1', 't1', 'user123');

      verify(mockTaskRepository.unassignTask('g1', 't1', 'user123')).called(1);
    });

    test('addTaskAttachment adds a file', () async {
      when(mockTaskRepository.addTaskAttachment('g1', 't1', 'url'))
          .thenAnswer((_) async => null);

      await mockTaskRepository.addTaskAttachment('g1', 't1', 'url');

      verify(mockTaskRepository.addTaskAttachment('g1', 't1', 'url')).called(1);
    });

    test('removeTaskAttachment removes a file', () async {
      when(mockTaskRepository.removeTaskAttachment('g1', 't1', 'url'))
          .thenAnswer((_) async => null);

      await mockTaskRepository.removeTaskAttachment('g1', 't1', 'url');

      verify(mockTaskRepository.removeTaskAttachment('g1', 't1', 'url'))
          .called(1);
    });
  });
}
