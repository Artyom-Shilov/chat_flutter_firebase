import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatsCubit = BlocProvider.of<ChatsCubit>(context);
    final chats = chatsCubit.state.userChats;
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.verticalInset1),
      child: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (context, index) => SizedBox(height: Sizes.verticalInset2),
        itemBuilder: (context, index) {
          final chat = chats[index];
          final lastUser = chat.lastUserNameText;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.horizontalInset2),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(Sizes.borderRadius1)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.verticalInset2),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                      radius: 30,
                      backgroundImage: chat.photoUrl != null
                          ? Image.network(chat.photoUrl!).image
                          : null,
                      child: chat.photoUrl == null
                          ? Center(child: Text(chats[index].name[0].toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),))
                          : null,
                    ),
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
      ),
    );
  }
}
