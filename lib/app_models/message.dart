import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';


enum MessageType {
  text,
  image,
  video
}

@freezed
class Message with _$Message {
  const factory Message({
    @JsonKey(includeToJson: false)required String id,
    required String senderId,
    required MessageType type,
    required int millisSinceEpoch,
    String? fileRef,
    String? text,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
