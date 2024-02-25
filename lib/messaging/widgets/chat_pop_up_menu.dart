import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum MenuItems {
  leaveRu(PopUpMenuTexts.leaveChatRu, Icons.logout_rounded);
  const MenuItems(this.text, this.icon);
  final String text;
  final IconData icon;
}

class ChatPopUpMenu extends StatelessWidget {
  const ChatPopUpMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messagingCubit = BlocProvider.of<MessagingCubit>(context);
    final chatsCubit = BlocProvider.of<ChatsCubit>(context);
    final navigation = GoRouter.of(context);
    return PopupMenuButton<MenuItems>(onSelected: (MenuItems item) async {
      switch (item) {
        case MenuItems.leaveRu: {
            await chatsCubit.leaveChat(messagingCubit.state.chat,
                BlocProvider.of<AuthCubit>(context).user!);
            chatsCubit.state.status != ChatsStatus.error
                ? navigation.pop()
                : null;
        }
      }
    }, itemBuilder: (BuildContext context) {
          return [
            for(MenuItems item in MenuItems.values)
              PopupMenuItem<MenuItems>(
              value: item,
              child: Row(
                children: [
                  Icon(item.icon),
                  const SizedBox(width: 5),
                  Text(item.text),
                ],
              ),
              )
          ];
    });
  }
}
