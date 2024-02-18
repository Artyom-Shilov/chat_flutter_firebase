import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:dio/dio.dart';

enum Location {
  profiles,
  chats,
  chatMembers,
  userChats
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
  Future<void> saveUser(UserInfo user) async {
    final json = user.toJson();
    json.remove('id');
    await _dio.put('/${Location.profiles.name}/${user.id}.json', data: json);
  }

  @override
  Future<bool> isUserInDatabase(UserInfo user) async {
    final response = await _dio.get<Map<dynamic, dynamic>>(
        '/${Location.profiles.name}.json',
        queryParameters: {'orderBy': r'"$key"', 'equalTo': '"${user.id}"'});
    return response.data!.isNotEmpty;
  }

  @override
  Future<List<UserInfo>> getChatMembers(ChatInfo chatInfo) {
    // TODO: implement getChatMembers
    throw UnimplementedError();
  }

  @override
  Future<List<ChatInfo>> getChatsByUser(String userId) async {
    final response = await _dio.get<Map<String, dynamic>>(
        '/${Location.userChats.name}/.json',
        queryParameters: {'orderBy': r'"$key"', 'equalTo': '"$userId"'});
    final output = <ChatInfo>[];
    if (response.data!.isEmpty) {
      return output;
    }
    final chats = response.data![userId] as Map<String, dynamic>;
    for (final key in chats.keys) {
      output.add(ChatInfo.fromJson((chats[key] as Map<String, dynamic>)
        ..putIfAbsent('name', () => key)));
    }
    return output;
  }

  @override
  Future<bool> isChatInDatabase(String chatName) async {
    final response = await _dio.get<Map<dynamic, dynamic>>(
        '/${Location.chats.name}.json',
        queryParameters: {'orderBy': r'"$key"', 'equalTo': '"$chatName"'});
    log('isChatInDatabase: ${response.data}');
    return response.data!.isNotEmpty;
  }

  @override
  Future<void> saveChat(ChatInfo chatInfo, UserInfo userInfo) async {
    final chatJson = chatInfo.toJson();
    chatJson.remove('name');
    final userJson = userInfo.toJson();
    userJson.remove('id');
    await _dio.put('/${Location.chats.name}/${chatInfo.name}.json', data: chatJson);
    await _dio.put('/${Location.chatMembers.name}/${chatInfo.name}/${userInfo.id}.json', data: userJson);
    await _dio.put('/${Location.userChats.name}/${userInfo.id}/${chatInfo.name}.json', data: chatJson);
  }

  @override
  Future<List<ChatInfo>> searchForChats(String searchValue) async {
    final response = await _dio.get<Map<String, dynamic>>(
        '/${Location.chats.name}/.json',
        queryParameters: {
          'orderBy': r'"$key"',
          'startAt': '"$searchValue"',
          'endAt': '"$searchValue\uf8ff"'
        });
    final output = <ChatInfo>[];
    if (response.data!.isEmpty) {
      return output;
    }
    final chats = response.data!;
    for (final key in chats.keys) {
      output.add(ChatInfo.fromJson((chats[key] as Map<String, dynamic>)
        ..putIfAbsent('name', () => key)));
    }
    return output;
  }
}