import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:chat_flutter_firebase/chats/widgets/chat_search_field.dart';
import 'package:chat_flutter_firebase/chats/widgets/search_result_list.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
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
            preferredSize: Size.fromHeight(70),
            child: Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
              child: ChatSearchField()
            ),
          ),
        ),
        body: BlocConsumer<ChatSearchCubit, SearchState>(
          listener: (context, state) {
            if (state.status == SearchStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
              ));
            }
          },
          buildWhen: (prev, next) => prev.status != next.status,
          builder: (BuildContext context, state) {
            if(state.status == SearchStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == SearchStatus.init) {
              return const Center(child: Text(ChatTexts.initSearchMessageRu));
            }
            return state.searchResult.isNotEmpty
                ? const SearchResultList()
                : const Center(child: Text(ChatTexts.noChatsFoundRu));
          },
        ),
      ),
    );
  }
}
