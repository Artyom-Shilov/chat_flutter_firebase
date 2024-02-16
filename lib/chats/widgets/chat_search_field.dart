import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShatSearchField extends StatelessWidget {
  const ShatSearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchCubit = BlocProvider.of<ChatSearchCubit>(context);
    return BlocBuilder<ChatSearchCubit, SearchState>(
      buildWhen: (prev, next) =>
          prev.chatSearchErrorText != next.chatSearchErrorText,
      builder: (context, state) => TextField(
        controller: searchCubit.chatSearchController,
        onSubmitted: (_) async {
          await searchCubit.validateChatSearch();
          if (searchCubit.state.chatSearchErrorText == null) {
            searchCubit.resetChatSearchError();
            searchCubit.searchChatsByName(searchCubit.chatSearchController.text);
          }
        },
      ),
    );
  }
}
