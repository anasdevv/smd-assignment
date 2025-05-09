import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

class CreateGroup {
  final GroupRepository repository;

  CreateGroup(this.repository);

  Future<void> call(GroupEntity group) async {
    return repository.createGroup(group);
  }
}
