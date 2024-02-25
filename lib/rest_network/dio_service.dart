import 'dart:async';
import 'dart:developer';

import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:dio/dio.dart';

enum Location {
  profiles,
  chats,
  chatMembers,
  userChats,
  messages,
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
  Future<List<UserInfo>> getChatMembers(ChatInfo chatInfo) async {
    final response = await _dio.get<Map<String, dynamic>>(
        '/${Location.chatMembers.name}/.json',
        queryParameters: {
          'orderBy': r'"$key"',
          'equalTo': '"${chatInfo.name}"'
        });
    final output = <UserInfo>[];
    if (response.data!.isEmpty) {
      return output;
    }
    final users = response.data![chatInfo.name] as Map<String, dynamic>;
    for (final key in users.keys) {
      output.add(UserInfo.fromJson(
          (users[key] as Map<String, dynamic>)..putIfAbsent('id', () => key)));
    }
    return output;
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
  Future<UserInfo?> getUserInfoById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
        '/${Location.profiles.name}.json',
        queryParameters: {'orderBy': r'"$key"', 'equalTo': '"$id"'});
    log('getUserInfoById response ${response.data}');
    if (response.data!.isEmpty) {
      return null;
    }
    return UserInfo.fromJson(response.data![id]..putIfAbsent('id', () => id));
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

  @override
  Future<void> joinChat(ChatInfo chatInfo, UserInfo userInfo) async {
    final chatJson = chatInfo.toJson();
    chatJson.remove('name');
    final userJson = userInfo.toJson();
    userJson.remove('id');
    await _dio.put('/${Location.chatMembers.name}/${chatInfo.name}/${userInfo.id}.json', data: userJson);
    await _dio.put('/${Location.userChats.name}/${userInfo.id}/${chatInfo.name}.json', data: chatJson);
  }

  @override
  Future<void> sendMessage(Message message, ChatInfo chatInfo) async {
    final messageJson = message.toJson();
    await _dio.put('/${Location.messages.name}/${chatInfo.name}/${message.id}.json', data: messageJson);
  }

  @override
  Future<List<Message>> getChatMessages(ChatInfo chatInfo) async {
    final response = await _dio.get<Map<String, dynamic>>(
        '/${Location.messages.name}.json',
        queryParameters: {'orderBy': r'"$key"', 'equalTo': '"${chatInfo.name}"'});
    final output = <Message>[];
    if (response.data!.isEmpty) {
      return output;
    }
    final messages = response.data![chatInfo.name] as Map<String, dynamic>;
    for (final key in messages.keys) {
      output.add(Message.fromJson((messages[key] as Map<String, dynamic>)
        ..putIfAbsent('id', () => key)));
    }
    return output;
  }

  @override
  Future<void> updateChat(ChatInfo chatInfo) async {
    final chatJson = chatInfo.toJson();
    chatJson.remove('name');
    await _dio.put('/${Location.chats.name}/${chatInfo.name}.json', data: chatJson);
  }

  @override
  Future<void> updateUserChat(
      ChatInfo chatInfo, List<UserInfo> chatUsers) async {
    final chatJson = chatInfo.toJson();
    chatJson.remove('name');
    final Map<String, dynamic> requestBody = {};
    for (final user in chatUsers) {
      requestBody.putIfAbsent('${user.id}/${chatInfo.name}', () => chatJson);
    }
    await _dio.patch('/${Location.userChats.name}.json', data: requestBody);
  }
}