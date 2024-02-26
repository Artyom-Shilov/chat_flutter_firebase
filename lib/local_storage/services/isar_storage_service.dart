import 'package:chat_flutter_firebase/local_storage/local_models/local_chat_info.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_chat_member.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_message.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_user_info.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

class IsarStorageService implements LocalStorageService {

  late Isar _isar;

  @override
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      LocalUserInfoSchema,
      LocalChatInfoSchema,
      LocalChatMemberSchema,
      LocalMessageSchema
    ],
        directory: directory.path);
  }

  @override
  Future<LocalUserInfo?> getSavedAppUser() async {
    LocalUserInfo? user;
    await _isar.txn(() async {
      user = await _isar.localUserInfos.where().findFirst();
    });
    return user;
  }

  @override
  Future<void> saveCurrentAppUser(LocalUserInfo userInfo) async {
    await _isar.writeTxn(() async {
      await _isar.localUserInfos.put(userInfo);
    });
  }

  @override
  Future<void> deleteCurrentAppUser() async {
    await _isar.writeTxn(() async {
      await _isar.localUserInfos.where().deleteAll();
    });
  }


  @override
  Future<void> saveUserChats(List<LocalChatInfo> userChats) async {
    await _isar.writeTxn(() async {
      await _isar.localChatInfos.putAllByIndex('name', userChats);
    });
  }

  @override
  Future<List<LocalChatInfo>> getUserChats() async {
    List<LocalChatInfo> result = [];
    await _isar.txn(() async {
      result = await _isar.localChatInfos.where().findAll();
    });
    return result;
  }

  @override
  Future<void> addUserChat(LocalChatInfo chatInfo) async {
    await _isar.writeTxn(() async {
      await _isar.localChatInfos.putByIndex('name', chatInfo);
    });
  }

  @override
  Future<void> deleteUserChat(LocalChatInfo chatInfo) async {
    await _isar.writeTxn(() async {
      await _isar.localChatInfos.filter().nameEqualTo(chatInfo.name).deleteFirst();
    });
  }

  @override
  Future<void> addChatMember(LocalChatMember chatMember) async {
    await _isar.writeTxn(() async {
      await _isar.localChatMembers.putByIndex('chatName_userId', chatMember);
    });
  }

  @override
  Future<void> deleteChatMember(LocalChatMember chatMember) async {
    await _isar.writeTxn(() async {
      await _isar.localChatMembers.where().chatNameUserIdEqualTo(chatMember.chatName, chatMember.userId).deleteFirst();
    });
  }

  @override
  Future<void> saveChatMembers(List<LocalChatMember> chatMembers) async {
    await _isar.writeTxn(() async {
      await _isar.localChatMembers.putAllByIndex('chatName_userId', chatMembers);
    });
  }

  @override
  Future<List<LocalChatMember>> getChatMembers(String chatName) async {
    List<LocalChatMember> result = [];
    await _isar.txn(() async {
      result = await _isar.localChatMembers.filter().chatNameEqualTo(chatName).findAll();
    });
    return result;
  }

  @override
  Future<void> addChatMessage(LocalMessage message) async {
    await _isar.writeTxn(() async {
      await _isar.localMessages.putByIndex('chatName_messageId', message);
    });
  }

  @override
  Future<void> deleteChatMessage(LocalMessage message) async {
    await _isar.writeTxn(() async {
      await _isar.localMessages
          .where()
          .chatNameMessageIdEqualTo(message.chatName, message.messageId)
          .deleteFirst();
    });
  }

  @override
  Future<List<LocalMessage>> getChatMessages(String chatName) async {
    List<LocalMessage> result = [];
    await _isar.txn(() async {
      result = await _isar.localMessages.filter().chatNameEqualTo(chatName).findAll();
    });
    return result;
  }

  @override
  Future<void> saveChatMessages(List<LocalMessage> localMessages) async {
   await _isar.writeTxn(() async {
      await _isar.localMessages.putAllByIndex('chatName_messageId', localMessages);
    });
  }
}