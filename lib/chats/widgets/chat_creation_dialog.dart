import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatCreationDialog extends StatelessWidget {
  const ChatCreationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatsCubit = BlocProvider.of<ChatsCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final navigation = GoRouter.of(context);
    return AlertDialog(
      content: BlocBuilder<ChatsCubit, ChatsState>(
        buildWhen: (prev, next) => prev.chatCreationErrorText != next.chatCreationErrorText,
        builder: (context, state) => TextField(
          controller: chatsCubit.chatCreationController,
          decoration: InputDecoration(
              hintText: ChatTexts.doEnterChatNameRu,
              errorText: state.chatCreationErrorText),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () {
              navigation.pop();
              chatsCubit.clearChatName();
              chatsCubit.resetChatCreationError();
            },
            child: const Text(ChatTexts.cancelRu)),
        ElevatedButton(
            onPressed: () async {
              await chatsCubit.validateChatName();
              if (chatsCubit.state.chatCreationErrorText == null) {
                navigation.pop();
                chatsCubit.createChat(ChatInfo(
                    name: chatsCubit.chatCreationController.text,
                    adminId: authCubit.user!.id),
                    authCubit.user!);
                chatsCubit.resetChatCreationError();
                chatsCubit.clearChatName();
              }
            },
            child: const Text(ChatTexts.createRu))
      ],
    );
  }
}
