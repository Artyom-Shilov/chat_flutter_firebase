import 'package:chat_flutter_firebase/app_models/user_info.dart';
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
    UserInfo? user,
    @Default('') String message,
    @Default(false) bool isPasswordInputVisible,
    @Default(false) bool isRegistration}) = _AuthState;
}

