import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
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
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final router = GoRouter.of(context);
    final isRegistration = authCubit.state.isRegistration;
    return ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            final email =
                authCubit.emailController.text;
            final password =
                authCubit.passwordController.text;
            final username =
                authCubit.usernameController.text;
            isRegistration
                ? await authCubit.createUserByEmailAndPassword(
                    email, password, username)
                : await authCubit.signInByEmailAndPassword(email, password);
            if (authCubit.state.status != AuthStatus.error) {
              router.goNamed(Routes.chats.routeName);
              authCubit.changeAuthProcess();
              authCubit.clearTextControllers();
            }
          }
        },
        child: Text(isRegistration
            ? AuthText.doRegisterRu
            : AuthText.doSignInRu));
  }
}
