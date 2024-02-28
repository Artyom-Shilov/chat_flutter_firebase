import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';

enum MenuItems {
  leaveRu(PopUpMenuTexts.leaveChatRu, Icons.logout_rounded),
  enableNotifications(
      PopUpMenuTexts.enableNotificationsRu, Icons.notification_add),
  disableNotifications(
      PopUpMenuTexts.disableNotificationsRu, Icons.notifications_off);

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
    return BlocBuilder<MessagingCubit, MessagingState>(
      buildWhen: (prev, next) => prev.members != next.members,
      builder: (context, state) {
        final user = messagingCubit.state.members.firstWhereOrNull((element) =>
        element.id == BlocProvider.of<AuthCubit>(context).user!.id);
       return PopupMenuButton<MenuItems>(onSelected: (MenuItems item) async {
          switch (item) {
            case MenuItems.leaveRu:
              {
                await chatsCubit.leaveChat(messagingCubit.state.chat,
                    BlocProvider
                        .of<AuthCubit>(context)
                        .user!);
                chatsCubit.state.status != ChatsStatus.error
                    ? navigation.pop()
                    : null;
              }
            case MenuItems.enableNotifications:
              {
                if (user == null) {
                  return;
                }
                await messagingCubit.changeNotificationsStatus(
                    user.copyWith(isNotificationsEnabled: true));
              }
            case MenuItems.disableNotifications:
              {
                await messagingCubit.changeNotificationsStatus(
                    user!.copyWith(isNotificationsEnabled: false));
              }
          }
        }, itemBuilder: (BuildContext context) {
          return [
            user?.isNotificationsEnabled ?? false
                ? PopupMenuItem<MenuItems>(
              value: MenuItems.disableNotifications,
              child: Row(
                children: [
                  Icon(MenuItems.disableNotifications.icon),
                  const SizedBox(width: 5),
                  Text(MenuItems.disableNotifications.text),
                ],
              ),
            )
                : PopupMenuItem<MenuItems>(
              value: MenuItems.enableNotifications,
              child: Row(
                children: [
                  Icon(MenuItems.enableNotifications.icon),
                  const SizedBox(width: 5),
                  Text(MenuItems.enableNotifications.text),
                ],
              ),
            ),
            PopupMenuItem<MenuItems>(
                value: MenuItems.leaveRu,
                child: Row(
                  children: [
                    Icon(MenuItems.leaveRu.icon),
                    const SizedBox(width: 5),
                    Text(MenuItems.leaveRu.text),
                  ],
                ))
          ];
        });
      });
  }
}
