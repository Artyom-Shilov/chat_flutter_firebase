import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/chats_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/database_events/database_events_listening.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_chat_info.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/notifications/notification_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter/widgets.dart';

class ChatsCubitImpl extends Cubit<ChatsState> implements ChatsCubit {
  ChatsCubitImpl(
      {required NetworkService networkService,
      required LocalStorageService storageService,
      required NetworkConnectivity networkConnectivity,
      required DatabaseEventsListening eventsListening,
      required NotificationService notificationService})
      : _networkConnectivity = networkConnectivity,
        _storageService = storageService,
        _networkService = networkService,
        _eventsListening = eventsListening,
        _notificationService = notificationService,
        super(const ChatsState(status: ChatsStatus.loading));

  StreamSubscription<ChatInfo>? _userChatsUpdatesSubscription;
  StreamSubscription<ChatInfo>? _removedUserChatsSubscription;
  StreamSubscription<ChatInfo>? _addedUserChatSubscription;
  final NetworkService _networkService;
  final DatabaseEventsListening _eventsListening;
  final LocalStorageService _storageService;
  final NetworkConnectivity _networkConnectivity;
  final NotificationService _notificationService;
  late int _chatNumberAfterLoad;
  @override
  bool isListeningUserChatsUpdates = false;

  @override
  final TextEditingController chatCreationController = TextEditingController();

  @override
  void startListenUserChatsUpdates(UserInfo userInfo) {
    if (isListeningUserChatsUpdates == true) {
      return;
    }
    log('chats cubit: startListeningChatUpdates');
    isListeningUserChatsUpdates = true;
    _userChatsUpdatesSubscription ??= _eventsListening.userChatsUpdates(userInfo.id).listen((update) {
        final index = state.userChats
            .indexWhere((element) => element.name == update.name);
        final updatedChats = List.of(state.userChats);
        updatedChats[index] = update;
        emit(state.copyWith(userChats: updatedChats));
        _storageService.addUserChat(
            LocalChatInfo.fromChatInfoAndUserId(update, userInfo.id));
      });
    if (_removedUserChatsSubscription == null) {
      _removedUserChatsSubscription =
          _eventsListening.deletedUserChatsStream(userInfo.id).listen((event) {
        _storageService.deleteUserChat(
            LocalChatInfo.fromChatInfoAndUserId(event, userInfo.id));
        emit(state.copyWith(
            userChats: List.of(state.userChats)
              ..removeWhere((element) => element.name == event.name)));
      });
      _addedUserChatSubscription ??= _eventsListening
            .addedUserChatsStream(userInfo.id)
            .skip(_chatNumberAfterLoad)
            .listen((event) {
          log(event.toString());
          _storageService.addUserChat(
              LocalChatInfo.fromChatInfoAndUserId(event, userInfo.id));
          emit(state.copyWith(userChats: List.of(state.userChats)..add(event)));
        });
    }
  }

  @override
  Future<void> stopListenUserChatsUpdates() async {
    isListeningUserChatsUpdates = false;
    await _userChatsUpdatesSubscription?.cancel();
    await _removedUserChatsSubscription?.cancel();
    await _addedUserChatSubscription?.cancel();
    _userChatsUpdatesSubscription = null;
    _removedUserChatsSubscription = null;
    _addedUserChatSubscription = null;
  }

  @override
  Future<void> createChat(ChatInfo chatInfo, UserInfo userInfo) async {
    log('create chat');
    try {
      if (!await _networkConnectivity.checkNetworkConnection()) {
        emit(state.copyWith(
            status: ChatsStatus.error,
            message: ChatErrorsTexts.noConnectionRU));
        return;
      }
      await _networkService.saveChat(chatInfo, userInfo);
      _storageService.addUserChat(
          LocalChatInfo.fromChatInfoAndUserId(chatInfo, userInfo.id));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: ChatsStatus.error, message: ChatErrorsTexts.createChatRu));
    }
  }

  @override
  Future<void> loadChatsByUserId(String userId) async {
    log('load user chats');
    emit(state.copyWith(status: ChatsStatus.loading));
    try {
      List<ChatInfo> userChats = [];
      if (await _networkConnectivity.checkNetworkConnection()) {
        userChats = await _networkService.getChatsByUser(userId);
        _storageService.saveUserChats(userChats
            .map((e) => LocalChatInfo.fromChatInfoAndUserId(e, userId))
            .toList());
      } else {
        final localChats = await _storageService.getUserChatsById(userId);
        userChats =
            localChats.map((e) => ChatInfo.fromLocalChatInfo(e)).toList();
      }
      _chatNumberAfterLoad = userChats.length;
      emit(state.copyWith(status: ChatsStatus.ready, userChats: userChats));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: ChatsStatus.error, message: ChatErrorsTexts.loadUserChatsRu));
    }
  }

  @override
  Future<void> leaveChat(ChatInfo chatInfo, UserInfo userInfo) async {
    if (!await _networkConnectivity.checkNetworkConnection()) {
      emit(state.copyWith(
          status: ChatsStatus.error, message: ChatErrorsTexts.noConnectionRU));
      return;
    }
    try {
      await _networkService.leaveChat(chatInfo, userInfo);
      _storageService.deleteUserChat(
          LocalChatInfo.fromChatInfoAndUserId(chatInfo, userInfo.id));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: ChatsStatus.error, message: ChatErrorsTexts.leaveChatRu));
    }
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
    log('chat name validation');
    final chatName = chatCreationController.text;
    if (chatName.isEmpty) {
      emit(state.copyWith(
          chatCreationErrorText: ChatTexts.chatNameLengthFieldErrorRu));
      return;
    }
    if (await _networkConnectivity.checkNetworkConnection()) {
      final isExists = await _networkService.isChatInDatabase(chatName);
      log('isChatExists: $isExists');
      isExists
          ? emit(state.copyWith(
              chatCreationErrorText: ChatTexts.chatAlreadyExistsFieldErrorRu))
          : emit(state.copyWith(chatCreationErrorText: null));
    } else {
      emit(state.copyWith(
          chatCreationErrorText: ChatErrorsTexts.noConnectionRU));
    }
  }

  @override
  Future<void> close() async {
    await stopListenUserChatsUpdates();
    chatCreationController.dispose();
    await super.close();
  }

  @override
  List<ChatInfo> get userChats =>
      state.userChats..sort((a, b) => a.name.compareTo(b.name));

  @override
  Future<void> setStateStatus(
      {Duration? delay, required ChatsStatus status}) async {
    delay != null ? await Future.delayed(delay) : null;
    emit(state.copyWith(status: status));
  }

  @override
  void startListenNotifications(BuildContext context) {
    _notificationService.startListening(context);
  }
}
