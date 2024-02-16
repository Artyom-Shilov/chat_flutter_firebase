import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:flutter/cupertino.dart';

abstract interface class ChatSearchCubit extends Cubit<SearchState> {
  ChatSearchCubit(super.initialState);

  Future<void> searchChatsByName(String searchValue);

  Future<void> validateChatSearch();
  TextEditingController get chatSearchController;
  void resetChatSearchError();
  void clearSearchValue();
  void resetSearchResult();
}