import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';


@freezed
class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? aboutUser,
  }) = _AppUser;

  factory AppUser.fromFirebaseAuthUser(User firebaseAuthUser) {
    return AppUser(
        id: firebaseAuthUser.uid,
        name: firebaseAuthUser.displayName,
        email: firebaseAuthUser.email,
        photoUrl: firebaseAuthUser.photoURL);
  }

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}