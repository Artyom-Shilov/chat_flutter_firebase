import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:chat_flutter_firebase/common/date_formatting.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/widgets/cached_avatar.dart';
import 'package:chat_flutter_firebase/common/widgets/loading_animation.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatsCubit = BlocProvider.of<ChatsCubit>(context);
    return SliverPadding(
      padding: const EdgeInsets.only(top: Sizes.verticalInset1),
      sliver: BlocBuilder<ChatsCubit, ChatsState>(
        buildWhen: (prev, next) => prev.userChats != next.userChats,
        builder: (context, state) {
          final chats = chatsCubit.userChats;
          return SliverList.separated(
            itemCount: chats.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: Sizes.verticalInset2),
            itemBuilder: (context, index) {
              final chat = chats[index];
              final lastUser = chat.lastUserNameText;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Sizes.horizontalInset2),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(Sizes.borderRadius1)),
                  child: ListTile(
                      onTap: () {
                        GoRouter.of(context).goNamed(Routes.messaging.routeName,
                            pathParameters: {Params.chatName.name: chat.name},
                            extra: chat);
                      },
                        leading: CachedAvatar(
                            photoUrl: chat.photoUrl,
                            name: chat.name,
                            placeholderWidget: LoadingAnimation(
                                color: Theme.of(context).primaryColor),
                            radius: 30),
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(chat.name),
                              if (chat.lastMessageTime != null)
                                Text(DateFormatter.I
                                    .formatDate(chat.lastMessageTime!))
                            ]),
                        subtitle: lastUser != null
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                      child: Text(
                                    '${chat.lastUserNameText}:',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      chat.lastMessageText == null
                                          ? ''
                                          : (chat.lastMessageText!.length > 10
                                              ? '${chat.lastMessageText!.substring(0, 10)}...'
                                              : chat.lastMessageText!),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              )
                            : null),
                  ),
                );
              },
          );
        },
      ),
    );
  }
}
