import 'package:firebase_auth/firebase_auth.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> updateUserProfile(String name, String? photoUrl) async {
    await _auth.currentUser?.updateDisplayName(name);
    if (photoUrl != null) {
      await _auth.currentUser?.updatePhotoURL(photoUrl);
    }
  }
}
