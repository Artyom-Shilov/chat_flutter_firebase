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
    final offsetTween =
        Tween<Offset>(begin: Offset.zero, end: const Offset(20, 0)).animate(curved);
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
          return Transform.translate(
            offset: offsetTween.value,
            child: Opacity(
                opacity: animationController.value,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.send),
                  onPressed: () async {
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
