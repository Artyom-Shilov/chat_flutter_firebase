import 'dart:async';
import 'dart:developer';

import 'package:chat_flutter_firebase/app_models/app_user.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:chat_flutter_firebase/auth/services/auth_service.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_user_info.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubitImpl extends Cubit<AuthState> implements AuthCubit {

  AuthCubitImpl({
    required AuthService authService,
    required NetworkService networkService,
    required LocalStorageService localStorageService
  })
      : _auth = authService,
        _network = networkService,
        _localStorage = localStorageService,
        super(const AuthState(status: AuthStatus.signedOut))
  {
    userSubscription = _auth.authStateChanges().listen((user) {
      log(user.toString());
      user == null
          ? emit(state.copyWith(status: AuthStatus.signedOut, user: null))
          : emit(state.copyWith(status: AuthStatus.signedIn, user: user));
    });
  }

  final AuthService _auth;
  final NetworkService _network;
  final LocalStorageService _localStorage;
  StreamSubscription<AppUser?>? userSubscription;

  @override
  Future<void> createUserByEmailAndPassword(
      String email, String password, String? username) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      await _auth.createUserByEmailAndPassword(email, password);
      if (username != null) {
        emit(state.copyWith(user: state.user!.copyWith(name: username)));
      }
      await _addUserIfAbsent();
      await _localStorage
          .saveCurrentAppUser(LocalUserInfo.fromAppUser(state.user!));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
          status: AuthStatus.error,
          message: AuthErrorTexts.createUserByEmailAndPasswordRu));
      return;
    }
  }

  @override
  Future<void> signInByEmailAndPassword(String email, String password) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      await _auth.signInByEmailAndPassword(email, password);
      await _addUserIfAbsent();
      await _localStorage
          .saveCurrentAppUser(LocalUserInfo.fromAppUser(state.user!));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
          status: AuthStatus.error,
          message: AuthErrorTexts.signInByEmailAndPasswordRu));
      return;
    }
  }

  @override
  Future<void> signInByGoogle() async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      await _auth.signInByGoogle();
      await _addUserIfAbsent();
      await _localStorage
          .saveCurrentAppUser(LocalUserInfo.fromAppUser(state.user!));
    } catch (e, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(
          status: AuthStatus.error, message: AuthErrorTexts.signInByGoogleRu));
      return;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _localStorage.deleteCurrentAppUser();
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(
          status: AuthStatus.error, message: AuthErrorTexts.signOut));
      return;
    }
  }

  @override
  AppUser? get user => state.user;

  @override
  Future<void> close() async {
    await userSubscription?.cancel();
    await super.close();
  }

  Future<void> _addUserIfAbsent() async {
    !await _network.isUserInDatabase(state.user!)
        ? await _network.addUserToDatabase(state.user!)
        : null;
  }
}