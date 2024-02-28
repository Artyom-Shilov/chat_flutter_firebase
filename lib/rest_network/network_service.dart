import 'dart:async';

import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';

abstract interface class NetworkService {

  Future<void> saveUser(UserInfo user);
  Future<UserInfo?> getUserInfoById(String id);
  Future<bool> isChatInDatabase(String chatName);
  Future<void> saveChat(ChatInfo chatInfo, UserInfo userInfo);
  Future<List<ChatInfo>> getChatsByUser(String userId);
  Future<List<UserInfo>> getChatMembers(ChatInfo chatInfo);
  Future<List<ChatInfo>> searchForChats(String searchValue);
  Future<void> joinChat(ChatInfo chatInfo, UserInfo userInfo);
  Future<List<Message>> getChatMessages(ChatInfo chatInfo);
  Future<void> sendMessage(Message message, ChatInfo chatInfo);
  Future<void> updateChat(ChatInfo chatInfo);
  Future<void> updateMembersChatInfo(ChatInfo chatInfo, List<UserInfo> chatUsers);
  Future<void> leaveChat(ChatInfo chatInfo, UserInfo userInfo);
  Future<void> updateChatMemberNotificationStatus(ChatInfo chatInfo, UserInfo userInfo);

  Future<void> sendNotificationAboutChatUpdate(
      {required String body,
      required String title,
      required ChatInfo chat,
      required UserInfo sender,
      required String key,
      required List<UserInfo> chatMembers});
}