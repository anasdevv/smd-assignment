import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smd_project/features/authentication/domain/repositories/auth_repository.dart';
import 'package:smd_project/features/authentication/data/models/user_model.dart';

import '../../mocks/mocks.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  final testUser = UserModel(
    id: '123',
    displayName: 'Test User',
    email: 'test@test.com',
    photoURL: null,
    createdAt: DateTime.now(),
    lastActive: DateTime.now(),
    groups: ['group1'],
    tasksAssigned: ['task1'],
    deviceTokens: ['token1'],
  );

  group('AuthRepository Tests', () {
    test('signInWithEmailAndPassword returns user', () async {
      when(mockAuthRepository.signInWithEmailAndPassword(
              'test@test.com', 'password'))
          .thenAnswer((_) async => testUser);

      final result = await mockAuthRepository.signInWithEmailAndPassword(
          'test@test.com', 'password');

      expect(result.id, '123');
      expect(result.email, 'test@test.com');
      expect(result.displayName, 'Test User');
    });

    test('signUpWithEmailAndPassword returns user', () async {
      when(mockAuthRepository.signUpWithEmailAndPassword(
              'test@test.com', 'password', 'Test User'))
          .thenAnswer((_) async => testUser);

      final result = await mockAuthRepository.signUpWithEmailAndPassword(
          'test@test.com', 'password', 'Test User');

      expect(result.email, 'test@test.com');
      expect(result.displayName, 'Test User');
    });

    test('signOut completes successfully', () async {
      when(mockAuthRepository.signOut()).thenAnswer((_) async => null);

      await mockAuthRepository.signOut();

      verify(mockAuthRepository.signOut()).called(1);
    });

    test('getCurrentUser returns user', () async {
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => testUser);

      final result = await mockAuthRepository.getCurrentUser();

      expect(result?.id, '123');
    });

    test('sendPasswordResetEmail completes', () async {
      when(mockAuthRepository.sendPasswordResetEmail('test@test.com'))
          .thenAnswer((_) async => null);

      await mockAuthRepository.sendPasswordResetEmail('test@test.com');

      verify(mockAuthRepository.sendPasswordResetEmail('test@test.com'))
          .called(1);
    });

    test('updateUserProfile is called correctly', () async {
      when(mockAuthRepository.updateUserProfile('Updated Name', null))
          .thenAnswer((_) async => null);

      await mockAuthRepository.updateUserProfile('Updated Name', null);

      verify(mockAuthRepository.updateUserProfile('Updated Name', null))
          .called(1);
    });
  });
}
