import 'package:chat_flutter_firebase/common/app_colors.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/snackbars.dart';
import 'package:chat_flutter_firebase/common/widgets/cached_avatar.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_state.dart';
import 'package:chat_flutter_firebase/messaging/widgets/chat_pop_up_menu.dart';
import 'package:chat_flutter_firebase/messaging/widgets/messages_list.dart';
import 'package:chat_flutter_firebase/messaging/widgets/messaging_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatMessagingPage extends HookWidget {
  const ChatMessagingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messagingCubit = BlocProvider.of<MessagingCubit>(context);
    final chatInfo = messagingCubit.state.chat;
    useEffect(() {
      messagingCubit.init();
      return null;
    }, ['key']);
    final orientation = MediaQuery.orientationOf(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: orientation == Orientation.portrait ? true : false,
        appBar: AppBar(
          backgroundColor: AppColors.appBar,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(Sizes.borderRadius1))),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedAvatar(photoUrl: chatInfo.photoUrl, name: chatInfo.name, radius: 20),
              const SizedBox(width: 10),
              Text(messagingCubit.state.chat.name),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                messagingCubit.init();
              },
            ),
            const ChatPopUpMenu()
          ],
        ),
        body: BlocConsumer<MessagingCubit, MessagingState>(
            listenWhen: (prev, next) => prev.status != next.status,
            listener: (context, state) async {
              if(state.status == MessagingStatus.error) {
                SnackBars.showCommonSnackBar(state.info, context);
                messagingCubit.setStateStatus(status: MessagingStatus.ready);
              }
            },
            buildWhen: (prev, next) => prev.status != next.status,
            builder: (context, state) {
              return state.status == MessagingStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: MessagesList()),
                        MessagingInput()
                      ],
                    );
            }),
      ),
    );
  }
}
