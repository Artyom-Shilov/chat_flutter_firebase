import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimatedSendButton extends HookWidget {
  const AnimatedSendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messagingCubit = BlocProvider.of<MessagingCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 500));
    final curved = CurvedAnimation(parent: animationController, curve: Curves.easeInQuart);
    final widthTween =
        Tween<double>(begin: 0, end: 20).animate(curved);
    return BlocListener<MessagingCubit, MessagingState>(
      listenWhen: (prev, next) =>
          prev.isTextFieldEmpty != next.isTextFieldEmpty,
      listener: (context, state) {
        !state.isTextFieldEmpty
            ? animationController.forward()
            : animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Padding(
            padding: EdgeInsets.only(left: widthTween.value),
            child: Opacity(
                opacity: animationController.value,
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (!messagingCubit.state.isTextFieldEmpty) {
                      await messagingCubit.sendTextMessage(authCubit.user!);
                      messagingCubit.clearInput();
                    }
                  }
                )),
          );
        },
      ),
    );
  }
}
