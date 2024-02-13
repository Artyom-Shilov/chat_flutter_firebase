import 'dart:developer';

import 'package:chat_flutter_firebase/local_storage/local_models/local_user_info.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarStorageService implements LocalStorageService {

  late Isar _isar;

  @override
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([LocalUserInfoSchema], directory: directory.path);
  }

  @override
  Future<LocalUserInfo?> getSavedAppUser() async {
    List<LocalUserInfo> localInfo = [];
    await _isar.writeTxn(() async {
      localInfo = await _isar.localUserInfos.where().findAll();
    });
    return localInfo.isEmpty ? null : localInfo.first;
  }

  @override
  Future<void> saveCurrentAppUser(LocalUserInfo userInfo) async {
    log('save user');
    await _isar.writeTxn(() async {
      await _isar.localUserInfos.put(userInfo);
    });
    log('save user end');
  }

  @override
  Future<void> deleteCurrentAppUser() async {
    log('delete user');
    await _isar.writeTxn(() async {
      await _isar.localUserInfos.where().deleteAll();
    });
    log('delete user end');
  }
}