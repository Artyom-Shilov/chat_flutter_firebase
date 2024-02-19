import 'package:chat_flutter_firebase/local_storage/local_models/local_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

@freezed
class UserInfo with _$UserInfo {

  const UserInfo._();

  const factory UserInfo({
    required String id,
    String? name,
    String? email,
    String? photoUrl,
    String? aboutUser
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  factory UserInfo.fromFirebaseAuthUser(User firebaseAuthUser) {
    return UserInfo(
        id: firebaseAuthUser.uid,
        name: firebaseAuthUser.displayName,
        email: firebaseAuthUser.email,
        photoUrl: firebaseAuthUser.photoURL);
  }

  factory UserInfo.fromLocalUserInfo(LocalUserInfo localUser) {
    return UserInfo(
        name: localUser.name,
        email: localUser.email,
        photoUrl: localUser.photoUrl,
        id: localUser.userId,
    );
  }
}
