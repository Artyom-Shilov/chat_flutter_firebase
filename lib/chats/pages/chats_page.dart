import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:chat_flutter_firebase/chats/widgets/chat_creation_dialog.dart';
import 'package:chat_flutter_firebase/chats/widgets/chat_list.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/widgets/app_drawer.dart';
import 'package:chat_flutter_firebase/database_events/database_events_listening.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ChatListPage extends HookWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatsCubit = BlocProvider.of<ChatsCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final navigation = GoRouter.of(context);
    useEffect(() {
      GetIt.I.get<DatabaseEventsListening>().currentUserId =
          authCubit.user!.id;
      chatsCubit.loadChatsByUserId(authCubit.user!.id);
      return () {
        GetIt.I.get<DatabaseEventsListening>().currentUserId = null;
      };
    }, ['key']);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
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
      drawer: const AppDrawer(),
      body: BlocConsumer<ChatsCubit, ChatsState>(
        listener: (context, state) {
          if (state.status == ChatsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        },
        buildWhen: (prev, next) => prev.status != next.status,
        builder: (context, state) {
          if (state.status == ChatsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return state.userChats.isEmpty
              ? const Center(child: Text(ChatTexts.noUserChatsMessageRu))
              : const ChatList(); //list
        },
      ),
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
    );
  }
}
