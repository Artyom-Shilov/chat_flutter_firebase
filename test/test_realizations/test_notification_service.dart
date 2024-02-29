import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/notifications/notification_service.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mocktail/mocktail.dart';

class TestNotificationService extends Mock implements NotificationService {

  @override
  Future<void> init() async {}

  @override
  Future<void> requestPermissions() async {}

  @override
  Future<void> sendNotificationAboutChatUpdate({required String body, required ChatInfo chat, required UserInfo sender, required List<UserInfo> members}) async {}

  @override
  void startListening(BuildContext context) {}


}