import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/widgets/circle_cashed_network_image.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final navigation = GoRouter.of(context);
    print(authCubit.user);
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: [
          Center(
            child: authCubit.user!.photoUrl != null
                ? CircleCashedNetworkImage(
                url: authCubit.user!.photoUrl!,
                radius: 40)
                : CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),)
          ) ,
          const SizedBox(height: Sizes.verticalInset2),
          Text(
              authCubit.user?.name ??
                  authCubit.user?.email ??
                  authCubit.user!.id,
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
