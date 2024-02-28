import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:flutter/cupertino.dart';

abstract interface class NotificationService {
  Future<String?> getNotificationsToken();

  Future<void> init();

  void startListening(BuildContext context);

  Future<void> requestPermissions();

  Future<void> sendNotificationAboutChatUpdate({
    required String body,
    required ChatInfo chat,
    required UserInfo sender,
    required List<UserInfo> members,
  });
}