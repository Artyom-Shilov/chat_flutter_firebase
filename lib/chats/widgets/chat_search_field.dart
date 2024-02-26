import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatSearchField extends StatelessWidget {
  const ChatSearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final searchCubit = BlocProvider.of<ChatSearchCubit>(context);
    return TextField(
      controller: searchCubit.chatSearchController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: ChatTexts.chatSearchHintRu),
      onSubmitted: (_) async {
        await searchCubit.validateChatSearch();
        if (searchCubit.state.status != SearchStatus.error) {
          searchCubit.searchChatsByName(authCubit.user!);
        }
      },
    );
  }
}
