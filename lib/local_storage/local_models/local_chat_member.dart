import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:isar/isar.dart';

part 'local_chat_member.g.dart';

@collection
class LocalChatMember {

  LocalChatMember._(this.userId, this.chatName);

  LocalChatMember({
    this.name,
    this.email,
    this.photoUrl,
    this.isNotificationsEnabled,
    required this.userId,
    required this.chatName,
  });

  String? name;
  String? email;
  @Index()
  String userId;
  @Index(composite: [CompositeIndex('userId')])
  String chatName;
  String? photoUrl;
  bool? isNotificationsEnabled;
  Id id = Isar.autoIncrement;

  factory LocalChatMember.fromUserAndChatInfo(UserInfo chatMember, ChatInfo chatInfo) {
    return LocalChatMember(
        chatName: chatInfo.name,
        name: chatMember.name,
        email: chatMember.email,
        photoUrl: chatMember.photoUrl,
        isNotificationsEnabled: chatMember.isNotificationsEnabled,
        userId: chatMember.id
    );
  }
}