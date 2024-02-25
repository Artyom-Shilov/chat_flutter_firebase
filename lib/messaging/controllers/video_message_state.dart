import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_message_state.freezed.dart';

enum VideoMessageStatus {
  loading,
  ready,
  error
}

@freezed
class VideoMessageState with _$VideoMessageState {
  const factory VideoMessageState({
    required VideoMessageStatus status,
    @Default('') message,
    @Default(false) bool isPlaying
  }) = _VideoMessageState;

}
