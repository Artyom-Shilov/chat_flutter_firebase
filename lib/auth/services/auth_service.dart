import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart' as app;


abstract interface class AuthService {
  Future<void> signInByEmailAndPassword(String email, String password);
  Future<void> createUserByEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> signInByGoogle();
  Stream<app.UserInfo?> get authStateChanges;
}