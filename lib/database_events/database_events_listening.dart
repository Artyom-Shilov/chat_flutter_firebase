import 'package:chat_flutter_firebase/app_models/chat_info.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';

abstract interface class DatabaseEventsListening {

  String? currentUserId;
  Stream<Message> chatMessagesStream(ChatInfo chatInfo);
  Stream<dynamic> newMembersInChatStream(ChatInfo chatInfo);
  Stream<ChatInfo> userChatsUpdates();
}