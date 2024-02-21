import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'messaging_state.freezed.dart';

enum MessagingStatus {
  loading,
  ready,
  error
}

@freezed
class MessagingState with _$MessagingState {
  const factory MessagingState({
    required MessagingStatus status,
    required ChatInfo chat,
    @Default([]) List<UserInfo> members ,
    @Default([]) List<Message> messages,
    @Default('') String info,
  }) = _MessagingState;
}
