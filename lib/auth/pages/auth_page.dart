import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_processing_cubit.dart';
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
    final processingCubit = BlocProvider.of<AuthProcessingCubit>(context);
    final orientation = MediaQuery.orientationOf(context);
    final isRegistration = processingCubit.state.isRegistration;
    final GlobalKey<FormState> formKey = useRef(GlobalKey<FormState>()).value;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                ));
              }
            },
            builder: (context, state) => state.status == AuthStatus.signedOut
                ? SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: orientation == Orientation.portrait
                              ? MediaQuery.sizeOf(context).height
                              : 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Spacer(flex: 20),
                          Image.asset('assets/logo.png',
                              width: 100, height: 100),
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
                                        width: 200,
                                        child: AuthButton(formKey: formKey))
                                  ],
                                )),
                          ),
                          const Spacer(flex: 10),
                          isRegistration
                              ? const Row()
                              : SocialSignIn(formKey: formKey),
                          const Spacer(flex: 15),
                          ChangeAuthProcessButton(formKey: formKey),
                          const Spacer(flex: 5)
                        ],
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
