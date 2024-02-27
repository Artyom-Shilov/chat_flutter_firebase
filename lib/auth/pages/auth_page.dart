import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:chat_flutter_firebase/auth/widgets/auth_button.dart';
import 'package:chat_flutter_firebase/auth/widgets/change_auth_process_button.dart';
import 'package:chat_flutter_firebase/auth/widgets/email_field.dart';
import 'package:chat_flutter_firebase/auth/widgets/name_field.dart';
import 'package:chat_flutter_firebase/auth/widgets/password_field.dart';
import 'package:chat_flutter_firebase/auth/widgets/social_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AuthPage extends HookWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final orientation = MediaQuery.orientationOf(context);
    final isRegistration = authCubit.state.isRegistration;
    final GlobalKey<FormState> formKey = useRef(GlobalKey<FormState>()).value;
    return Scaffold(
        body: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<AuthCubit, AuthState>(
          listenWhen: (prev, next) => prev.status != next.status,
          listener: (context, state) {
            if (state.status == AuthStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Center(child: Text(state.message)),
              ));
              authCubit.resetState();
            }
          },
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: orientation == Orientation.portrait
                      ? MediaQuery.sizeOf(context).height
                      : 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
                  Image.asset('assets/logo.png', width: 100, height: 100),
                  const Spacer(flex: 20),
                  FractionallySizedBox(
                    widthFactor:
                        orientation == Orientation.portrait ? 0.8 : 0.5,
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isRegistration) ...[
                              const NameField(),
                              const SizedBox(height: 20)
                            ],
                            const EmailField(),
                            const SizedBox(height: 20),
                            const PasswordField(),
                            const SizedBox(height: 20),
                            SizedBox(
                                width: 200, child: AuthButton(formKey: formKey))
                          ],
                        )),
                  ),
                  const Spacer(flex: 10),
                  isRegistration ? const Row() : SocialSignIn(formKey: formKey),
                  const Spacer(flex: 15),
                  ChangeAuthProcessButton(formKey: formKey),
                  const Spacer(flex: 5)
                ],
              ),
            ),
          )),
    ));
  }
}
