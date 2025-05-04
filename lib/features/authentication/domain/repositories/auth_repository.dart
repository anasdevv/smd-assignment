import 'package:smd_project/features/authentication/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(
      String email, String password, String name);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> updateUserProfile(String name, String? photoUrl);
}
