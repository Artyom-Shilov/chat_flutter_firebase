import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/common/id_generation.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/database_events/database_events_listening.dart';
import 'package:chat_flutter_firebase/files_handling/database_file_handler.dart';
import 'package:chat_flutter_firebase/files_handling/firebase_file_handler.dart';
import 'package:chat_flutter_firebase/files_handling/local_file_handler.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_chat_member.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_message.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_state.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter/material.dart';

class MessagingCubitImpl extends Cubit<MessagingState>
    implements MessagingCubit {
  MessagingCubitImpl(
      {required ChatInfo chat,
      required NetworkConnectivity networkConnectivity,
      required LocalStorageService localStorageService,
      required NetworkService networkService,
      required DatabaseEventsListening eventsListening,
      required DatabaseFileHandler databaseFileHandler,
      required LocalFileHandler localFileHandler})
      : _networkConnectivity = networkConnectivity,
        _localStorageService = localStorageService,
        _networkService = networkService,
        _eventsListening = eventsListening,
        _databaseFileHandler = databaseFileHandler,
        _localFileHandler = localFileHandler,
        super(MessagingState(status: MessagingStatus.loading, chat: chat)) {
    _statesSubscription = stream.listen((event) {
      if (_newMessagesSubscription == null &&
          event.status == MessagingStatus.ready) {
        _newMessagesSubscription = _eventsListening
            .addedMessagesStream(state.chat)
            .skip(_messageNumberAfterLoad)
            .listen((event) {

          emit(state.copyWith(messages: List.of(state.messages)..add(event)));
        });
      }
      if (_messageUpdateSubscription == null &&
          event.status == MessagingStatus.ready) {
        _messageUpdateSubscription =
            _eventsListening.updatedMessageStream(state.chat).listen((event) {
          final indexForUpdate =
              state.messages.indexWhere((element) => element.id == event.id);
          emit(state.copyWith(
              messages: List.of(state.messages)..[indexForUpdate] = event));
        });
      }
      if (_newMembersSubscription == null &&
          event.status == MessagingStatus.ready) {
        _newMembersSubscription = _eventsListening
            .addedChatMemberStream(state.chat)
            .skip(_membersNumberAfterLoad)
            .listen((event) {
          emit(state.copyWith(members: List.of(state.members)..add(event)));
        });
      }
      if (_newMembersSubscription == null &&
          event.status == MessagingStatus.ready) {
        _newMembersSubscription = _eventsListening
            .addedChatMemberStream(state.chat)
            .skip(_membersNumberAfterLoad)
            .listen((event) {
          emit(state.copyWith(members: List.of(state.members)..add(event)));
        });
      }
      if (_deletedMembersSubscription == null &&
          event.status == MessagingStatus.ready) {
        _deletedMembersSubscription = _eventsListening
            .deletedChatMemberStream(state.chat)
            .listen((event) {
          emit(state.copyWith(
              members: List.of(state.members)
                ..removeWhere((element) => element.id == event.id)));
        });
      }
    });
  }

  final NetworkService _networkService;
  final LocalStorageService _localStorageService;
  final NetworkConnectivity _networkConnectivity;
  final DatabaseEventsListening _eventsListening;
  final DatabaseFileHandler _databaseFileHandler;
  final LocalFileHandler _localFileHandler;
  StreamSubscription<Message>? _newMessagesSubscription;
  StreamSubscription<Message>? _messageUpdateSubscription;
  StreamSubscription<UserInfo>? _newMembersSubscription;
  StreamSubscription<UserInfo>? _deletedMembersSubscription;
  StreamSubscription<MessagingState>? _statesSubscription;
  late int _messageNumberAfterLoad;
  late int _membersNumberAfterLoad;

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
    await _networkService.updateUserChats(infoForUpdate, state.members);
  }

  @override
  Future<void> init() async {
    emit(state.copyWith(status: MessagingStatus.loading));
    List<UserInfo> members = [];
    List<Message> messages = [];
    try {
      if (await _networkConnectivity.checkNetworkConnection()) {
        members = await _networkService.getChatMembers(state.chat);
        messages = await _networkService.getChatMessages(state.chat);
        _localStorageService.saveChatMembers(members
            .map((e) => LocalChatMember.fromUserAndChatInfo(e, state.chat))
            .toList());
        _localStorageService.saveChatMessages(messages
            .map((e) => LocalMessage.fromMessageAndChatInfo(e, state.chat))
            .toList());
      } else {
        final localChatMembers = await _localStorageService.getChatMembers(
            state.chat.name);
        final localChatMessages = await _localStorageService.getChatMessages(
            state.chat.name);
        members = localChatMembers.map((e) => UserInfo.fromLocalChatMember(e))
            .toList();
        messages =
            localChatMessages.map((e) => Message.fromLocalMessage(e)).toList();
      }
      _messageNumberAfterLoad = messages.length;
      _membersNumberAfterLoad = members.length;
      emit(state.copyWith(
          status: MessagingStatus.ready, messages: messages, members: members));
    } catch (e, printStack) {
      log(printStack.toString());
      emit(state.copyWith(
          status: MessagingStatus.error,
          info: MessagingErrorsTexts.loadMessagesRu));
    }
  }

  @override
  Future<void> sendTextMessage(UserInfo sender) async {
    if (!await _networkConnectivity.checkNetworkConnection()) {
      emit(state.copyWith(
          status: MessagingStatus.error,
          info: MessagingErrorsTexts.noConnectionRu));
      return;
    }
      await _sendMessage(sender, MessageType.text, null);
  }

  @override
  Future<void> sendImageFromGallery(UserInfo sender) async {
    if (!await _networkConnectivity.checkNetworkConnection()) {
      emit(state.copyWith(
          status: MessagingStatus.error,
          info: MessagingErrorsTexts.noConnectionRu));
      return;
    }
      final image = await _localFileHandler.pickImageFromGallery();
      if (image == null) {
        return;
      }
      await _sendMessage(sender, MessageType.image, image);
  }

  @override
  Future<void> sendImageFromCamera(UserInfo sender) async {
    if (!await _networkConnectivity.checkNetworkConnection()) {
      emit(state.copyWith(
          status: MessagingStatus.error,
          info: MessagingErrorsTexts.noConnectionRu));
      return;
    }
    final image = await _localFileHandler.pickImageFromCamera();
    if (image == null) {
      return;
    }
    await _sendMessage(sender, MessageType.image, image);
  }

  @override
  Future<void> sendVideoFromGallery(UserInfo sender) async {
    if (!await _networkConnectivity.checkNetworkConnection()) {
      emit(state.copyWith(
          status: MessagingStatus.error,
          info: MessagingErrorsTexts.noConnectionRu));
      return;
    }
    final video = await _localFileHandler.pickVideoFromGallery();
    if (video == null) {
      return;
    }
    await _sendMessage(sender, MessageType.video, video);
  }

  Future<void> _sendMessage(
      UserInfo sender, MessageType type, File? file) async {
    try {
      final messageId = IdGenerator.I.generateUuidV1();
      final messageText = messageInputController.text.trim();
      final message = Message(
          id: messageId,
          senderId: sender.id,
          text: type == MessageType.text ? messageText : null,
          type: type,
          millisSinceEpoch: DateTime.now().millisecondsSinceEpoch);
      await _networkService.sendMessage(message, state.chat);
      final String lastMessageText = switch (type) {
        MessageType.text => messageText,
        MessageType.image => '📷',
        MessageType.video => '🎞️'
      };
      await _notifyChatUsers(
          lastUserName: sender.name ?? sender.email ?? sender.id,
          lastMessageText: lastMessageText,
          lastMessageTime: message.millisSinceEpoch,
          sender: sender);
      messageListController.animateTo(
        0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );
      _localStorageService.addChatMessage(
          LocalMessage.fromMessageAndChatInfo(message, state.chat));
      if (type == MessageType.text || file == null) {
        return;
      }
      final String folder = switch (type) {
        MessageType.text => '',
        MessageType.image => '${Folders.images}',
        MessageType.video => '${Folders.video}'
      };
      _databaseFileHandler
          .uploadFile(file, '$folder/$messageId')
          .then(
              (_) => _databaseFileHandler.getDownloadUrl('$folder/$messageId'))
          .then((url) => _networkService.sendMessage(
              message.copyWith(fileRef: url), state.chat));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: MessagingStatus.error,
          info: MessagingErrorsTexts.sendMessageRu));
    }
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
    await _newMembersSubscription?.cancel();
    await _deletedMembersSubscription?.cancel();
    await _messageUpdateSubscription?.cancel();
    await _statesSubscription?.cancel();
    return super.close();
  }

  @override
  Future<void> setStateStatus({Duration? delay, required MessagingStatus status}) async {
    delay != null
        ? await Future.delayed(delay)
        : null;
    emit(state.copyWith(status: status));
  }

  @override
  void updateInputFieldStatus(bool isEmpty) {
    emit(state.copyWith(isTextFieldEmpty: isEmpty));
  }

  @override
  void clearInput() {
    emit(state.copyWith(isTextFieldEmpty: true));
    messageInputController.clear();
  }
}