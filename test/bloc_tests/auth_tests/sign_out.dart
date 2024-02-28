import 'package:bloc_test/bloc_test.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit_impl.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:chat_flutter_firebase/auth/services/auth_service.dart';
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

  group('AuthBloc signOut', () {
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
        return AuthCubitImpl(
            authService: authService,
            networkService: networkService,
            localStorageService: localStorageService,
            networkConnectivity: networkConnectivity,
            notificationService: notificationService);
      },
      seed: () => AuthState(
          status: AuthStatus.signedIn,
          user: UserInfo(
              name: TestConsts.userName,
              id: TestConsts.userId,
              email: TestConsts.email)),
      act: (cubit) => cubit.signOut(),
      expect: () => [
        const AuthState(status: AuthStatus.signedOut),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'no connection',
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
      seed: () => AuthState(
          status: AuthStatus.signedIn,
          user: UserInfo(
              name: TestConsts.userName,
              id: TestConsts.userId,
              email: TestConsts.email)),
      act: (cubit) => cubit.signOut(),
      expect: () => [
        const AuthState(status: AuthStatus.signedOut),
      ],
    );
  });
}