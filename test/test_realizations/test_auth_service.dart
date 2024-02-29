import 'dart:async';

import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/auth/services/auth_service.dart';

import '../test_consts.dart';

class TestAuthService implements AuthService {
  final StreamController<UserInfo?> streamController = StreamController();

  @override
  Stream<UserInfo?> get authStateChanges => streamController.stream;

  @override
  Future<void> createUserByEmailAndPassword(
      String email, String password) async {
    streamController.add(UserInfo(
      id: TestConsts.userId,
      email: email,
    ));
  }

  @override
  Future<void> signInByEmailAndPassword(String email, String password) async {
    streamController.add(UserInfo(
      id: TestConsts.userId,
      email: email,
    ));
  }

  @override
  Future<void> signInByGoogle() async {
    streamController.add(UserInfo(
      id: TestConsts.userId,
      email: TestConsts.email,
    ));
  }

  @override
  Future<void> signOut() async {
    streamController.add(null);
  }
}
