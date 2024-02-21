import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/widgets/circle_cashed_network_image.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatsCubit = BlocProvider.of<ChatsCubit>(context);
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.verticalInset1),
      child: BlocBuilder<ChatsCubit, ChatsState>(
        buildWhen: (prev, next) => prev.userChats != next.userChats,
        builder: (context, state) {
          return ListView.separated(
          itemCount: state.userChats.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: Sizes.verticalInset2),
          itemBuilder: (context, index) {
            final chat = state.userChats[index];
            final lastUser = chat.lastUserNameText;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Sizes.horizontalInset2),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(Sizes.borderRadius1)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: Sizes.verticalInset2),
                  child: ListTile(
                      onTap: () {
                        GoRouter.of(context).goNamed(Routes.messaging.routeName,
                            pathParameters: {Params.chatName.name: chat.name},
                            extra: chat);
                      },
                      leading: chat.photoUrl == null
                          ? CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).primaryColor.withOpacity(0.5),
                              radius: 30,
                              child: Center(
                                      child: Text(
                                      chat.name[0].toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )))
                          : CircleCashedNetworkImage(
                              url: chat.photoUrl!, radius: 30),
                      title: Text(chat.name),
                      subtitle: lastUser != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${chat.lastUserNameText}:'),
                                const SizedBox(width: 10),
                                Text(chat.lastMessageText ?? '')
                              ],
                            )
                          : null),
                ),
              ),
            );
          },
        );},
      ),
    );
  }
}
