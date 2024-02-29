import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:chat_flutter_firebase/chats/widgets/chat_creation_dialog.dart';
import 'package:chat_flutter_firebase/chats/widgets/chat_list.dart';
import 'package:chat_flutter_firebase/common/app_colors.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/snackbars.dart';
import 'package:chat_flutter_firebase/common/widgets/app_drawer.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class ChatListPage extends HookWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatsCubit = BlocProvider.of<ChatsCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final navigation = GoRouter.of(context);
    useEffect(() {
      chatsCubit.startListenNotifications(context);
      chatsCubit.loadChatsByUserId(authCubit.user!.id).then((_) {
        if(chatsCubit.state.userChats.isNotEmpty) {
          chatsCubit.startListenUserChatsUpdates(authCubit.user!);
        }
      });
      return null;
    }, ['key']);
    return Scaffold(
        drawer: const AppDrawer(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const ChatCreationDialog();
                });
          },
        ),
        body: RefreshIndicator(
            onRefresh: () => chatsCubit.loadChatsByUserId(authCubit.user!.id),
            child: CustomScrollView(slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: AppColors.appBar,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(Sizes.borderRadius1))),
                title: const Text(ChatTexts.chatListAppBarTitleRu),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      navigation.goNamed(Routes.search.routeName);
                    },
                  )
                ],
              ),
              BlocConsumer<ChatsCubit, ChatsState>(
                listener: (context, state) {
                  if (state.status == ChatsStatus.error) {
                    SnackBars.showCommonSnackBar(state.message, context);
                    chatsCubit.setStateStatus(status: ChatsStatus.ready);
                    chatsCubit.startListenUserChatsUpdates(authCubit.user!);
                  }
                },
                builder: (context, state) {
                  if (state.status == ChatsStatus.loading) {
                    return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()));
                  }
                  return state.userChats.isEmpty
                      ? const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: Card(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(ChatTexts.noUserChatsMessageRu),
                              )),
                            ),
                          ),
                        )
                      : const ChatList(); //list
                },
              )
            ])));
  }
}
