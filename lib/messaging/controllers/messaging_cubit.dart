import 'package:bloc/bloc.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/messaging/controllers/messaging_state.dart';

abstract interface class MessagingCubit extends Cubit<MessagingState> {
  MessagingCubit(super.initialState);
  Future<void> sendTextMessage(Message message);
  Future<void> notifyChatUsers(Message message, UserInfo appUser);
  Future<List<Message>> loadChatMessages();
  Future<List<UserInfo>> loadChatUsers();
  Future<void> init();
}