import 'package:chat_flutter_firebase/local_storage/local_models/local_chat_info.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_chat_member.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_message.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_user_info.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:mocktail/mocktail.dart';

class TestLocalStorageService extends Mock implements LocalStorageService {

  @override
  Future<void> addChatMessage(LocalMessage message) async {}

  @override
  Future<void> addUserChat(LocalChatInfo chatInfo) async {}

  @override
  Future<void> deleteChatMember(LocalChatMember chatMember) async {}

  @override
  Future<void> deleteChatMessage(LocalMessage message) async {}

  @override
  Future<void> deleteCurrentAppUser() async {}

  @override
  Future<void> deleteUserChat(LocalChatInfo chatInfo) async {}


  @override
  Future<void> init() async {}

  @override
  Future<void> saveChatMember(LocalChatMember chatMember) async {}

  @override
  Future<void> saveChatMembers(List<LocalChatMember> chatMembers) async {}

  @override
  Future<void> saveChatMessages(List<LocalMessage> localMessages) async {}

  @override
  Future<void> saveCurrentAppUser(LocalUserInfo userInfo) async {}

  @override
  Future<void> saveUserChats(List<LocalChatInfo> userChats) async {}

}