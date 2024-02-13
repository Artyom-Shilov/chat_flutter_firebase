import 'package:chat_flutter_firebase/app_models/app_user.dart';
import 'package:chat_flutter_firebase/auth/controllers/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract interface class AuthCubit extends Cubit<AuthState> {
  AuthCubit(super.initialState);

  AppUser? get user;

  Future<void> signInByEmailAndPassword(String email, String password);
  Future<void> createUserByEmailAndPassword(String email, String password, String? username);
  Future<void> signOut();
  Future<void> signInByGoogle();
}