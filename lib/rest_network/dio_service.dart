import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
    await _dio.put('/${Location.profiles.name}/${user.id}.json', data: json);
  }

  @override
  Future<List<UserInfo>> getChatMembers(ChatInfo chatInfo) async {
    final response = await _dio.get<String>(
        '/${Location.chatMembers.name}/.json',
        queryParameters: {
          'orderBy': r'"$key"',
          'equalTo': '"${chatInfo.name}"'
        });
    if (response.data == null) {
      return [];
    }
    final data = TransferableTypedData.fromList(
        [Int32List.fromList(response.data!.codeUnits)]);
    final result = await compute<TransferableTypedData, List<UserInfo>>((message) {
      final decodedResponse = json.decode(
          String.fromCharCodes(message.materialize().asUint32List())) as Map<String, dynamic>;
      List<UserInfo> memberList = [];
      if (decodedResponse.isEmpty) {
        return memberList;
      }
      final users = decodedResponse[chatInfo.name] as Map<String, dynamic>;
      for (final key in users.keys) {
        memberList.add(UserInfo.fromJson((users[key] as Map<String, dynamic>)
          ..putIfAbsent('id', () => key)));
      }
      return memberList;
    }, data);
    return result;
  }

  @override
  Future<List<ChatInfo>> getChatsByUser(String userId) async {
    final response = await _dio.get<String>(
        '/${Location.userChats.name}/.json',
        queryParameters: {'orderBy': r'"$key"', 'equalTo': '"$userId"'});
    if (response.data == null) {
      return [];
    }
    final data = TransferableTypedData.fromList(
        [Int32List.fromList(response.data!.codeUnits)]);
    final result = await compute<TransferableTypedData, List<ChatInfo>>((message) {
      final decodedResponse = json.decode(
          String.fromCharCodes(message.materialize().asUint32List())) as Map<String, dynamic>;
      List<ChatInfo> chatList = [];
      if (decodedResponse.isEmpty) {
        return chatList;
      }
      final users = decodedResponse[userId] as Map<String, dynamic>;
      for (final key in users.keys) {
        chatList.add(ChatInfo.fromJson((users[key] as Map<String, dynamic>)
          ..putIfAbsent('name', () => key)));
      }
      return chatList;
    }, data);
    return result;
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
    final userJson = userInfo.toJson();
    await _dio.put('/${Location.chats.name}/${chatInfo.name}.json', data: chatJson);
    await _dio.put('/${Location.chatMembers.name}/${chatInfo.name}/${userInfo.id}.json', data: userJson);
    await _dio.put('/${Location.userChats.name}/${userInfo.id}/${chatInfo.name}.json', data: chatJson);
  }

  @override
  Future<List<ChatInfo>> searchForChats(String searchValue) async {
    final response = await _dio.get<String>(
        '/${Location.chats.name}/.json',
        queryParameters: {
          'orderBy': r'"$key"',
          'startAt': '"$searchValue"',
          'endAt': '"$searchValue\uf8ff"'
        });
    if (response.data == null) {
      return [];
    }
    final data = TransferableTypedData.fromList(
        [Int32List.fromList(response.data!.codeUnits)]);
    final result = await compute<TransferableTypedData, List<ChatInfo>>((message) {
      final decodedResponse = json.decode(
          String.fromCharCodes(message.materialize().asUint32List())) as Map<String, dynamic>;
      List<ChatInfo> chats = [];
      if (decodedResponse.isEmpty) {
        return chats;
      }
      for (final key in decodedResponse.keys) {
        chats.add(ChatInfo.fromJson((decodedResponse[key] as Map<String, dynamic>)
          ..putIfAbsent('name', () => key)));
      }
      return chats;
    }, data);
   return result;
  }

  @override
  Future<void> joinChat(ChatInfo chatInfo, UserInfo userInfo) async {
    final chatJson = chatInfo.toJson();
    final userJson = userInfo.toJson();
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
    final response = await _dio.get<String>('/${Location.messages.name}.json',
        queryParameters: {
          'orderBy': r'"$key"',
          'equalTo': '"${chatInfo.name}"'
        });
    if (response.data == null) {
      return [];
    }
    final data = TransferableTypedData.fromList(
        [Int32List.fromList(response.data!.codeUnits)]);
    final result = await compute<TransferableTypedData, List<Message>>((message) {
      final decodedResponse = json.decode(
              String.fromCharCodes(message.materialize().asUint32List())) as Map<String, dynamic>;
      List<Message> messageList = [];
      if (decodedResponse.isEmpty) {
        return messageList;
      }
      final messages = decodedResponse[chatInfo.name] as Map<String, dynamic>;
      for (final key in messages.keys) {
        messageList.add(Message.fromJson((messages[key] as Map<String, dynamic>)
          ..putIfAbsent('id', () => key)));
      }
      return messageList;
    }, data);
    return result;
  }

  @override
  Future<void> updateChat(ChatInfo chatInfo) async {
    final chatJson = chatInfo.toJson();
    await _dio.put('/${Location.chats.name}/${chatInfo.name}.json', data: chatJson);
  }

  @override
  Future<void> updateUserChats(
      ChatInfo chatInfo, List<UserInfo> chatUsers) async {
    final chatJson = chatInfo.toJson();
    final Map<String, dynamic> requestBody = {};
    for (final user in chatUsers) {
      requestBody.putIfAbsent('${user.id}/${chatInfo.name}', () => chatJson);
    }
    await _dio.patch('/${Location.userChats.name}.json', data: requestBody);
  }

  @override
  Future<void> leaveChat(ChatInfo chatInfo, UserInfo userInfo) async {
    await _dio.delete(
        '/${Location.chatMembers.name}/${chatInfo.name}/${userInfo.id}.json');
    await _dio.delete(
        '/${Location.userChats.name}/${userInfo.id}/${chatInfo.name}.json');
  }
}