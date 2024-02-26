import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/widgets/cached_avatar.dart';
import 'package:chat_flutter_firebase/common/widgets/loading_animation.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final user = BlocProvider.of<AuthCubit>(context).user;
    final userName = user?.name ??  user?.email ?? user!.id;
    final navigation = GoRouter.of(context);
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: [
          Center(
              child: CachedAvatar(
                  photoUrl: authCubit.user?.photoUrl,
                  name: userName,
                  radius: 30,
                  placeholderWidget:
                      LoadingAnimation(color: Theme.of(context).primaryColor))),
          const SizedBox(height: Sizes.verticalInset2),
          Text(userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(AuthText.doLogout),
            onTap: () async {
              await authCubit.signOut();
              navigation.goNamed(Routes.signIn.routeName);
            },
          )
        ],
      ),
    );
  }
}
