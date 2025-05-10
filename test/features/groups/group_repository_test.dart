import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smd_project/features/groups/domain/repositories/group_repository.dart';
import 'package:smd_project/features/groups/data/models/group_model.dart';
import '../../mocks/mocks.mocks.dart';

void main() {
  late MockGroupRepository mockGroupRepository;

  setUp(() {
    mockGroupRepository = MockGroupRepository();
  });

  final GroupModel testGroup = GroupModel(
    id: 'g1',
    name: 'Flutter Group',
    subject: 'Mobile Development',
    description: 'Group for Flutter study',
    createdAt: DateTime.now(),
    createdBy: 'user123',
    leaderId: 'user123',
    isPublic: true,
    isJoined: true,
    members: ['user123', 'user456'],
    tags: ['flutter', 'firebase'],
  );

  group('GroupRepository', () {
    test('createGroup adds a group', () async {
      when(mockGroupRepository.createGroup(any)).thenAnswer((_) async => null);

      await mockGroupRepository.createGroup(testGroup);

      verify(mockGroupRepository.createGroup(testGroup)).called(1);
    });

    test('getGroupsByUser returns list of groups', () async {
      when(mockGroupRepository.getGroupsByUser('user123'))
          .thenAnswer((_) async => [testGroup]);

      final result = await mockGroupRepository.getGroupsByUser('user123');

      final castedResult = result.cast<GroupModel>();

      expect(castedResult, isA<List<GroupModel>>());
      expect(castedResult.first.name, 'Flutter Group');
    });

    test('joinGroup adds user to group', () async {
      when(mockGroupRepository.joinGroupByCode('g1', 'user789'))
          .thenAnswer((_) async => null);

      await mockGroupRepository.joinGroupByCode('g1', 'user789');

      verify(mockGroupRepository.joinGroupByCode('g1', 'user789')).called(1);
    });
  });
}
