import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password);
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> updateUserProfile(String name, String? photoUrl);
}
