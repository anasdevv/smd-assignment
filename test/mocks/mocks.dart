import 'package:mockito/annotations.dart';
import 'package:smd_project/features/authentication/domain/repositories/auth_repository.dart';
import 'package:smd_project/features/groups/domain/repositories/group_repository.dart';
import 'package:smd_project/features/tasks/domain/repositories/task_repository.dart';
import 'package:smd_project/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:smd_project/features/messages/domain/repositories/message_repository.dart';

@GenerateMocks([
  AuthRepository,
  GroupRepository,
  TaskRepository,
  ReminderRepository,
  MessageRepository
])
void main() {}
