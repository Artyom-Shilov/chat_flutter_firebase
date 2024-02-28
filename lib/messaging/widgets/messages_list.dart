import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_state.dart';
import 'package:chat_flutter_firebase/messaging/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final messagingCubit = BlocProvider.of<MessagingCubit>(context);
    return Padding(
      padding: const EdgeInsets.all(Sizes.verticalInset2),
      child: BlocBuilder<MessagingCubit, MessagingState>(
          buildWhen: (prev, next) =>
          prev.messages != next.messages || prev.members.length != next.members.length,
        builder: (context, state) {
          final messages = messagingCubit.messages;
          return ListView.separated(
              reverse: true,
              controller: messagingCubit.messageListController,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 40),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final senderInfo = messagingCubit.state.members.
                    firstWhereOrNull((element) => element.id == message.senderId);
                return ChatMessage(
                    message: message,
                    senderInfo: senderInfo,
                    isAnotherMember: senderInfo?.id != authCubit.user!.id);
              });
        },
      ),
    );
  }
}
