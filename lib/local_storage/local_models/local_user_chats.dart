import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:isar/isar.dart';

part 'local_user_chats.g.dart';

@collection
class LocalUserChats {

  LocalUserChats._(this.userId, this.chats);

  LocalUserChats({
    required this.userId,
    this.chats = const []
});

  Id isarId = Isar.autoIncrement;
  @Index()
  String userId;
  List<LocalChatInfo> chats;

  factory LocalUserChats.fromUserChats(String userId, List<ChatInfo> chatList) {
    return LocalUserChats(
      userId: userId,
      chats: chatList.map((e) => LocalChatInfo.fromChatInfo(e)).toList()
    );
  }
}

@embedded
class LocalChatInfo {

  LocalChatInfo._(this.adminId, this.name);

  LocalChatInfo(
      {this.name = '',
      this.adminId = '',
      this.lastMessageText,
      this.lastUserNameText});

  String name;
  String adminId;
  String? lastUserNameText;
  String? lastMessageText;

  factory LocalChatInfo.fromChatInfo(ChatInfo chatInfo) {
    return LocalChatInfo(
      name: chatInfo.name,
      adminId: chatInfo.adminId,
      lastUserNameText: chatInfo.lastUserNameText,
      lastMessageText: chatInfo.lastMessageText
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalChatInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          adminId == other.adminId &&
          lastUserNameText == other.lastUserNameText &&
          lastMessageText == other.lastMessageText;

  @override
  int get hashCode =>
      name.hashCode ^
      adminId.hashCode ^
      lastUserNameText.hashCode ^
      lastMessageText.hashCode;
}