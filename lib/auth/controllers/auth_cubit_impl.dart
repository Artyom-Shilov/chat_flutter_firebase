import 'dart:async';
import 'dart:developer';

import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:chat_flutter_firebase/auth/services/auth_service.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_user_info.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubitImpl extends Cubit<AuthState> implements AuthCubit {

  AuthCubitImpl({
    required AuthService authService,
    required NetworkService networkService,
    required LocalStorageService localStorageService,
    required NetworkConnectivity networkConnectivity,
  })
      : _auth = authService,
        _networkService = networkService,
        _localStorage = localStorageService,
        _networkConnectivity = networkConnectivity,
        super(const AuthState(status: AuthStatus.signedOut))
  {
    userSubscription = _auth.authStateChanges().listen((user) {
      log('auth state subscription: ${user.toString()}');
      user == null
          ? emit(state.copyWith(status: AuthStatus.signedOut, user: null))
          : emit(state.copyWith(status: AuthStatus.signedIn, user: user));
    });
  }

  final AuthService _auth;
  final NetworkService _networkService;
  final LocalStorageService _localStorage;
  final NetworkConnectivity _networkConnectivity;
  StreamSubscription<UserInfo?>? userSubscription;

  @override
  Future<void> createUserByEmailAndPassword(
      String email, String password, String? username) async {
    try {
      if (!await _checkNetworkConnection()) {
        return;
      }
      emit(state.copyWith(status: AuthStatus.loading));
      await _auth.createUserByEmailAndPassword(email, password);
      await _addUserIfAbsent();
      await _localStorage
          .saveCurrentAppUser(LocalUserInfo.fromUserInfo(state.user!));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: AuthStatus.error,
          message: AuthErrorTexts.createUserByEmailAndPasswordRu));
      return;
    }
  }

  @override
  Future<void> signInByEmailAndPassword(String email, String password) async {
    try {
      if (!await _checkNetworkConnection()) {
        return;
      }
      emit(state.copyWith(status: AuthStatus.loading));
      await _auth.signInByEmailAndPassword(email, password);
      await _addUserIfAbsent();
      await _localStorage
          .saveCurrentAppUser(LocalUserInfo.fromUserInfo(state.user!));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: AuthStatus.error,
          message: AuthErrorTexts.signInByEmailAndPasswordRu));
      return;
    }
  }

  @override
  Future<void> signInByGoogle() async {
    log('googleSignIn');
    try {
      if (!await _checkNetworkConnection()) {
        return;
      }
      emit(state.copyWith(status: AuthStatus.loading));
      await _auth.signInByGoogle();
      await _addUserIfAbsent();
      await _localStorage
          .saveCurrentAppUser(LocalUserInfo.fromUserInfo(state.user!));
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
      if (!await _checkNetworkConnection()) {
        return;
      }
      await _auth.signOut();
      await _localStorage.deleteCurrentAppUser();
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: AuthStatus.error, message: AuthErrorTexts.signOut));
      return;
    }
  }

  Future<void> _addUserIfAbsent() async {
    !await _networkService.isUserInDatabase(state.user!)
        ? await _networkService.saveUser(state.user!)
        : null;
  }

  Future<bool> _checkNetworkConnection() async {
    final result = await _networkConnectivity.checkNetworkConnection();
    !result
        ? emit(state.copyWith(status: AuthStatus.error, message: AuthErrorTexts.noConnectionRU))
        : null;
    return result;
  }

  @override
  UserInfo? get user => state.user;

  @override
  void setUserFromLocalStorage(LocalUserInfo localUserInfo) {
    emit(state.copyWith(user: UserInfo.fromLocalUserInfo(localUserInfo)));
  }

  @override
  void resetState() {
    emit(state.copyWith(status: AuthStatus.signedOut, message: '', user: null));
  }

  @override
  Future<void> close() async {
    await userSubscription?.cancel();
    await super.close();
  }
}