import 'dart:developer';

import 'package:chat_flutter_firebase/auth/pages/auth_page.dart';
import 'package:chat_flutter_firebase/chat_list/pages/chats_page.dart';
import 'package:chat_flutter_firebase/common/initial_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {

  late bool isUserWasSignIn;

  GoRouter goRouter = GoRouter(
          debugLogDiagnostics: true,
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const InitialScreen()
            ),
            GoRoute(
                path: '/${Routes.signIn.routeName}',
                name: Routes.signIn.routeName,
                builder: (context, state) => const AuthPage(),
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
                                      begin: const Offset(1, 0),
                                      end: Offset.zero)),
                                  child: child)))
                ]),
            GoRoute(
                path: '/${Routes.chats.routeName}',
                name: Routes.chats.routeName,
                builder: (context, state) => const ChatListPage())
          ]);
}

enum Routes {
  signIn('sign_in'),
  registration('register'),
  chats('chats');

  const Routes(this.routeName);

  final String routeName;
}
