import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/widgets/input_field.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_state.dart';
import 'package:chat_flutter_firebase/messaging/widgets/messages_list.dart';
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
          buildWhen: (prev, next) => prev.status != next.status,
          builder: (context, state) {
            return state.status == MessagingStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: MessagesList()),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                            children: [
                          Flexible(
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              child: InputField(
                                  textController: messagingCubit.messageInputController,
                                  hintText: 'Сообщение'),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () async {
                              await messagingCubit.sendTextMessage(authCubit.user!);
                            },
                          ),
                              IconButton(
                                icon: const Icon(Icons.image),
                                onPressed: () async {
                                  await messagingCubit.sendImageFromGallery(authCubit.user!);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.video_collection),
                                onPressed: () async {
                                  await messagingCubit.sendVideoFromGallery(authCubit.user!);
                                },
                              )
                        ]),
                      )
                    ],
                  );
          }),
    );
  }
}
