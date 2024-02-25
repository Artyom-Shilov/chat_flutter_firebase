import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:isar/isar.dart';

part 'local_message.g.dart';


@collection
class LocalMessage {

  LocalMessage._(this.messageId, this.senderId, this.type,
      this.millisSinceEpoch, this.chatName);

  LocalMessage({
    required this.messageId,
    required this.senderId,
    required this.type,
    required this.millisSinceEpoch,
    required this.chatName,
    this.text
  });

  Id isarId = Isar.autoIncrement;
  @Index()
  String messageId;
  @Index(composite: [CompositeIndex('messageId')])
  String chatName;
  String senderId;
  @enumerated
  MessageType type;
  int millisSinceEpoch;
  String? text;

  factory LocalMessage.fromMessageAndChatInfo(Message message, ChatInfo chatInfo) {
    return LocalMessage(
      chatName: chatInfo.name,
      messageId: message.id,
      senderId: message.senderId,
      millisSinceEpoch: message.millisSinceEpoch,
      type: message.type,
      text: message.text
    );
  }
}