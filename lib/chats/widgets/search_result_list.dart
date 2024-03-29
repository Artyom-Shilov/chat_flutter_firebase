import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/widgets/cached_avatar.dart';
import 'package:chat_flutter_firebase/common/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchCubit = BlocProvider.of<ChatSearchCubit>(context);
    final chatsCubit = BlocProvider.of<ChatsCubit>(context);
    final searchResults = searchCubit.searchResult;
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return SliverList.separated(
      itemCount: searchResults.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: Sizes.verticalInset2),
      itemBuilder: (context, index) {
        final result = searchResults[index];
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
                    leading: CachedAvatar(
                        photoUrl: result.chat.photoUrl,
                        name: result.chat.name,
                        placeholderWidget: LoadingAnimation(
                            color: Theme.of(context).primaryColor),
                        radius: 30),
                    title: Text(result.chat.name),
                    trailing: BlocBuilder<ChatSearchCubit, SearchState>(
                      buildWhen: (prev, next) =>
                          prev.searchResult != next.searchResult,
                      builder: (context, state) {
                        return state.searchResult[index].isJoined
                            ? const Text(ChatTexts.userAlreadyJoinedMarkRu)
                            : TextButton(
                                onPressed: () {
                                  searchCubit.joinChat(
                                      result.chat, authCubit.user!);
                                  if (chatsCubit.state.userChats.isEmpty) {
                                    chatsCubit.startListenUserChatsUpdates(
                                        authCubit.user!);
                                    searchCubit.startListeningChatUpdates(
                                        authCubit.user!);
                                  }
                                },
                                child: const Text(ChatTexts.doJoinRu));
                      },
                    )),
              ),
            ));
      },
    );
  }
}
