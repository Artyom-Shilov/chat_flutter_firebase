import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_processing_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_processing_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:flutter/widgets.dart';

class AuthProcessingCubitImpl extends Cubit<AuthProcessingState> implements AuthProcessingCubit {
  AuthProcessingCubitImpl() : super(const AuthProcessingState());

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
  Future<void> close() async {
    passwordController.dispose();
    emailController.dispose();
    usernameController.dispose();
    await super.close();
  }

  @override
  void changeAuthProcess() {
    emit(state.copyWith(isRegistration: !state.isRegistration));
  }
}