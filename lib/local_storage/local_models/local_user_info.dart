import 'package:chat_flutter_firebase/app_models/app_user.dart';
import 'package:isar/isar.dart';

part 'local_user_info.g.dart';

@collection
class LocalUserInfo {

  LocalUserInfo._();

  LocalUserInfo({
    this.name,
    this.email,
    this.photoUrl,
    this.userId,
});

  String? name;
  String? email;
  String? userId;
  String? photoUrl;
  Id id = Isar.autoIncrement;

  factory LocalUserInfo.fromAppUser(AppUser appUser) {
    return LocalUserInfo(
      name: appUser.name,
      email: appUser.email,
      photoUrl: appUser.photoUrl,
      userId: appUser.id
    );
  }
}