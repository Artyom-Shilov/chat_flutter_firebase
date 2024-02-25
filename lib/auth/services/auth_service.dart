import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthService {
  Future<void> signInByEmailAndPassword(String email, String password);
  Future<void> createUserByEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> signInByGoogle();
  Stream<User?> authStateChanges();
}