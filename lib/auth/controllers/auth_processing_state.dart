import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_processing_state.freezed.dart';

@freezed
class AuthProcessingState with _$AuthProcessingState {
  const factory AuthProcessingState(
          {@Default(false) bool isPasswordInputVisible,
          @Default(false) bool isRegistration}) =
      _AuthProcessingState;
}
