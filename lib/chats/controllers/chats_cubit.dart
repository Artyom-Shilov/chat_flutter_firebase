import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:flutter/material.dart';

abstract interface class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit(super.initialState);

  Future<void> createChat(ChatInfo chatInfo, UserInfo userInfo);
  Future<void> leaveChat(ChatInfo chatInfo, UserInfo userInfo);
  Future<void> loadChatsByUserId(String userId);

  Future<void> validateChatName();
  TextEditingController get chatCreationController;
  void resetChatCreationError();
  void clearChatName();

  void startListenNotifications(BuildContext context);

  List<ChatInfo> get userChats;
  Future<void> setStateStatus({Duration? delay, required ChatsStatus status});
}