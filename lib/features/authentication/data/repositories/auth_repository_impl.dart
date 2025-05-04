import 'package:smd_project/features/authentication/data/data_sources/auth_remote_data_source.dart';
import 'package:smd_project/features/authentication/data/models/user_model.dart';
import 'package:smd_project/features/authentication/domain/repositories/auth_repository.dart';
import 'package:smd_project/features/authentication/domain/repositories/user_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserRepository userRepository;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.userRepository,
  });

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential =
        await remoteDataSource.signInWithEmailAndPassword(email, password);
    final user = await userRepository.getUser(userCredential.user!.uid);
    if (user == null) {
      throw Exception('User not found in Firestore');
    }
    return user as UserModel;
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    final userCredential =
        await remoteDataSource.signUpWithEmailAndPassword(email, password);
    final user = UserModel(
      id: userCredential.user!.uid,
      displayName: name,
      email: email,
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
      groups: [],
      tasksAssigned: [],
      deviceTokens: [],
    );
    await userRepository.createUser(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = await remoteDataSource.getCurrentUser();
    if (firebaseUser == null) return null;
    final user = await userRepository.getUser(firebaseUser.uid);
    return user as UserModel;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> updateUserProfile(String name, String? photoUrl) async {
    await remoteDataSource.updateUserProfile(name, photoUrl);
    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      await userRepository.updateUser(currentUser.copyWith(
        displayName: name,
        photoURL: photoUrl,
      ));
    }
  }
}
