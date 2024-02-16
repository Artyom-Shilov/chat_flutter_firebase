import 'package:chat_flutter_firebase/chats/controllers/chat_search_cubit.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatSearchCubitImpl extends Cubit<SearchState> implements ChatSearchCubit {
  ChatSearchCubitImpl(super.initialState);

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
  // TODO: implement chatSearchController
  TextEditingController get chatSearchController => throw UnimplementedError();

  @override
  Future<void> searchChatsByName(String searchValue) {
    // TODO: implement searchChatsByName
    throw UnimplementedError();
  }
  
}