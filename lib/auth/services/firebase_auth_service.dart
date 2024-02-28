import 'dart:async';

import 'package:chat_flutter_firebase/app_models/user_info.dart' as app;
import 'package:chat_flutter_firebase/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService implements AuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();

  final _firebaseUserToUserInfoTransformer =
      StreamTransformer<User?, app.UserInfo?>.fromHandlers(
          handleData: (data, sink) {
    data == null
        ? sink.add(null)
        : sink.add(app.UserInfo.fromFirebaseAuthUser(data));
  });

  @override
  Stream<app.UserInfo?> get authStateChanges => _firebaseAuth
      .authStateChanges()
      .transform(_firebaseUserToUserInfoTransformer);

  @override
  Future<void> createUserByEmailAndPassword(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
    Future<void> signInByGoogle() async {
      await _firebaseAuth.signInWithProvider(_googleAuthProvider);
    }

    @override
    Future<void> signInByEmailAndPassword(String email, String password) async {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }

    @override
    Future<void> signOut() async {
      await _firebaseAuth.signOut();
    }
}