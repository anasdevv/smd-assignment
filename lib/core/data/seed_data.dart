// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import '../models/user_model.dart';
// import '../models/group_model.dart';
// import '../models/task_model.dart';
// import '../models/message_model.dart';
// import '../models/file_model.dart';
// import '../models/reminder_model.dart';
// import '../repositories/user_repository.dart';
// import '../repositories/group_repository.dart';
// import '../repositories/task_repository.dart';
// import '../repositories/message_repository.dart';
// import '../repositories/file_repository.dart';
// import '../repositories/reminder_repository.dart';

// class SeedData {
//   static final UserRepository _userRepository = UserRepository();
//   static final GroupRepository _groupRepository = GroupRepository();
//   static final TaskRepository _taskRepository = TaskRepository();
//   static final MessageRepository _messageRepository = MessageRepository();
//   static final FileRepository _fileRepository = FileRepository();
//   static final ReminderRepository _reminderRepository = ReminderRepository();

//   static Future<void> seedData() async {
//     try {
//       print("🚀 Starting data seeding process...");
//       print("📝 Creating sample users...");
//       final users = await _createSampleUsers();
//       if (users.isEmpty) {
//         print('❌ No users created. Exiting seed data process.');
//         return;
//       }
//       print('✅ Users created successfully! Total users: ${users.length}');

//       print("📝 Creating sample groups...");
//       final groups = await _createSampleGroups(users);
//       print('✅ Groups created successfully! Total groups: ${groups.length}');

//       print("📝 Creating sample tasks...");
//       await _createSampleTasks(groups, users);
//       print('✅ Tasks created successfully!');

//       print("📝 Creating sample messages...");
//       await _createSampleMessages(groups, users);
//       print('✅ Messages created successfully!');

//       print("📝 Creating sample files...");
//       await _createSampleFiles(groups, users);
//       print('✅ Files created successfully!');

//       print("📝 Creating sample reminders...");
//       await _createSampleReminders(groups, users);
//       print('✅ Reminders created successfully!');

//       print('🎉 Seed data creation completed successfully!');
//     } catch (e, stackTrace) {
//       print('❌ Error seeding data: $e');
//       print('Stack trace: $stackTrace');
//     }
//   }

//   static Future<List<UserModel>> _createSampleUsers() async {
//     print('📋 Preparing to create sample users...');
//     final users = [
//       UserModel(
//         id: 'user1',
//         displayName: 'John Doe',
//         email: 'john@example.com',
//         photoURL: null,
//         createdAt: DateTime.now(),
//         lastActive: DateTime.now(),
//         groups: [],
//         tasksAssigned: [],
//         deviceTokens: [],
//       ),
//       UserModel(
//         id: 'user2',
//         displayName: 'Jane Smith',
//         email: 'jane@example.com',
//         photoURL: null,
//         createdAt: DateTime.now(),
//         lastActive: DateTime.now(),
//         groups: [],
//         tasksAssigned: [],
//         deviceTokens: [],
//       ),
//       UserModel(
//         id: 'user3',
//         displayName: 'Mike Johnson',
//         email: 'mike@example.com',
//         photoURL: null,
//         createdAt: DateTime.now(),
//         lastActive: DateTime.now(),
//         groups: [],
//         tasksAssigned: [],
//         deviceTokens: [],
//       ),
//     ];

//     print('📝 Starting user creation process...');
//     for (final user in users) {
//       try {
//         print('🔄 Attempting to create user: ${user.displayName}');
//         await _userRepository.createUser(user);
//         print('✅ Successfully created user: ${user.displayName}');
//       } catch (e, stackTrace) {
//         print('❌ Error creating user ${user.displayName}: $e');
//         print('Stack trace: $stackTrace');
//         rethrow;
//       }
//     }

//     print('✅ All users created successfully!');
//     return users;
//   }

//   static Future<List<GroupModel>> _createSampleGroups(
//       List<UserModel> users) async {
//     final groups = [
//       GroupModel(
//         id: 'group1',
//         name: 'Computer Science Study Group',
//         subject: 'Computer Science',
//         description: 'Study group for CS students',
//         createdAt: DateTime.now(),
//         createdBy: users[0].id,
//         leaderId: users[0].id,
//         members: [users[0].id, users[1].id],
//         isPublic: true,
//         tags: ['CS', 'Programming', 'Algorithms'],
//       ),
//       GroupModel(
//         id: 'group2',
//         name: 'Mathematics Study Group',
//         subject: 'Mathematics',
//         description: 'Study group for math enthusiasts',
//         createdAt: DateTime.now(),
//         createdBy: users[1].id,
//         leaderId: users[1].id,
//         members: [users[1].id, users[2].id],
//         isPublic: true,
//         tags: ['Math', 'Calculus', 'Algebra'],
//       ),
//     ];

