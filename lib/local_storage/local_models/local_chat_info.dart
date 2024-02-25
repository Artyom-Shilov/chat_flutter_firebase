import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:isar/isar.dart';

part 'local_chat_info.g.dart';

@collection
class LocalChatInfo {

  LocalChatInfo._(this.name, this.adminId);

  LocalChatInfo({
    required this.name,
    required this.adminId,
    this.lastMessageText,
    this.lastUserNameText,
    this.lastMessageTime
  });

  Id isarId = Isar.autoIncrement;
  @Index()
  String name;
  String adminId;
  int? lastMessageTime;
  String? lastUserNameText;
  String? lastMessageText;

  factory LocalChatInfo.fromChatInfo(ChatInfo chatInfo) {
    return LocalChatInfo(
        name: chatInfo.name,
        adminId: chatInfo.adminId,
        lastUserNameText: chatInfo.lastUserNameText,
        lastMessageText: chatInfo.lastMessageText,
        lastMessageTime: chatInfo.lastMessageTime,
    );
  }
}
