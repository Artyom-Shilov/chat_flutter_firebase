import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/common/id_generation.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/database_events/database_events_listening.dart';
import 'package:chat_flutter_firebase/files_handling/file_handler.dart';
import 'package:chat_flutter_firebase/files_handling/firebase_file_handler.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_state.dart';
import 'package:chat_flutter_firebase/rest_network/dio_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter/src/widgets/scroll_controller.dart';

class MessagingCubitImpl extends Cubit<MessagingState> implements MessagingCubit {

  MessagingCubitImpl({
    required ChatInfo chat,
    required NetworkConnectivity networkConnectivity,
    required LocalStorageService localStorageService,
    required NetworkService networkService,
    required DatabaseEventsListening eventsListening,
    required FileHandler fileHandler})
      : _networkConnectivity = networkConnectivity,
        _localStorageService = localStorageService,
        _networkService = networkService,
        _eventsListening = eventsListening,
        _fileHandler = fileHandler,
        super(MessagingState(status: MessagingStatus.loading, chat: chat)) {
    _statesSubscription = stream.listen((event) {
      if (_newMessagesSubscription == null && event.status == MessagingStatus.ready) {
        _newMessagesSubscription = _eventsListening
            .newMessagesStream(state.chat)
            .skip(_messageNumberAfterInit)
            .listen((event) {
          emit(state.copyWith(messages: List.of(state.messages)..add(event)));
        });
      }
      if (_messageUpdateSubscription == null &&
          event.status == MessagingStatus.ready) {
        _messageUpdateSubscription =
            _eventsListening.messageUpdateStream(state.chat).listen((event) {
          final indexForUpdate =
              state.messages.indexWhere((element) => element.id == event.id);
          emit(state.copyWith(
              messages: List.of(state.messages)..[indexForUpdate] = event));
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
  final FileHandler _fileHandler;
  StreamSubscription<Message>? _newMessagesSubscription;
  StreamSubscription<Message>? _messageUpdateSubscription;
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
  //appUser.name ?? appUser.email ?? appUser.id
  Future<void> _notifyChatUsers({
    String? lastUserName,
    String? lastMessageText,
    required int lastMessageTime,
    required UserInfo sender}) async {
    final infoForUpdate = state.chat.copyWith(
        lastUserNameText: lastUserName,
        lastMessageText: lastMessageText,
        lastMessageTime: lastMessageTime);
    await _networkService.updateChat(infoForUpdate);
    await _networkService.updateUserChat(infoForUpdate, state.members);
  }

  @override
  Future<void> sendTextMessage(UserInfo sender) async {
    final message = Message(
        id: IdGenerator.I.generateUuidV1(),
        senderId: sender.id,
        text: messageInputController.text,
        type: MessageType.text,
        millisSinceEpoch: DateTime.now().millisecondsSinceEpoch
    );
    await _networkService.sendMessage(message, state.chat);
    await _notifyChatUsers(
    lastUserName: sender.name ?? sender.email ?? sender.id,
    lastMessageText: message.text,
    lastMessageTime: message.millisSinceEpoch,
    sender: sender);
  }


  @override
  Future<void> init() async {
    final members = await _networkService.getChatMembers(state.chat);
    final messages = await _networkService.getChatMessages(state.chat);
    emit(state.copyWith(status: MessagingStatus.ready, messages: messages, members: members));
    _messageNumberAfterInit = messages.length;
  }

  @override
  Future<void> sendImageFromGallery(UserInfo sender) async {
    final image = await _fileHandler.pickImageFromGallery();
    final messageId = IdGenerator.I.generateUuidV1();
    final message = Message(
        id: messageId,
        senderId: sender.id,
        type: MessageType.image,
        millisSinceEpoch: DateTime.now().millisecondsSinceEpoch);
    await _networkService.sendMessage(message, state.chat);
    await _notifyChatUsers(
        lastUserName: sender.name ?? sender.email ?? sender.id,
        lastMessageText: '📷',
        lastMessageTime: message.millisSinceEpoch,
        sender: sender);
    _fileHandler
        .uploadFile(image!, '${Folders.images}/$messageId')
        .then(
            (_) => _fileHandler.getDownloadUrl('${Folders.images}/$messageId'))
        .then((url) => _networkService.sendMessage(
            message.copyWith(fileRef: url), state.chat));
  }

  @override
  Future<void> sendVideoFromGallery(UserInfo sender) async {
    final video = await _fileHandler.pickVideoFromGallery();
    final messageId = IdGenerator.I.generateUuidV1();
    final message = Message(
        id: messageId,
        senderId: sender.id,
        type: MessageType.video,
        millisSinceEpoch: DateTime.now().millisecondsSinceEpoch);
    await _networkService.sendMessage(message, state.chat);
    await _notifyChatUsers(
        lastUserName: sender.name ?? sender.email ?? sender.id,
        lastMessageText: '🎞️',
        lastMessageTime: message.millisSinceEpoch,
        sender: sender);
    _fileHandler
        .uploadFile(video!, '${Folders.video}/$messageId')
        .then((_) => _fileHandler.getDownloadUrl('${Folders.video}/$messageId'))
        .then((url) => _networkService.sendMessage(
            message.copyWith(fileRef: url), state.chat));
  }

  @override
  TextEditingController messageInputController = TextEditingController();

  @override
  List<Message> get messages =>
      state.messages..sort((a, b) => b.millisSinceEpoch - a.millisSinceEpoch);

  @override
  ScrollController messageListController = ScrollController();

  @override
  Future<void> close() async {
    await _newMessagesSubscription?.cancel();
    await _messageUpdateSubscription?.cancel();
    await _statesSubscription?.cancel();
    return super.close();
  }
}