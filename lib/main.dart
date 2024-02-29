import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit_impl.dart';
import 'package:chat_flutter_firebase/auth/services/firebase_auth_service.dart';
import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit_impl.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit_impl.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity_impl.dart';
import 'package:chat_flutter_firebase/database_events/database_events_listening.dart';
import 'package:chat_flutter_firebase/database_events/firebase_events_listening.dart';
import 'package:chat_flutter_firebase/files_handling/database_file_handler.dart';
import 'package:chat_flutter_firebase/files_handling/firebase_file_handler.dart';
import 'package:chat_flutter_firebase/files_handling/local_file_handler.dart';
import 'package:chat_flutter_firebase/files_handling/local_file_handler_impl.dart';
import 'package:chat_flutter_firebase/local_storage/services/isar_storage_service.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:chat_flutter_firebase/notifications/firebase_notification_sevice.dart';
import 'package:chat_flutter_firebase/notifications/notification_service.dart';
import 'package:chat_flutter_firebase/rest_network/dio_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:get_it/get_it.dart';

@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(
      _backgroundMessageHandler);
  GetIt.I.registerSingleton<LocalStorageService>(IsarStorageService());
  GetIt.I.registerSingleton<NetworkService>(DioService());
  GetIt.I.registerSingleton<NetworkConnectivity>(NetworkConnectivityImpl());
  GetIt.I.registerSingleton<DatabaseEventsListening>(FirebaseEventsListening());
  GetIt.I.registerSingleton<DatabaseFileHandler>(FirebaseFileHandler());
  GetIt.I.registerSingleton<LocalFileHandler>(LocalFileHandlerImpl());
  GetIt.I.registerSingleton<NotificationService>(FirebaseNotificationService(
      networkService: GetIt.I.get<NetworkService>()));
  await GetIt.I.get<NotificationService>().init();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
              create: (context) => AuthCubitImpl(
                  authService: FirebaseAuthService(),
                  networkService: GetIt.I.get<NetworkService>(),
                  localStorageService: GetIt.I.get<LocalStorageService>(),
                  networkConnectivity: GetIt.I.get<NetworkConnectivity>(),
                  notificationService: GetIt.I.get<NotificationService>())),
          BlocProvider<ChatsCubit>(
              create: (context) => ChatsCubitImpl(
                  networkService: GetIt.I.get<NetworkService>(),
                  storageService: GetIt.I.get<LocalStorageService>(),
                  networkConnectivity: GetIt.I.get<NetworkConnectivity>(),
                  eventsListening: GetIt.I.get<DatabaseEventsListening>(),
                  notificationService: GetIt.I.get<NotificationService>())),
          BlocProvider<ChatSearchCubit>(
              create: (context) => ChatSearchCubitImpl(
                  storageService: GetIt.I.get<LocalStorageService>(),
                  networkConnectivity: GetIt.I.get<NetworkConnectivity>(),
                  networkService: GetIt.I.get<NetworkService>(),
                  eventsListening: GetIt.I.get<DatabaseEventsListening>()))
        ],
        child: MaterialApp.router(
          routerConfig: AppNavigation.goRouter,
          title: 'Chat app',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            useMaterial3: true,
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context)
                .textTheme.copyWith(displayMedium: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w400)))),
      )
    );
  }
}
