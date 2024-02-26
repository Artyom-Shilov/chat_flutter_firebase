import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:chat_flutter_firebase/auth/widgets/input_field.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, next) =>
          prev.isPasswordInputVisible != next.isPasswordInputVisible,
      builder: (context, state) => InputField(
          hintText: AuthText.passwordHintRu,
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.grey),
          obscureText: !state.isPasswordInputVisible,
          suffixIcon: GestureDetector(
            onTap: () => authCubit.changePasswordInputVisibility(),
            child: Icon(
              state.isPasswordInputVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
          ),
          textController: authCubit.passwordController,
          validator: authCubit.passwordValidation),
    );
  }
}
