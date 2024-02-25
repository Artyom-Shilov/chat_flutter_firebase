import 'dart:async';
import 'dart:developer';

import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/database_events/database_events_listening.dart';
import 'package:chat_flutter_firebase/local_storage/local_models/local_chat_info.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatSearchCubitImpl extends Cubit<SearchState>
    implements ChatSearchCubit {
  ChatSearchCubitImpl({
    required NetworkService networkService,
    required LocalStorageService storageService,
    required NetworkConnectivity networkConnectivity,
    required DatabaseEventsListening eventsListening,
  })  : _networkService = networkService,
        _storageService = storageService,
        _networkConnectivity = networkConnectivity,
        _eventsListening = eventsListening,
        super(const SearchState(status: SearchStatus.init)) {
    _statesSubscription = stream.listen((event) {
      if (_addedUserChatSubscription == null &&
          event.status == SearchStatus.done &&
          _eventsListening.currentUserId != null) {
        _addedUserChatSubscription =
            _eventsListening.addedUserChatsStream().listen((event) {
          final index = state.searchResult
              .indexWhere((element) => element.chat.name == event.name);
          index != -1
              ? emit(state.copyWith(
                  searchResult: List.of(state.searchResult)
                    ..[index] = (chat: event, isJoined: true)))
              : null;
        });
      }
      if (_removedUserChatsSubscription == null &&
          event.status == SearchStatus.done &&
          _eventsListening.currentUserId != null) {
        _removedUserChatsSubscription =
            _eventsListening.deletedUserChatsStream().listen((event) {
          final index = state.searchResult
              .indexWhere((element) => element.chat.name == event.name);
          index != -1
              ? emit(state.copyWith(
                  searchResult: List.of(state.searchResult)
                    ..[index] = (chat: event, isJoined: false)))
              : null;
        });
      }
    });
  }

  final NetworkService _networkService;
  StreamSubscription<ChatInfo>? _addedUserChatSubscription;
  StreamSubscription<ChatInfo>? _removedUserChatsSubscription;

  final LocalStorageService _storageService;
  final NetworkConnectivity _networkConnectivity;
  final DatabaseEventsListening _eventsListening;
  StreamSubscription<SearchState>? _statesSubscription;

  @override
  TextEditingController chatSearchController = TextEditingController();

  @override
  void resetChatSearchError() {
    emit(state.copyWith(chatSearchErrorText: null));
  }

  @override
  void clearSearchValue() {
    chatSearchController.clear();
  }

  @override
  Future<void> validateChatSearch() async {
    final searchValue = chatSearchController.text;
    if (!await _networkConnectivity.checkNetworkConnection()) {
      emit(state.copyWith(chatSearchErrorText: ChatErrorsTexts.noConnectionRU));
      return;
    }
    if (searchValue.isEmpty) {
      emit(state.copyWith(
          chatSearchErrorText: ChatTexts.chatSearchLengthFieldErrorRu));
      return;
    }
    emit(state.copyWith(chatSearchErrorText: null));
  }

  @override
  void resetSearchResult() {
    emit(state.copyWith(searchResult: [], status: SearchStatus.init));
  }

  @override
  Future<void> searchChatsByName(UserInfo userInfo) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      if (!await _networkConnectivity.checkNetworkConnection()) {
        emit(state.copyWith(
            status: SearchStatus.error,
            message: ChatErrorsTexts.noConnectionRU));
        return;
      }
      final foundChats = await _networkService.searchForChats(chatSearchController.text);
      final userChatNames =
          ((await _networkService.getChatsByUser(userInfo.id)))
              .map((e) => e.name)
              .toList();
      final searchResults = foundChats
          .map((e) => (chat: e, isJoined: userChatNames.contains(e.name)))
          .toList();
      emit(state.copyWith(
          status: SearchStatus.done, searchResult: searchResults));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: SearchStatus.error, message: ChatErrorsTexts.searchChats));
    }
  }

  @override
  Future<void> joinChat(ChatInfo chatInfo, UserInfo userInfo) async {
    try {
      if (!await _networkConnectivity.checkNetworkConnection()) {
        emit(state.copyWith(
            status: SearchStatus.error,
            message: ChatErrorsTexts.noConnectionRU));
        return;
      }
      await _networkService.joinChat(chatInfo, userInfo);
      _storageService.addUserChat(LocalChatInfo.fromChatInfo(chatInfo));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(
          status: SearchStatus.error, message: ChatErrorsTexts.joinChatRu));
    }
  }

  @override
  Future<void> close() async {
    await _addedUserChatSubscription?.cancel();
    await _statesSubscription?.cancel();
    await super.close();
  }

  @override
  List<({ChatInfo chat, bool isJoined})> get searchResult =>
      state.searchResult..sort((a, b) => a.chat.name.compareTo(b.chat.name));

  @override
  Future<void> setStateStatus({Duration? delay, required SearchStatus status}) async {
    delay != null
        ? await Future.delayed(delay)
        : null;
    emit(state.copyWith(status: status));
  }
}
