import 'package:chat_flutter_firebase/auth/controllers/auth_cubit.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) => Text(state.user?.email ?? '')
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: const Text('Выйти'),
              onPressed: () async {
                final router = GoRouter.of(context);
                await BlocProvider.of<AuthCubit>(context).signOut();
                router.goNamed(Routes.signIn.routeName);
              },
            ),
    ]
        ),
      ),
    );
  }
}
