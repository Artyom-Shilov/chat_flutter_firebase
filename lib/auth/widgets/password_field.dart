import 'package:chat_flutter_firebase/auth/controllers/auth_processing_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_processing_state.dart';
import 'package:chat_flutter_firebase/auth/widgets/input_field.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final processingCubit = BlocProvider.of<AuthProcessingCubit>(context);
    //TODO May be animate password visibility switch
    return BlocBuilder<AuthProcessingCubit, AuthProcessingState>(
      buildWhen: (prev, next) =>
          prev.isPasswordInputVisible != next.isPasswordInputVisible,
      builder: (context, state) => InputField(
          hintText: AuthText.passwordHintRu,
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.grey),
          obscureText: !state.isPasswordInputVisible,
          suffixIcon: GestureDetector(
            onTap: () => processingCubit.changePasswordInputVisibility(),
            child: Icon(
              state.isPasswordInputVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
          ),
          textController: processingCubit.passwordController,
          validator: processingCubit.passwordValidation),
    );
  }
}