//     for (final group in groups) {
//       await _groupRepository.createGroup(group);
//       for (final memberId in group.members) {
//         await _userRepository.addGroupToUser(memberId, group.id);
//       }
//     }

//     return groups;
//   }

//   static Future<void> _createSampleTasks(
//       List<GroupModel> groups, List<UserModel> users) async {
//     final tasks = [
//       TaskModel(
//         id: 'task1',
//         title: 'Complete Assignment 1',
//         description: 'Finish the programming assignment by next week',
//         createdAt: DateTime.now(),
//         createdBy: users[0].id,
//         dueDate: DateTime.now().add(const Duration(days: 7)),
//         priority: 'high',
//         status: 'pending',
//         assignedTo: [users[1].id],
//         attachments: [],
//       ),
//       TaskModel(
//         id: 'task2',
//         title: 'Review Chapter 3',
//         description: 'Review and discuss chapter 3 of the textbook',
//         createdAt: DateTime.now(),
//         createdBy: users[1].id,
//         dueDate: DateTime.now().add(const Duration(days: 3)),
//         priority: 'medium',
//         status: 'in_progress',
//         assignedTo: [users[0].id, users[2].id],
//         attachments: [],
//       ),
//     ];

//     for (final task in tasks) {
//       await _taskRepository.createTask(groups[0].id, task);
//       for (final userId in task.assignedTo) {
//         await _userRepository.addTaskToUser(userId, task.id);
//       }
//     }
//   }

//   static Future<void> _createSampleMessages(
//       List<GroupModel> groups, List<UserModel> users) async {
//     final messages = [
//       MessageModel(
//         id: 'msg1',
//         text: 'Hello everyone! Welcome to the study group.',
//         senderId: users[0].id,
//         senderName: users[0].displayName,
//         timestamp: DateTime.now(),
//         readBy: [users[0].id],
//         attachmentUrl: null,
//         attachmentType: null,
//       ),
//       MessageModel(
//         id: 'msg2',
//         text:
//             'Thanks for creating this group! Looking forward to studying together.',
//         senderId: users[1].id,
//         senderName: users[1].displayName,
//         timestamp: DateTime.now().add(const Duration(minutes: 5)),
//         readBy: [users[1].id],
//         attachmentUrl: null,
//         attachmentType: null,
//       ),
//     ];

//     for (final message in messages) {
//       await _messageRepository.sendMessage(groups[0].id, message);
//     }
//   }

//   static Future<void> _createSampleFiles(
//       List<GroupModel> groups, List<UserModel> users) async {
//     final files = [
//       FileModel(
//         id: 'file1',
//         name: 'Lecture Notes.pdf',
//         type: 'pdf',
//         size: 1024 * 1024,
//         uploadedAt: DateTime.now(),
//         uploadedBy: users[0].id,
//         downloadUrl: 'https://www.africau.edu/images/default/sample.pdf',
//         description: 'Lecture notes from week 1',
//       ),
//       FileModel(
//         id: 'file2',
//         name: 'Assignment Guidelines.docx',
//         type: 'docx',
//         size: 512 * 1024,
//         uploadedAt: DateTime.now(),
//         uploadedBy: users[1].id,
//         downloadUrl:
//             'https://file-examples.com/wp-content/uploads/2017/02/file-sample_1MB.docx',
//         description: 'Guidelines for the upcoming assignment',
//       ),
//     ];

//     for (final file in files) {
//       await _fileRepository.createFileRecord(groups[0].id, file);
//     }
//   }

//   static Future<void> _createSampleReminders(
//       List<GroupModel> groups, List<UserModel> users) async {
//     final reminders = [
//       ReminderModel(
//         id: 'reminder1',
//         title: 'Group Meeting',
//         description: 'Weekly study group meeting',
//         createdAt: DateTime.now(),
//         createdBy: users[0].id,
//         reminderTime: DateTime.now().add(const Duration(days: 1)),
//         notifyAll: true,
//         notifyUsers: [],
//         relatedTaskId: null,
//       ),
//       ReminderModel(
//         id: 'reminder2',
//         title: 'Assignment Due',
//         description: 'Assignment 1 submission deadline',
//         createdAt: DateTime.now(),
//         createdBy: users[1].id,
//         reminderTime: DateTime.now().add(const Duration(days: 7)),
//         notifyAll: true,
//         notifyUsers: [],
//         relatedTaskId: 'task1',
//       ),
//     ];

//     for (final reminder in reminders) {
//       await _reminderRepository.createReminder(groups[0].id, reminder);
//     }
//   }
// }
