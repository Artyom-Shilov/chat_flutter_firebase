import 'dart:developer';

import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_user_chats.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_user_info.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarStorageService implements LocalStorageService {

  late Isar _isar;

  @override
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([LocalUserInfoSchema, LocalUserChatsSchema],
        directory: directory.path);
  }

  @override
  Future<LocalUserInfo?> getSavedAppUser() async {
    List<LocalUserInfo> localInfo = [];
    await _isar.txn(() async {
      localInfo = await _isar.localUserInfos.where().findAll();
    });
    return localInfo.isEmpty ? null : localInfo.first;
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
  Future<void> saveUserChats(LocalUserChats userChats) async {
    await _isar.writeTxn(() async {
      await _isar.localUserChats.putByIndex('userId', userChats);
    });
  }

  @override
  Future<LocalUserChats?> getChatsByUser(String userId) async {
    LocalUserChats? result;
    await _isar.txn(() async {
      result = await _isar.localUserChats.filter().userIdEqualTo(userId).findFirst();
    });
    return result;
  }
}