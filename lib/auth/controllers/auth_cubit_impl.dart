import 'dart:async';
import 'dart:developer';

import 'package:chat_flutter_firebase/app_models/user_info.dart' as app_models;
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:chat_flutter_firebase/auth/services/auth_service.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_user_info.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    userSubscription = _auth.authStateChanges().listen((firebaseAuthUser) async {
     // log('auth state subscription user: ${firebaseAuthUser.toString()}');
      if (firebaseAuthUser == null) {
       emit(state.copyWith(status: AuthStatus.signedOut, user: null, firebaseUser: null));
      } else {
        emit(state.copyWith(firebaseUser: firebaseAuthUser));
        !_receivedFirebaseUserCompleter.isCompleted
            ? _receivedFirebaseUserCompleter.complete()
            : null;
      }
    });
    stream.listen((event) {
      log('event: ${event.user?.name}');
    });
  }

  Completer<void> _receivedFirebaseUserCompleter = Completer.sync();
  final AuthService _auth;
  final NetworkService _networkService;
  final LocalStorageService _localStorage;
  final NetworkConnectivity _networkConnectivity;
  StreamSubscription<User?>? userSubscription;

  @override
  Future<void> createUserByEmailAndPassword(
      String email, String password, String? username) async {
    try {
      if (!await _checkNetworkConnection()) {
        return;
      }
      emit(state.copyWith(status: AuthStatus.loading));
      await _auth.createUserByEmailAndPassword(email, password);
      await _receivedFirebaseUserCompleter.future;
      _addUserToDatabaseIfAbsent();
      final appUser =
          app_models.UserInfo.fromFirebaseAuthUser(state.firebaseUser!)
              .copyWith(name: username);
      emit(state.copyWith(user: appUser, status: AuthStatus.signedIn));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: AuthStatus.error,
          message: AuthErrorTexts.createUserByEmailAndPasswordRu));
      return;
    } finally {
      _receivedFirebaseUserCompleter = Completer.sync();
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
      await _receivedFirebaseUserCompleter.future;
      await _addUserToDatabaseIfAbsent();
      final actualUserInfo = await _networkService.getUserInfoById(state.firebaseUser!.uid);
      emit(state.copyWith(
          user: actualUserInfo,
          status: AuthStatus.signedIn));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: AuthStatus.error,
          message: AuthErrorTexts.signInByEmailAndPasswordRu));
      return;
    } finally {
      _receivedFirebaseUserCompleter = Completer.sync();
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
      await _receivedFirebaseUserCompleter.future;
      await _addUserToDatabaseIfAbsent();
      final actualUserInfo = await _networkService.getUserInfoById(state.firebaseUser!.uid);
      log(actualUserInfo.toString());
      emit(state.copyWith(
          user: actualUserInfo,
          status: AuthStatus.signedIn));
    } catch (e, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(
          status: AuthStatus.error, message: AuthErrorTexts.signInByGoogleRu));
      return;
    } finally {
      _receivedFirebaseUserCompleter = Completer.sync();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _networkConnectivity.checkNetworkConnection()
          ? await _auth.signOut()
          : emit(state.copyWith(status: AuthStatus.signedOut, user: null, firebaseUser: null));
      await _localStorage.deleteCurrentAppUser();
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: AuthStatus.error, message: AuthErrorTexts.signOut));
      return;
    }
  }

  Future<void> _addUserToDatabaseIfAbsent() async {
    final appUser = app_models.UserInfo.fromFirebaseAuthUser(state.firebaseUser!);
    (await _networkService.getUserInfoById(state.firebaseUser!.uid)) == null
        ? await _networkService.saveUser(appUser)
        : null;
    (await _localStorage.getSavedAppUser()) == null
       ? await _localStorage.saveCurrentAppUser(LocalUserInfo.fromUserInfo(appUser))
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
  app_models.UserInfo? get user => state.user;

  @override
  Future<void> setAppUser() async {
    try {
      await _receivedFirebaseUserCompleter.future;
      emit(state.copyWith(
          status: AuthStatus.signedIn,
          user: await _networkConnectivity.checkNetworkConnection()
              ? await _networkService.getUserInfoById(state.firebaseUser!.uid)
              : app_models.UserInfo.fromLocalUserInfo(
              (await _localStorage.getSavedAppUser())!)));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(status: AuthStatus.error, message: AuthErrorTexts.setAppUser));
    }finally {
      _receivedFirebaseUserCompleter = Completer.sync();
    }
  }

  @override
  void resetState() {
    emit(state.copyWith(status: AuthStatus.signedOut, message: '', user: null));
  }

  @override
  Future<void> close() async {
    await userSubscription?.cancel();
    _receivedFirebaseUserCompleter.complete();
    await super.close();
  }
}