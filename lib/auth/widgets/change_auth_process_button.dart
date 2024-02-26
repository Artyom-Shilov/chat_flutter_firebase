import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangeAuthProcessButton extends StatelessWidget {
  const ChangeAuthProcessButton({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final textStyle = Theme.of(context).textTheme.displayMedium!;
    final router = GoRouter.of(context);
    return TextButton(
        child: Text(
            authCubit.isRegistration()
                ? AuthText.toLoginRu
                : AuthText.toRegistrationRu,
            style: textStyle.copyWith(fontSize: 16)),
        onPressed: () {
          formKey.currentState!.reset();
          authCubit.clearTextControllers();
          authCubit.changeAuthProcess();
          authCubit.isRegistration()
              ? router.goNamed(Routes.registration.routeName)
              : router.pop();
        });
  }
}
