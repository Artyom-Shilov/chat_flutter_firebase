import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chats_state.freezed.dart';

enum ChatsStatus {
  loading,
  error,
  ready
}

@Freezed(makeCollectionsUnmodifiable: false)
class ChatsState with _$ChatsState {
  const factory ChatsState(
      {required ChatsStatus status,
      @Default([]) List<ChatInfo> userChats,
      @Default('') message,
      String? chatCreationErrorText,
      }) = _ChatsState;
}
