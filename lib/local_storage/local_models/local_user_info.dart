import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:isar/isar.dart';

part 'local_user_info.g.dart';

@collection
class LocalUserInfo {

  LocalUserInfo._(this.userId);

  LocalUserInfo({
    this.name,
    this.email,
    this.photoUrl,
    required this.userId,
});

  String? name;
  String? email;
  @Index()
  String userId;
  String? photoUrl;
  Id id = Isar.autoIncrement;

  factory LocalUserInfo.fromUserInfo(UserInfo appUser) {
    return LocalUserInfo(
      name: appUser.name,
      email: appUser.email,
      photoUrl: appUser.photoUrl,
      userId: appUser.id
    );
  }
}