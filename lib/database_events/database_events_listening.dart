import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';

abstract interface class DatabaseEventsListening {

  Stream<Message> addedMessagesStream(ChatInfo chatInfo);
  Stream<Message> updatedMessageStream(ChatInfo chatInfo);
  Stream<ChatInfo> userChatsUpdates(String currentUserId);
  Stream<ChatInfo> deletedUserChatsStream(String currentUserId);
  Stream<ChatInfo> addedUserChatsStream(String currentUserId);
  Stream<UserInfo> addedChatMemberStream(ChatInfo chatInfo);
  Stream<UserInfo> deletedChatMemberStream(ChatInfo chatInfo);
  Stream<UserInfo> chatMembersUpdates(ChatInfo chatInfo);
}