import 'dart:async';

import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/database_events/database_events_listening.dart';
import 'package:chat_flutter_firebase/rest_network/dio_service.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseEventsListening implements DatabaseEventsListening {

  @override
  String? currentUserId;

  final _messageTransformer = StreamTransformer<DatabaseEvent, Message>.fromHandlers(
      handleData: (data, sink) {
        final messageId = data.snapshot.key!;
        final value = data.snapshot.value! as Map;
        value.putIfAbsent('id', () => messageId);
        sink.add(Message.fromJson(value.cast<String, dynamic>()));
      }
  );

  final _chatTransformer = StreamTransformer<DatabaseEvent, ChatInfo>.fromHandlers(
      handleData: (data, sink) {
        final chatName = data.snapshot.key!;
        final value = data.snapshot.value! as Map;
        value.putIfAbsent('name', () => chatName);
        sink.add(ChatInfo.fromJson(value.cast<String, dynamic>()));
      }
  );

  final _userTransformer = StreamTransformer<DatabaseEvent, UserInfo>.fromHandlers(
      handleData: (data, sink) {
        final userId = data.snapshot.key!;
        final value = data.snapshot.value! as Map;
        value.putIfAbsent('id', () => userId);
        sink.add(UserInfo.fromJson(value.cast<String, dynamic>()));
      }
  );

  @override
  Stream<Message> addedMessagesStream(ChatInfo chatInfo) {
    final messagesRef = FirebaseDatabase.instance.ref('${Location.messages.name}/${chatInfo.name}');
    return messagesRef.onChildAdded.transform(_messageTransformer);
  }

  @override
  Stream<Message> updatedMessageStream(ChatInfo chatInfo) {
    final messagesRef = FirebaseDatabase.instance.ref('${Location.messages.name}/${chatInfo.name}');
    return messagesRef.onChildChanged.transform(_messageTransformer);
  }

  @override
  Stream<ChatInfo> userChatsUpdates() {
    final messagesRef = FirebaseDatabase.instance.ref('${Location.userChats.name}/$currentUserId');
    return messagesRef.onChildChanged.transform(_chatTransformer);
  }

  @override
  Stream<ChatInfo> deletedUserChatsStream() {
    final messagesRef = FirebaseDatabase.instance.ref('${Location.userChats.name}/$currentUserId');
    return messagesRef.onChildRemoved.transform(_chatTransformer);
  }

  @override
  Stream<ChatInfo> addedUserChatsStream() {
    final messagesRef = FirebaseDatabase.instance.ref('${Location.userChats.name}/$currentUserId');
    return messagesRef.onChildAdded.transform(_chatTransformer);
  }

  @override
  Stream<UserInfo> addedChatMemberStream(ChatInfo chatInfo) {
    final chatMembersRef = FirebaseDatabase.instance.ref('${Location.chatMembers.name}/${chatInfo.name}');
    return chatMembersRef.onChildAdded.transform(_userTransformer);
  }

  @override
  Stream<UserInfo> deletedChatMemberStream(ChatInfo chatInfo) {
    final chatMembersRef = FirebaseDatabase.instance.ref('${Location.chatMembers.name}/${chatInfo.name}');
    return chatMembersRef.onChildRemoved.transform(_userTransformer);
  }
}