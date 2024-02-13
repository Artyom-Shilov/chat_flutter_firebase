import 'package:chat_flutter_firebase/app_models/app_user.dart';

abstract interface class AuthService {
  Future<void> signInByEmailAndPassword(String email, String password);
  Future<void> createUserByEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> signInByGoogle();
  Stream<AppUser?> authStateChanges();
}