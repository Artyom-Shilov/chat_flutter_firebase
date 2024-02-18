import 'dart:async';

import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';

abstract interface class NetworkService {

  Future<void> saveUser(UserInfo user);
  Future<bool> isUserInDatabase(UserInfo user);
  Future<bool> isChatInDatabase(String chatName);
  Future<void> saveChat(ChatInfo chatInfo, UserInfo userInfo);
  Future<List<ChatInfo>> getChatsByUser(String userId);
  Future<List<UserInfo>> getChatMembers(ChatInfo chatInfo);
  Future<List<ChatInfo>> searchForChats(String searchValue);
}