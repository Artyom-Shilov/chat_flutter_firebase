import 'dart:convert';
import 'dart:developer';

import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/navigation/app_navigation.dart';
import 'package:chat_flutter_firebase/notifications/notification_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

class FirebaseNotificationService implements NotificationService {
  FirebaseNotificationService({required NetworkService networkService})
      : _networkService = networkService;

  final NetworkService _networkService;
  final key = 'AAAAE4giS-E:APA91bEA1XgqctQyodZY_mgp_qCW5AzWp2PYTX7ivIHO3yFzDohaylGh8DzE1IQA5qvjDnAZlWU_mj5IXlFUiirMtW_AnZVfhnQF6qgMNYcFETN0RL65d69GK4xcKdUiFgBdd_3aF1g3';

  @override
  void startListening(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log('onMessageOpenedApp');
      final chat = ChatInfo.fromJson(json.decode(message.data['chat']));
      GoRouter.of(context).goNamed(Routes.messaging.routeName,
          pathParameters: {Params.chatName.name: chat.name}, extra: chat);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showNotification(message);
    });
  }

  @override
  Future<String?> getNotificationsToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (response) {
      log('onDidReceiveNotificationResponse');
    });
  }

  final AndroidNotificationChannel _androidChannel =
  const AndroidNotificationChannel(
    'chat_app',
    'chat_app',
    importance: Importance.max,
    playSound: true,
  );

  Future<void> showNotification(RemoteMessage message) async {
    final style = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatTitle: true,
    );
    final details = NotificationDetails(
        android: AndroidNotificationDetails(
            _androidChannel.id, _androidChannel.name,
            importance: _androidChannel.importance,
            priority: Priority.max,
            playSound: _androidChannel.playSound,
            styleInformation: style));
    await flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        details,
        payload: message.data['body']);
  }

  @override
  Future<void> requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission();
  }

  @override
  Future<void> sendNotificationAboutChatUpdate(
      {required String body,
      required ChatInfo chat,
      required UserInfo sender,
      required List<UserInfo> members,
      }) async {
    await _networkService.sendNotificationAboutChatUpdate(
        body: body,
        title: chat.name,
        chat: chat,
        sender: sender,
        key: key,
        chatMembers: members);
  }
}
