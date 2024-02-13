import 'package:chat_flutter_firebase/local_storage/local_models/local_user_info.dart';

abstract interface class LocalStorageService {

  Future<void> init();
  Future<void> saveCurrentAppUser(LocalUserInfo userInfo);
  Future<void> deleteCurrentAppUser();
  Future<LocalUserInfo?> getSavedAppUser();

}