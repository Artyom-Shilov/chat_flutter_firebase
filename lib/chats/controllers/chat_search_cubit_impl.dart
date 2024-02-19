import 'dart:developer';

import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/connectivity/network_connectivity.dart';
import 'package:chat_flutter_firebase/local_storage/services/local_storage_service.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatSearchCubitImpl extends Cubit<SearchState> implements ChatSearchCubit {
  ChatSearchCubitImpl({
    required NetworkService networkService,
    required LocalStorageService storageService,
    required NetworkConnectivity networkConnectivity
  })
      : _networkService = networkService,
        _storageService = storageService,
        _networkConnectivity = networkConnectivity,
        super(const SearchState(status: SearchStatus.init));

  final NetworkService _networkService;
  final LocalStorageService _storageService;
  final NetworkConnectivity _networkConnectivity;

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
      emit(state.copyWith(chatSearchErrorText: ChatTexts.chatSearchLengthFieldErrorRu));
      return;
    }
    emit(state.copyWith(chatSearchErrorText: null));
  }

  @override
  void resetSearchResult() {
    emit(state.copyWith(searchResult: [], status: SearchStatus.init));
  }

  @override
  Future<void> searchChatsByName(String searchValue, UserInfo userInfo) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      if (!await _networkConnectivity.checkNetworkConnection()) {
        emit(state.copyWith(status: SearchStatus.error,
            message: ChatErrorsTexts.noConnectionRU));
        return;
      }
      final foundChats = await _networkService.searchForChats(searchValue);
      final userChatNames =
          ((await _storageService.getChatsByUser(userInfo.id))?.chats ?? [])
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

      final listForUpdate = List.of(state.searchResult);
      final index = listForUpdate.indexOf((chat: chatInfo, isJoined: false));
      print(index);
      listForUpdate[index] = (chat: chatInfo, isJoined: true);
      emit(state.copyWith(searchResult: listForUpdate));
    } catch (e, stackTrace) {
      log(stackTrace.toString());
      emit(state.copyWith(status: SearchStatus.error, message: ChatErrorsTexts.joinChatRu));
    }
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}