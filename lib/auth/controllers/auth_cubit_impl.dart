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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubitImpl extends Cubit<AuthState> implements AuthCubit {

  AuthCubitImpl({
    required AuthService authService,
    required NetworkService networkService,
    required LocalStorageService localStorageService,
    required NetworkConnectivity networkConnectivity,
  })  : _auth = authService,
        _networkService = networkService,
        _localStorage = localStorageService,
        _networkConnectivity = networkConnectivity,
        super(const AuthState(status: AuthStatus.signedOut)) {
    userSubscription =
        _auth.authStateChanges().listen((firebaseAuthUser) async {
      if (firebaseAuthUser == null) {
        emit(state.copyWith(
            status: AuthStatus.signedOut, user: null, firebaseUser: null));
      } else {
        emit(state.copyWith(firebaseUser: firebaseAuthUser));
        !_receivedFirebaseUserCompleter.isCompleted
            ? _receivedFirebaseUserCompleter.complete()
            : null;
      }
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
      await _auth.createUserByEmailAndPassword(email, password);
      await _receivedFirebaseUserCompleter.future;
      final appUser =
          app_models.UserInfo.fromFirebaseAuthUser(state.firebaseUser!)
              .copyWith(name: username);
      emit(state.copyWith(user: appUser, status: AuthStatus.signedIn));
      _saveUserToRemoteDatabase(appUser);
      _saveUserToLocalDatabase(appUser);
    } on FirebaseAuthException catch (e, stackTrace) {
      _handleFirebaseException(e, stackTrace);
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
      await _auth.signInByEmailAndPassword(email, password);
      await _receivedFirebaseUserCompleter.future;
      final userInfoFromFirebaseAuth =
          app_models.UserInfo.fromFirebaseAuthUser(state.firebaseUser!);
      emit(state.copyWith(
          user: userInfoFromFirebaseAuth, status: AuthStatus.signedIn));
      _networkService
          .getUserInfoById(state.firebaseUser!.uid)
          .then((userInfoFromServer) {
        emit(state.copyWith(
            user: userInfoFromServer ?? userInfoFromFirebaseAuth,
            status: AuthStatus.signedIn));
        _saveUserToLocalDatabase(
            userInfoFromServer ?? userInfoFromFirebaseAuth);
      });
    } on FirebaseAuthException catch (e, stackTrace) {
      _handleFirebaseException(e, stackTrace);
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
      final userInfoFromFirebaseAuth =
          app_models.UserInfo.fromFirebaseAuthUser(state.firebaseUser!);
      emit(state.copyWith(
          user: userInfoFromFirebaseAuth, status: AuthStatus.signedIn));
      _saveUserToRemoteDatabaseIfAbsent(state.firebaseUser!)
          .then((isNewUser) async {
        if (isNewUser) {
          _saveUserToLocalDatabase(userInfoFromFirebaseAuth);
          return userInfoFromFirebaseAuth;
        } else {
          final userInfoFromServer =
              (await _networkService.getUserInfoById(state.firebaseUser!.uid))!;
          _saveUserToLocalDatabase(userInfoFromServer);
          return userInfoFromServer;
        }
      }).then((value) =>
              emit(state.copyWith(user: value, status: AuthStatus.signedIn)));
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

  Future<bool> _saveUserToRemoteDatabaseIfAbsent(User firebaseUser) async {
    final userInfo = app_models.UserInfo.fromFirebaseAuthUser(firebaseUser);
    if (await _networkService.getUserInfoById(userInfo.id) == null) {
      await _networkService.saveUser(userInfo);
      return true;
    }
    return false;
  }

  Future<void> _saveUserToRemoteDatabase(app_models.UserInfo userInfo) async {
    await _networkService.saveUser(userInfo);
  }

  Future<void> _saveUserToLocalDatabase(app_models.UserInfo userInfo) async {
    await _localStorage
        .saveCurrentAppUser(LocalUserInfo.fromUserInfo(userInfo));
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
      emit(state.copyWith(status: AuthStatus.error, message: AuthErrorTexts.setAppUserRu));
    }finally {
      _receivedFirebaseUserCompleter = Completer.sync();
    }
  }

  _handleFirebaseException(FirebaseAuthException e, StackTrace stacktrace) {
    log(stacktrace.toString());
    if (e.code == 'invalid-credential') {
      emit(state.copyWith(
          status: AuthStatus.error,
          message: AuthErrorTexts.wrongPasswordRu));
    } else if(e.code == 'email-already-in-use') {
      emit(state.copyWith(
          status: AuthStatus.error,
          message: AuthErrorTexts.emailAlreadyInUse));
    }
      else {
      emit(state.copyWith(
          status: AuthStatus.error,
          message: AuthErrorTexts.commonAuthErrorRu));
    }
  }

  @override
  Future<void> resetState({Duration? delay}) async{
    delay != null ? await Future.delayed(delay) : null;
    emit(state.copyWith(status: AuthStatus.signedOut, message: '', user: null));
  }

  @override
  void changePasswordInputVisibility() {
    emit(state.copyWith(isPasswordInputVisible: !state.isPasswordInputVisible));
  }

  @override
  final TextEditingController emailController = TextEditingController();

  @override
  final TextEditingController passwordController = TextEditingController();

  @override
  final TextEditingController usernameController = TextEditingController();

  @override
  void clearTextControllers() {
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
  }

  @override
  String? Function(String? login) emailValidation = (value) {
    const emailPattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(emailPattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return AuthText.emailValidationErrorRu;
    }
    return null;
  };

  @override
  String? Function(String? password) passwordValidation = (value) {
    if (value == null || value.isEmpty || value.length < 6) {
      return AuthText.passwordValidationLengthErrorRu;
    }
    return null;
  };

  @override
  String? Function(String? repeatedPassword) get userNameValidation => (value) {
    if (value == null || value.isEmpty || value.length > 40) {
      return AuthText.usernameValidationLengthErrorRu;
    }
    return null;
  };


  @override
  void changeAuthProcess() {
    emit(state.copyWith(isRegistration: !state.isRegistration));
  }

  @override
  Future<void> close() async {
    await userSubscription?.cancel();
    _receivedFirebaseUserCompleter.complete();
    passwordController.dispose();
    emailController.dispose();
    usernameController.dispose();
    await super.close();
  }

  @override
  bool isRegistration() {
    return state.isRegistration;
  }
}