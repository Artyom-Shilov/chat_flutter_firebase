import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';

abstract interface class DatabaseEventsListening {

  String? currentUserId;
  Stream<Message> addedMessagesStream(ChatInfo chatInfo);
  Stream<Message> updatedMessageStream(ChatInfo chatInfo);
  Stream<ChatInfo> userChatsUpdates();
  Stream<ChatInfo> deletedUserChatsStream();
  Stream<ChatInfo> addedUserChatsStream();
  Stream<UserInfo> addedChatMemberStream(ChatInfo chatInfo);
  Stream<UserInfo> deletedChatMemberStream(ChatInfo chatInfo);
  Stream<UserInfo> chatMembersUpdates(ChatInfo chatInfo);
}