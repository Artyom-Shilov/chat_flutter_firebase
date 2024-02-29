import 'package:chat_flutter_firebase/app_models/chat_info.dart';

abstract class TestConsts {

  static String email = 'test@gmail.com';
  static String password = 'test_user';
  static String userId = 'test';
  static String userName = 'userName';
  static String notificationToken = 'test';
  static String chatName = 'chat';
  static String chatLastMessage = 'hello';

  static List<ChatInfo> testChats = [
    ChatInfo(name: '${chatName}1', adminId: userId),
    ChatInfo(
        name: '${chatName}2',
        lastUserNameText: userName,
        lastMessageText: 'hello',
        adminId: userId)
  ];
}