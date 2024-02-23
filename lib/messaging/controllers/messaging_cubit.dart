import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_state.dart';
import 'package:flutter/cupertino.dart';

abstract interface class MessagingCubit extends Cubit<MessagingState> {
  MessagingCubit(super.initialState);
  Future<void> sendTextMessage(UserInfo sender);
  Future<List<Message>> loadChatMessages();
  Future<List<UserInfo>> loadChatUsers();
  Future<void> init();
  Future<void> sendImageFromGallery(UserInfo sender);
  Future<void> sendVideoFromGallery(UserInfo sender);

  TextEditingController get messageInputController;
  ScrollController get messageListController;
  List<Message> get messages;
}