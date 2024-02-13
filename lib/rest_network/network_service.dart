import 'package:chat_flutter_firebase/app_models/app_user.dart';

abstract interface class NetworkService {

  Future<void> addUserToDatabase(AppUser user);
  Future<bool> isUserInDatabase(AppUser user);
}