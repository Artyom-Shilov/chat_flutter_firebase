import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit_impl.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit_impl.dart';
import 'package:chat_flutter_firebase/chats/pages/chats_page.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_consts.dart';
import '../../test_realizations/test_auth_service.dart';
import '../../test_realizations/test_event_listening_service.dart';
import '../../test_realizations/test_local_storage_service.dart';
import '../../test_realizations/test_network_connectivity_service.dart';
import '../../test_realizations/test_network_service.dart';
import '../../test_realizations/test_notification_service.dart';
import '../../test_realizations/test_router.dart';

void main() async {
  final authService = TestAuthService();
  final networkService = TestNetworkService();
  final localStorageService = TestLocalStorageService();
  final networkConnectivity = TestNetworkConnectivity();
  final notificationService = TestNotificationService();
  final eventListeningService = TestEventListeningService();
  testWidgets('sign-in screen widgets visibility on open', (WidgetTester tester) async {
    when(() => networkConnectivity.checkNetworkConnection())
        .thenAnswer((invocation) async => true);
    when(() => notificationService.getNotificationsToken())
        .thenAnswer((invocation) async => TestConsts.notificationToken);
    when(() => networkService.getUserInfoById(TestConsts.userId))
        .thenAnswer((invocation) async => UserInfo(
        id: TestConsts.userId,
        name: TestConsts.userName,
        email: TestConsts.email));
    when(() => networkService.getUserInfoById(TestConsts.userId))
        .thenAnswer((invocation) async => UserInfo(
        id: TestConsts.userId,
        name: TestConsts.userName,
        email: TestConsts.email));
    when(() => networkService.getChatsByUser(TestConsts.userId))
        .thenAnswer((invocation) async => TestConsts.testChats);
    final authCubit = AuthCubitImpl(
        authService: authService,
        networkService: networkService,
        localStorageService: localStorageService,
        networkConnectivity: networkConnectivity,
        notificationService: notificationService);
    final chatsCubit = ChatsCubitImpl(
        networkService: networkService,
        storageService: localStorageService,
        networkConnectivity: networkConnectivity,
        eventsListening: eventListeningService,
        notificationService: notificationService);
    await authCubit.signInByGoogle();
    chatsCubit.isListeningUserChatsUpdates = true;
    tester.binding.window.physicalSizeTestValue = const Size(1000, 4000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: TestRouter(MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => authCubit,
          ),
          BlocProvider<ChatsCubit>(
            create: (context) => chatsCubit,
          )
        ],
        child: Builder(builder: (context) {
          return const ChatListPage();
        }),
      )).router,
    ));
    await tester.pumpAndSettle();
    expect(find.text(ChatTexts.chatListAppBarTitleRu), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.textContaining(TestConsts.chatName), findsNWidgets(2));
    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.text(TestConsts.chatLastMessage), findsOneWidget);
  });
}
