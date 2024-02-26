import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:chat_flutter_firebase/chats/widgets/chat_search_field.dart';
import 'package:chat_flutter_firebase/chats/widgets/search_result_list.dart';
import 'package:chat_flutter_firebase/common/app_colors.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatSearchPage extends StatelessWidget {
  const ChatSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchCubit = BlocProvider.of<ChatSearchCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () => searchCubit.searchChatsByName(authCubit.user!),
          child: CustomScrollView(slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: const ChatSearchField(),
              backgroundColor: AppColors.appBar,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(Sizes.borderRadius1))),
            ),
            BlocConsumer<ChatSearchCubit, SearchState>(
              listenWhen: (prev, next) => prev.status != next.status,
              listener: (context, state) {
                if (state.status == SearchStatus.error) {
                  SnackBars.showCommonSnackBar(state.message, context);
                  searchCubit.setStateStatus(
                      status: SearchStatus.done,
                      delay: const Duration(milliseconds: 500));
                }
              },
              buildWhen: (prev, next) => prev.status != next.status,
              builder: (BuildContext context, state) {
                if (state.status == SearchStatus.loading) {
                  return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state.status == SearchStatus.init) {
                  return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                          child: Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Text(ChatTexts.initSearchMessageRu),
                        ),
                      )));
                }
                return state.searchResult.isNotEmpty
                    ? const SearchResultList()
                    : const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Card(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                child: Text(ChatTexts.noChatsFoundRu),
                              )),
                        ));
              },
            ),
          ]),
        ),
      ),
    );
  }
}
