import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter/widgets.dart';

class ChatsCubitImpl extends Cubit<ChatsState> implements ChatsCubit{

  ChatsCubitImpl({required this.networkService, required this.storageService})
      : super(const ChatsState(status: ChatsStatus.loading)) {
    stream.listen((event) {
      log(event.toString());
    });
  }

  void _startListeningForChatInfoUpdates() {
    while(state.status == ChatsStatus.ready) {
      //listen and emit state
    }
    chatInfoSubscription?.cancel();
  }

  StreamSubscription<ChatInfo>? chatInfoSubscription;
  final NetworkService networkService;
  final LocalStorageService storageService;

  @override
  final TextEditingController chatCreationController = TextEditingController();

  @override
  Future<void> createChat(ChatInfo chatInfo, UserInfo userInfo) async {
    log('createChat');
    emit(state.copyWith(status: ChatsStatus.loading));
    await networkService.saveChat(chatInfo, userInfo);
    emit(state.copyWith(
        status: ChatsStatus.ready, userChats: List.of(state.userChats)..add(chatInfo)));
  }

  @override
  //TODO check fot network connection
  Future<void> loadChatsByUserId(String userId) async {
    emit(state.copyWith(status: ChatsStatus.loading));
    final userChats = await networkService.getChatsByUser(userId);
    emit(state.copyWith(status: ChatsStatus.ready, userChats: userChats));
  }

  @override
  Future<void> removeChat(ChatInfo chatInfo) {
    // TODO: implement removeChat
    throw UnimplementedError();
  }

  @override
  void resetChatCreationError() {
    emit(state.copyWith(chatCreationErrorText: null));
  }

  @override
  void clearChatName() {
    chatCreationController.clear();
  }

  @override
  Future<void> validateChatName() async {
    final chatName = chatCreationController.text;
    if (chatName.isEmpty) {
      emit(state.copyWith(chatCreationErrorText: ChatTexts.chatNameLengthFieldErrorRu));
      return;
    }
    final isExists = await networkService.isChatInDatabase(chatName);
    log('isChatExists: $isExists');
    if (isExists) {
      emit(state.copyWith(chatCreationErrorText: ChatTexts.chatAlreadyExistsFieldErrorRu));
    } else {
      emit(state.copyWith(chatCreationErrorText: null));
    }
  }

  @override
  Future<void> close() async {
    await chatInfoSubscription?.cancel();
    chatCreationController.dispose();
    await super.close();
  }
}