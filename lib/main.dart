import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit_impl.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_processing_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_processing_cubit_impl.dart';
import 'package:chat_flutter_firebase/auth/services/firebase_auth_service.dart';
import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit_impl.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit_impl.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity_impl.dart';
import 'package:chat_flutter_firebase/local_storage/services/isar_storage_service.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:chat_flutter_firebase/rest_network/dio_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final storage = IsarStorageService();
  await storage.init();
  GetIt.I.registerSingleton<LocalStorageService>(storage);
  GetIt.I.registerSingleton<NetworkService>(DioService());
  GetIt.I.registerSingleton<NetworkConnectivity>(NetworkConnectivityImpl());
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = useState(AppNavigation()).value;
    return MultiBlocProvider(
      providers: [
          BlocProvider<AuthCubit>(
              create: (context) => AuthCubitImpl(
                  authService: FirebaseAuthService(),
                  networkService: GetIt.I.get<NetworkService>(),
                  localStorageService: GetIt.I.get<LocalStorageService>(),
                  networkConnectivity: GetIt.I.get<NetworkConnectivity>()
              )),
          BlocProvider<AuthProcessingCubit>(
              create: (context) => AuthProcessingCubitImpl()),
          BlocProvider<ChatsCubit>(
              create: (context) => ChatsCubitImpl(
                  networkService: GetIt.I.get<NetworkService>(),
                  storageService: GetIt.I.get<LocalStorageService>(),
                  networkConnectivity: GetIt.I.get<NetworkConnectivity>())),
        BlocProvider<ChatSearchCubit>(
            create: (context) =>  ChatSearchCubitImpl(
                networkService: GetIt.I.get<NetworkService>()))
        ],
        child: MaterialApp.router(
        routerConfig: navigation.goRouter,
        title: 'Chat app',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan.shade50),
            useMaterial3: true,
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context)
                .textTheme.copyWith(displayMedium: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w400)))),
      )
    );
  }
}
