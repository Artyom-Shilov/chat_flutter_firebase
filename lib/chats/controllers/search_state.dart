import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';
part 'search_state.g.dart';

enum SearchStatus {
  init,
  loading,
  done,
  error
}

@Freezed(makeCollectionsUnmodifiable: false)
class SearchState with _$SearchState {
  const factory SearchState({
    required SearchStatus status,
    @Default([]) List<({ChatInfo chat, bool isJoined})> searchResult,
    @Default('') message,
  }) = _SearchState;

  factory SearchState.fromJson(Map<String, dynamic> json) =>
      _$SearchStateFromJson(json);
}
