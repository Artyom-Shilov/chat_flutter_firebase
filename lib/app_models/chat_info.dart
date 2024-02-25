import 'package:chat_flutter_firebase/local_storage/local_models/local_chat_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_info.freezed.dart';
part 'chat_info.g.dart';

@freezed
class ChatInfo with _$ChatInfo {
  const ChatInfo._();

  const factory ChatInfo(
      {@JsonKey(includeToJson: false) required String name,
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
        lastUserNameText: localChatInfo.lastUserNameText,
        lastMessageTime: localChatInfo.lastMessageTime
    );
  }
}
