import 'package:chat_flutter_firebase/auth/controllers/auth_processing_cubit.dart';
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
    final processingCubit = BlocProvider.of<AuthProcessingCubit>(context);
    final textStyle = Theme.of(context).textTheme.displayMedium!;
    final router = GoRouter.of(context);
    final isRegistration = processingCubit.state.isRegistration;
    return TextButton(
        child: Text(
            isRegistration ? AuthText.toLoginRu : AuthText.toRegistrationRu,
            style: textStyle.copyWith(fontSize: 16)),
        onPressed: () {
          formKey.currentState!.reset();
          processingCubit.clearTextControllers();
          processingCubit.changeAuthProcess();
          isRegistration ? router.pop() : router.goNamed(Routes.registration.routeName);
        }
    );
  }
}
