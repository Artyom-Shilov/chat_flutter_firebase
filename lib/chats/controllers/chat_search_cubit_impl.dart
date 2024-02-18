import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/rest_network/network_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatSearchCubitImpl extends Cubit<SearchState> implements ChatSearchCubit {
  ChatSearchCubitImpl({required NetworkService networkService})
      : _networkService = networkService,
        super(const SearchState(status: SearchStatus.init));

  final NetworkService _networkService;

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
  Future<void> searchChatsByName(String searchValue) async {
    emit(state.copyWith(status: SearchStatus.loading));
    final searchResult = await _networkService.searchForChats(searchValue);
    emit(state.copyWith(status: SearchStatus.init, searchResult: searchResult));
  }
}