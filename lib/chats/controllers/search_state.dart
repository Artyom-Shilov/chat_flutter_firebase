import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

enum SearchStatus {
  init,
  loading,
  done,
  error
}

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required SearchStatus status,
    @Default([]) List<ChatInfo> searchResult,
    String? chatSearchErrorText,
    @Default('') message
}) = _SearchState;
}
