import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/database_events/database_events_listening.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_state.dart';
import 'package:chat_flutter_firebase/rest_network/dio_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:firebase_database/firebase_database.dart';

class MessagingCubitImpl extends Cubit<MessagingState> implements MessagingCubit {

  MessagingCubitImpl({
    required ChatInfo chat,
    required NetworkConnectivity networkConnectivity,
    required LocalStorageService localStorageService,
    required NetworkService networkService,
    required DatabaseEventsListening eventsListening})
      : _networkConnectivity = networkConnectivity,
        _localStorageService = localStorageService,
        _networkService = networkService,
        _eventsListening = eventsListening,
        super(MessagingState(status: MessagingStatus.loading, chat: chat)) {
    _statesSubscription = stream.listen((event) {
      if (_messagesSubscription == null && event.status == MessagingStatus.ready) {
        _messagesSubscription = _eventsListening
            .chatMessagesStream(state.chat)
            .skip(_messageNumberAfterInit)
            .listen((event) {
          emit(state.copyWith(messages: List.of(state.messages)..add(event)));
        });
      }
    });
  }

  //TODO listen for new users
  //TODO listen for new messages

  final NetworkService _networkService;
  final LocalStorageService _localStorageService;
  final NetworkConnectivity _networkConnectivity;
  final DatabaseEventsListening _eventsListening;
  StreamSubscription<Message>? _messagesSubscription;
  StreamSubscription<MessagingState>? _statesSubscription;
  late final int _messageNumberAfterInit;

  @override
  Future<List<Message>> loadChatMessages() {
    // TODO: implement loadChatMessages
    throw UnimplementedError();
  }

  @override
  Future<List<UserInfo>> loadChatUsers() {
    // TODO: implement loadChatUsers
    throw UnimplementedError();
  }

  @override
  Future<void> notifyChatUsers(Message message, UserInfo appUser) async {
    final infoForUpdate = state.chat.copyWith(
        lastUserNameText: appUser.name ?? appUser.email ?? appUser.id,
        lastMessageText: message.text,
        lastMessageTime: message.millisSinceEpoch);
    //await _networkService.updateChat(infoForUpdate);
    await _networkService.updateUserChat(infoForUpdate, state.members);
  }

  @override
  Future<void> sendTextMessage(Message message) async {
    await _networkService.sendMessage(message, state.chat);
  }

  @override
  Future<void> init() async {
    final members = await _networkService.getChatMembers(state.chat);
    final messages = await _networkService.getChatMessages(state.chat);
    emit(state.copyWith(status: MessagingStatus.ready, messages: messages, members: members));
    _messageNumberAfterInit = messages.length;
  }

  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();
    await _statesSubscription?.cancel();
    return super.close();
  }
}