import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class InitialScreen extends HookWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigation = GoRouter.of(context);
    useEffect(() {
      GetIt.I.get<LocalStorageService>().getSavedAppUser().then((user) {
        user == null
            ? navigation.goNamed(Routes.signIn.routeName)
            : navigation.goNamed(Routes.chats.routeName);
      });
      return null;
    });
    //TODO probably splash screen
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
