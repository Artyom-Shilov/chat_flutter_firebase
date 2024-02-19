import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:chat_flutter_firebase/auth/widgets/social_auth_button.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SocialSignIn extends StatelessWidget {
  const SocialSignIn({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final router = GoRouter.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          AuthText.additionalSignInOptionsRu,
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialAuthButton(
              content: Image.asset(
                  'assets/auth_buttons/google.png',
                  width: 25),
                onPressed: () async {
                  formKey.currentState!.reset();
                  await authCubit.signInByGoogle();
                  authCubit.state.status != AuthStatus.error
                      ? router.goNamed(Routes.chats.routeName)
                      : authCubit.resetState();
                }),
          ],
        ),
      ],
    );
  }
}
