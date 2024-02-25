import 'package:chat_flutter_firebase/local_storage/local_models/local_chat_info.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_chat_member.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_message.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_user_info.dart';

abstract interface class LocalStorageService {

  Future<void> init();
  Future<void> saveCurrentAppUser(LocalUserInfo userInfo);
  Future<void> deleteCurrentAppUser();
  Future<LocalUserInfo?> getSavedAppUser();

  Future<List<LocalChatInfo>> getUserChats();
  Future<void> saveUserChats(List<LocalChatInfo> userChats);
  Future<void> addUserChat(LocalChatInfo chatInfo);
  Future<void> deleteUserChat(LocalChatInfo chatInfo);

  Future<void> saveChatMembers(List<LocalChatMember> chatMembers);
  Future<void> addChatMember(LocalChatMember chatMember);
  Future<void> deleteChatMember(LocalChatMember chatMember);
  Future<List<LocalChatMember>> getChatMembers(String chatName);

  Future<void> saveChatMessages(List<LocalMessage> localMessages);
  Future<void> addChatMessage(LocalMessage message);
  Future<void> deleteChatMessage(LocalMessage message);
  Future<List<LocalMessage>> getChatMessages(String chatName);
}