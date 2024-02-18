import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_user_chats.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter/widgets.dart';

class ChatsCubitImpl extends Cubit<ChatsState> implements ChatsCubit{

  ChatsCubitImpl({
    required NetworkService networkService,
    required LocalStorageService storageService,
    required NetworkConnectivity networkConnectivity})
      : _networkConnectivity = networkConnectivity,
        _storageService = storageService,
        _networkService = networkService,
        super(const ChatsState(status: ChatsStatus.loading)) {
    stream.listen((event) {
      if (event.status == ChatsStatus.ready) {

      }
    });
  }

  StreamSubscription<ChatInfo>? chatInfoSubscription;
  final NetworkService _networkService;
  final LocalStorageService _storageService;
  final NetworkConnectivity _networkConnectivity;

  @override
  final TextEditingController chatCreationController = TextEditingController();

  @override
  Future<void> createChat(ChatInfo chatInfo, UserInfo userInfo) async {
    log('createChat');
    emit(state.copyWith(status: ChatsStatus.loading));
    await _networkService.saveChat(chatInfo, userInfo);
    emit(state.copyWith(
        status: ChatsStatus.ready, userChats: List.of(state.userChats)..add(chatInfo)));
  }

  @override
  Future<void> loadChatsByUserId(String userId) async {
    emit(state.copyWith(status: ChatsStatus.loading));
    final List<ChatInfo> userChats;
    if (await _networkConnectivity.checkNetworkConnection()) {
      userChats = await _networkService.getChatsByUser(userId);
      _storageService.saveUserChats(LocalUserChats.fromUserChats(userId, userChats));
      emit(state.copyWith(status: ChatsStatus.ready, userChats: userChats));
      print((await _storageService.getChatsByUser(userId))?.chats);
    } else {
      userChats = [];//await _storageService.getChatsByUser(userId);
      emit(state.copyWith(status: ChatsStatus.ready, userChats: userChats));
    }
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
    final isExists = await _networkService.isChatInDatabase(chatName);
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