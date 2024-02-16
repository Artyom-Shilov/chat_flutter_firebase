import 'package:chat_flutter_firebase/app_models/user_info.dart';
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
      String? lastMessageText}) = _ChatInfo;

  factory ChatInfo.fromJson(Map<String, dynamic> json) =>
      _$ChatInfoFromJson(json);
}
