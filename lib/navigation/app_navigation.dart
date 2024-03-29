import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/auth/pages/auth_page.dart';
import 'package:chat_flutter_firebase/chats/pages/chats_page.dart';
import 'package:chat_flutter_firebase/chats/pages/chats_search_page.dart';
import 'package:chat_flutter_firebase/common/pages/initial_screen.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/database_events/database_events_listening.dart';
import 'package:chat_flutter_firebase/files_handling/database_file_handler.dart';
import 'package:chat_flutter_firebase/files_handling/local_file_handler.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit_impl.dart';
import 'package:chat_flutter_firebase/messaging/pages/chat_messaging_page.dart';
import 'package:chat_flutter_firebase/notifications/notification_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {

  static GoRouter goRouter =
      GoRouter(debugLogDiagnostics: true, initialLocation: '/', routes: [
    GoRoute(path: '/',
       builder: (context, state) => const InitialScreen(),
    ),
    GoRoute(
        path: '/${Routes.signIn.routeName}',
        name: Routes.signIn.routeName,
        pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: const Duration(seconds: 1),
            key: state.pageKey,
            child: const AuthPage(),
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(
                    opacity: animation,
                    child: child)),
        routes: [
          GoRoute(
              path: Routes.registration.routeName,
              name: Routes.registration.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const AuthPage(),
                  transitionsBuilder: (context, animation, _, child) =>
                      SlideTransition(
                          position: animation.drive(Tween<Offset>(
                              begin: const Offset(1, 0), end: Offset.zero)),
                          child: child)))
        ]),
    GoRoute(
        path: '/${Routes.chats.routeName}',
        name: Routes.chats.routeName,
        pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: const Duration(seconds: 1),
            key: state.pageKey,
            child: const ChatListPage(),
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(
                    opacity: animation, child: child)),
        routes: [
          GoRoute(
              path: Routes.search.routeName,
              name: Routes.search.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ChatSearchPage(),
                  transitionsBuilder: (context, animation, _, child) =>
                      SlideTransition(
                          position: animation.drive(Tween<Offset>(
                              begin: const Offset(1, 0), end: Offset.zero)),
                          child: child))),
          GoRoute(
              path: '${Routes.messaging.routeName}/:${Params.chatName.name}',
              name: Routes.messaging.routeName,
              builder: (context, state) => BlocProvider<MessagingCubit>(
                  create: (context) => MessagingCubitImpl(
                      chat: state.extra as ChatInfo,
                      networkConnectivity: GetIt.I.get<NetworkConnectivity>(),
                      localStorageService: GetIt.I.get<LocalStorageService>(),
                      networkService: GetIt.I.get<NetworkService>(),
                      eventsListening: GetIt.I.get<DatabaseEventsListening>(),
                      databaseFileHandler: GetIt.I.get<DatabaseFileHandler>(),
                      localFileHandler: GetIt.I.get<LocalFileHandler>(),
                      notificationService: GetIt.I.get<NotificationService>()),
                  child: const ChatMessagingPage()))
        ]),
  ]);
}

enum Routes {
  signIn('sign_in'),
  registration('register'),
  chats('chats'),
  search('search'),
  messaging('messaging');

  const Routes(this.routeName);

  final String routeName;
}

enum Params {
  chatName,
}
