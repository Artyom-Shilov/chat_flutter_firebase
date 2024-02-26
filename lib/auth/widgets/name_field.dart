import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/widgets/input_field.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameField extends StatelessWidget {
  const NameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return InputField(
        hintText: AuthText.usernameHintRu,
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.grey,
        ),
        textController: authCubit.usernameController,
        validator: authCubit.userNameValidation);
  }
}