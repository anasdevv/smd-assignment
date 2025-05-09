import 'package:smd_project/features/groups/domain/repositories/group_repository.dart';

class JoinGroup {
  final GroupRepository repository;

  JoinGroup(this.repository);

  Future<void> call(String groupId, String userId) async {
    await repository.addMember(groupId, userId);
  }
}