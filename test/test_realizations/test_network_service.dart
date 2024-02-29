import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:mocktail/mocktail.dart';

class TestNetworkService extends Mock implements NetworkService {


  @override
  Future<void> joinChat(ChatInfo chatInfo, UserInfo userInfo) async {}

  @override
  Future<void> leaveChat(ChatInfo chatInfo, UserInfo userInfo) async {}

  @override
  Future<void> saveChat(ChatInfo chatInfo, UserInfo userInfo) async {}

  @override
  Future<void> saveUser(UserInfo user) async {}

  @override
  Future<void> sendMessage(Message message, ChatInfo chatInfo) async {}

  @override
  Future<void> sendNotificationAboutChatUpdate(
      {required String body,
      required String title,
      required ChatInfo chat,
      required UserInfo sender,
      required String key,
      required List<UserInfo> chatMembers}) async {}

  @override
  Future<void> updateChat(ChatInfo chatInfo) async {}

  @override
  Future<void> updateChatMemberNotificationStatus(ChatInfo chatInfo, UserInfo userInfo) async {}

  @override
  Future<void> updateMembersChatInfo(ChatInfo chatInfo, List<UserInfo> chatUsers) async  {}
}