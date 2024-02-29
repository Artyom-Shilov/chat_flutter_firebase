import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:isar/isar.dart';

part 'local_chat_info.g.dart';

@collection
class LocalChatInfo {

  LocalChatInfo._(this.name, this.adminId, this.userId);

  LocalChatInfo({
    required this.name,
    required this.adminId,
    required this.userId,
    this.lastMessageText,
    this.lastUserNameText,
    this.lastMessageTime
  });

  Id isarId = Isar.autoIncrement;
  @Index()
  String name;
  @Index(composite: [CompositeIndex('name')])
  String userId;
  String adminId;
  int? lastMessageTime;
  String? lastUserNameText;
  String? lastMessageText;

  factory LocalChatInfo.fromChatInfoAndUserId(ChatInfo chatInfo, String userId) {
    return LocalChatInfo(
        userId: userId,
        name: chatInfo.name,
        adminId: chatInfo.adminId,
        lastUserNameText: chatInfo.lastUserNameText,
        lastMessageText: chatInfo.lastMessageText,
        lastMessageTime: chatInfo.lastMessageTime,
    );
  }
}
