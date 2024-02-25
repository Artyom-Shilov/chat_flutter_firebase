import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_user_chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_info.freezed.dart';
part 'chat_info.g.dart';

@freezed
class ChatInfo with _$ChatInfo {
  const ChatInfo._();

  const factory ChatInfo(
      {required String name,
      required String adminId,
      String? photoUrl,
      String? lastUserNameText,
      String? lastMessageText,
      int? lastMessageTime}) = _ChatInfo;

  factory ChatInfo.fromJson(Map<String, dynamic> json) =>
      _$ChatInfoFromJson(json);

  factory ChatInfo.fromLocalChatInfo(LocalChatInfo localChatInfo) {
    return ChatInfo(
        name: localChatInfo.name,
        adminId: localChatInfo.adminId,
        lastMessageText: localChatInfo.lastMessageText,
        lastUserNameText: localChatInfo.lastUserNameText
    );
  }
}
