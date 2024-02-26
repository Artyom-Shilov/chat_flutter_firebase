import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/widgets/input_field.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class EmailField extends StatelessWidget {
  const EmailField({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return InputField(
        hintText: AuthText.emailHintRu,
        prefixIcon: const Icon(
          Icons.email,
          color: Colors.grey),
        textController: authCubit.emailController,
        validator: authCubit.emailValidation);
  }
}
