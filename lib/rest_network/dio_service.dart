import 'package:chat_flutter_firebase/app_models/app_user.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:dio/dio.dart';

enum Location {
  profiles
}

class DioService implements NetworkService {

  final Dio _dio = Dio();
  final String firebaseRealtimeDatabaseUrl = 'https://flutter-chat-ede6d-default-rtdb.europe-west1.firebasedatabase.app';

  DioService() {
    _dio.options = BaseOptions(
        baseUrl: firebaseRealtimeDatabaseUrl,
        contentType: Headers.jsonContentType,
        validateStatus: (_) => true);
  }

  @override
  Future<void> addUserToDatabase(AppUser user) async {
    final json = user.toJson();
    json.remove('id');
    await _dio.put('/${Location.profiles.name}/${user.id}.json', data: json);
  }

  @override
  Future<bool> isUserInDatabase(AppUser user) async {
    final response = await _dio.get<Map<dynamic, dynamic>>(
        '/${Location.profiles.name}.json',
        queryParameters: {'orderBy': r'"$key"', 'equalTo': '"${user.id!}"'});
    return response.data!.isNotEmpty;
  }
}