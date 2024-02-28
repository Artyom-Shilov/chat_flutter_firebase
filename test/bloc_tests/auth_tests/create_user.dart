import 'package:bloc_test/bloc_test.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit_impl.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:chat_flutter_firebase/auth/services/auth_service.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/notifications/notification_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_realizations/test_auth_service.dart';
import '../../test_realizations/test_local_storage_service.dart';
import '../../test_realizations/test_network_connectivity_service.dart';
import '../../test_realizations/test_network_service.dart';
import '../../test_realizations/test_notification_service.dart';
import '../test_consts.dart';

main() {
  late AuthService authService;
  late NetworkService networkService;
  late LocalStorageService localStorageService;
  late NetworkConnectivity networkConnectivity;
  late NotificationService notificationService;

  group('AuthBloc createUser', () {
    blocTest<AuthCubit, AuthState>(
      'base case',
      setUp: () {
        authService = TestAuthService();
        localStorageService = TestLocalStorageService();
        networkService = TestNetworkService();
        notificationService = TestNotificationService();
        networkConnectivity = MockNetworkConnectivity();
      },
      build: () {
        when(() => networkConnectivity.checkNetworkConnection())
            .thenAnswer((invocation) async => true);
        when(() => notificationService.getNotificationsToken())
            .thenAnswer((invocation) async => TestConsts.notificationToken);
        return AuthCubitImpl(
            authService: authService,
            networkService: networkService,
            localStorageService: localStorageService,
            networkConnectivity: networkConnectivity,
            notificationService: notificationService);
      },
      act: (cubit) => cubit.createUserByEmailAndPassword(
          TestConsts.email, TestConsts.password, TestConsts.userName),
      expect: () => [
        AuthState(
            status: AuthStatus.signedOut,
            user: UserInfo(id: TestConsts.userId, email: TestConsts.email)),
        AuthState(
            status: AuthStatus.signedIn,
            user: UserInfo(
                name: TestConsts.userName,
                id: TestConsts.userId,
                notificationsToken: TestConsts.notificationToken,
                email: TestConsts.email))
      ],
    );
    blocTest<AuthCubit, AuthState>('no connection',
        setUp: () {
          authService = TestAuthService();
          localStorageService = TestLocalStorageService();
          networkService = TestNetworkService();
          notificationService = TestNotificationService();
          networkConnectivity = MockNetworkConnectivity();
        },
        build: () {
          when(() => networkConnectivity.checkNetworkConnection())
              .thenAnswer((invocation) async => false);
          return AuthCubitImpl(
              authService: authService,
              networkService: networkService,
              localStorageService: localStorageService,
              networkConnectivity: networkConnectivity,
              notificationService: notificationService);
        },
        act: (cubit) => cubit.createUserByEmailAndPassword(
            TestConsts.email, TestConsts.password, TestConsts.userName),
        expect: () => [
              const AuthState(
                  status: AuthStatus.error,
                  message: AuthErrorTexts.noConnectionRU)
            ]);
  });
}
