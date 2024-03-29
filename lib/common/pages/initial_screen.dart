import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class InitialScreen extends HookWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigation = GoRouter.of(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    useAnimationController();
    useEffect(() {
      final storageService = GetIt.I.get<LocalStorageService>();
      Future.delayed(const Duration(seconds: 1)).then((value) => storageService
          .init()
          .then((_) => storageService.getSavedAppUser().then((user) async {
                if (user == null) {
                  navigation.goNamed(Routes.signIn.routeName);
                } else {
                  await authCubit.setAppUser();
                  authCubit.state.status != AuthStatus.error
                      ? navigation.goNamed(Routes.chats.routeName)
                      : navigation.goNamed(Routes.signIn.routeName);
                }
              })));
      return null;
    }, ['key']);
    return BlocListener<AuthCubit, AuthState>(
        listenWhen: (prev, next) => prev.status != next.status,
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
            body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
                Image.asset('assets/logo.png', width: 100, height: 100),
                const Spacer(),
              ]),
        )));
  }
}
