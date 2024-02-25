import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_processing_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;


  @override
  Widget build(BuildContext context) {
    final processingCubit = BlocProvider.of<AuthProcessingCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final router = GoRouter.of(context);
    final isRegistration = processingCubit.state.isRegistration;
    return ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            final email =
                processingCubit.emailController.text;
            final password =
                processingCubit.passwordController.text;
            final username =
                processingCubit.usernameController.text;
            isRegistration
                ? await authCubit
                .createUserByEmailAndPassword(email, password, username)
                : await authCubit
                .signInByEmailAndPassword(email, password);
            authCubit.state.status != AuthStatus.error
                ? router.goNamed(Routes.chats.routeName)
                : authCubit.resetState();
            }
        },
        child: Text(isRegistration
            ? AuthText.doRegisterRu
            : AuthText.doSignInRu));
  }
}
