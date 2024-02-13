import 'package:chat_flutter_firebase/app_models/app_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

enum AuthStatus {
  signedIn,
  signedOut,
  loading,
  error
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    AppUser? user,
    @Default('') String message
  }) = _AuthState;
}

