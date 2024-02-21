import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/common/widgets/app_drawer.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:uuid/v1.dart';

class ChatMessagingPage extends HookWidget {
  const ChatMessagingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messagingCubit = BlocProvider.of<MessagingCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    useEffect(() {
      messagingCubit.init();
      return null;
    }, ['key']);
    return Scaffold(
      appBar: AppBar(title: Text(messagingCubit.state.chat.name)),
      body: BlocConsumer<MessagingCubit, MessagingState>(
          listener: (context, state) {},
          builder: (context, state) {
            return state.status == MessagingStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : Center(child: Text(state.messages.length.toString()));
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.ice_skating),
        onPressed: () async {
          final message = Message(
              id: const UuidV1().generate(),
              senderId: authCubit.user!.id,
              type: MessageType.text,
              millisSinceEpoch: DateTime.now().millisecondsSinceEpoch,
              text: 'test');
          await messagingCubit.sendTextMessage(message);
          messagingCubit.notifyChatUsers(message, authCubit.user!);
        },
      ),
    );
  }
}
