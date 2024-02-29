import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit_impl.dart';
import 'package:chat_flutter_firebase/auth/pages/auth_page.dart';
import 'package:chat_flutter_firebase/auth/widgets/social_auth_button.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_realizations/test_auth_service.dart';
import '../../test_realizations/test_local_storage_service.dart';
import '../../test_realizations/test_network_connectivity_service.dart';
import '../../test_realizations/test_network_service.dart';
import '../../test_realizations/test_notification_service.dart';
import '../../test_realizations/test_router.dart';

void main() async {
  testWidgets('sign-in screen widgets visibility on open', (WidgetTester tester) async {
    final authCubit = AuthCubitImpl(
        authService: TestAuthService(),
        networkService: TestNetworkService(),
        localStorageService: TestLocalStorageService(),
        networkConnectivity: TestNetworkConnectivity(),
        notificationService: TestNotificationService());
    tester.binding.window.physicalSizeTestValue = const Size(1000, 4000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: TestRouter(
        BlocProvider<AuthCubit>(
          create: (context) => authCubit,
          child: Builder(builder: (context) {
            return const AuthPage();
          }),
        ),
      ).router,
    ));
    await tester.pumpAndSettle();
    expect(find.text(AuthText.emailHintRu), findsOneWidget);
    expect(find.text(AuthText.passwordHintRu), findsOneWidget);
    expect(find.text(AuthText.doSignInRu), findsOneWidget);
    expect(find.image(const AssetImage('assets/logo.png')), findsOneWidget);
    expect(find.byType(SocialAuthButton), findsAtLeastNWidgets(1));
    expect(find.text(AuthText.toRegistrationRu), findsOneWidget);
  });

  testWidgets('sign-in screen widgets visibility validation error',
      (WidgetTester tester) async {
    final authCubit = AuthCubitImpl(
        authService: TestAuthService(),
        networkService: TestNetworkService(),
        localStorageService: TestLocalStorageService(),
        networkConnectivity: TestNetworkConnectivity(),
        notificationService: TestNotificationService());
    tester.binding.window.physicalSizeTestValue = const Size(1000, 4000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: TestRouter(
        BlocProvider<AuthCubit>(
          create: (context) => authCubit,
          child: Builder(builder: (context) {
            return const AuthPage();
          }),
        ),
      ).router,
    ));
    await tester.pumpAndSettle();
    expect(find.text(AuthText.emailValidationErrorRu), findsNothing);
    expect(find.text(AuthText.passwordValidationLengthErrorRu), findsNothing);
    await tester.tap(find.text(AuthText.doSignInRu));
    await tester.pumpAndSettle();
    expect(find.text(AuthText.emailValidationErrorRu), findsOneWidget);
    expect(find.text(AuthText.passwordValidationLengthErrorRu), findsOneWidget);
  });

  testWidgets('register screen widgets visibility on open', (WidgetTester tester) async {
    final authCubit = AuthCubitImpl(
        authService: TestAuthService(),
        networkService: TestNetworkService(),
        localStorageService: TestLocalStorageService(),
        networkConnectivity: TestNetworkConnectivity(),
        notificationService: TestNotificationService());
    authCubit.changeAuthProcess();
    tester.binding.window.physicalSizeTestValue = const Size(1000, 4000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: TestRouter(
        BlocProvider<AuthCubit>(
          create: (context) => authCubit,
          child: Builder(builder: (context) {
            return const AuthPage();
          }),
        ),
      ).router,
    ));
    await tester.pumpAndSettle();
    expect(find.text(AuthText.emailHintRu), findsOneWidget);
    expect(find.text(AuthText.passwordHintRu), findsOneWidget);
    expect(find.text(AuthText.usernameHintRu), findsOneWidget);
    expect(find.text(AuthText.doRegisterRu), findsOneWidget);
    expect(find.image(const AssetImage('assets/logo.png')), findsOneWidget);
    expect(find.text(AuthText.toLoginRu), findsOneWidget);
  });

  testWidgets('registration screen widgets visibility validation error',
          (WidgetTester tester) async {
        final authCubit = AuthCubitImpl(
            authService: TestAuthService(),
            networkService: TestNetworkService(),
            localStorageService: TestLocalStorageService(),
            networkConnectivity: TestNetworkConnectivity(),
            notificationService: TestNotificationService());
        authCubit.changeAuthProcess();
        tester.binding.window.physicalSizeTestValue = const Size(1000, 4000);
        tester.binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(MaterialApp.router(
          routerConfig: TestRouter(
            BlocProvider<AuthCubit>(
              create: (context) => authCubit,
              child: Builder(builder: (context) {
                return const AuthPage();
              }),
            ),
          ).router,
        ));
        await tester.pumpAndSettle();
        expect(find.text(AuthText.emailValidationErrorRu), findsNothing);
        expect(find.text(AuthText.usernameValidationLengthErrorRu), findsNothing);
        expect(find.text(AuthText.passwordValidationLengthErrorRu), findsNothing);
        await tester.tap(find.text(AuthText.doRegisterRu));
        await tester.pumpAndSettle();
        expect(find.text(AuthText.emailValidationErrorRu), findsOneWidget);
        expect(find.text(AuthText.usernameValidationLengthErrorRu), findsOneWidget);
        expect(find.text(AuthText.passwordValidationLengthErrorRu), findsOneWidget);
      });
}
