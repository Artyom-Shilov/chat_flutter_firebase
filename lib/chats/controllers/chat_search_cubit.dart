import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/chats/controllers/search_state.dart';
import 'package:flutter/cupertino.dart';

abstract interface class ChatSearchCubit extends Cubit<SearchState> {
  ChatSearchCubit(super.initialState);

  Future<void> searchChatsByName(String searchValue, UserInfo userInfo);
  Future<void> joinChat(ChatInfo chatInfo, UserInfo userInfo);

  Future<void> validateChatSearch();
  TextEditingController get chatSearchController;
  void resetChatSearchError();
  void clearSearchValue();
  void resetSearchResult();
}