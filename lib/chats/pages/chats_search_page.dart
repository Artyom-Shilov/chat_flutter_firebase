import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatSearchPage extends StatelessWidget {
  const ChatSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Поиск чата'),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(Sizes.borderRadius1))),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
              child: TextField(
              ),
            ),
          ),
        ),
        body: BlocBuilder<ChatSearchCubit, SearchState>(
          buildWhen: (prev, next) =>
              prev.status != next.status ||
              prev.searchResult != next.searchResult,
          builder: (BuildContext context, state) {
            return SearchResultList();
          },
        ),
      ),
    );
  }
}
