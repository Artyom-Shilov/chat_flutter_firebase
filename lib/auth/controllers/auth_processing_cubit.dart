import 'package:chat_flutter_firebase/auth/controllers/auth_processing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract interface class AuthProcessingCubit extends Cubit<AuthProcessingState> {
  AuthProcessingCubit(super.initialState);

  TextEditingController get emailController;
  TextEditingController get passwordController;
  TextEditingController get usernameController;

  String? Function(String? login) get emailValidation;
  String? Function(String? password) get passwordValidation;
  String? Function(String? repeatedPassword) get userNameValidation;

  void clearTextControllers();
  void changePasswordInputVisibility();
  void changeAuthProcess();
}