import 'package:chat_flutter_firebase/messaging/controllers/video_message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

abstract interface class VideoMessageCubit extends Cubit<VideoMessageState>{
  VideoMessageCubit(super.initialState);
  Future<void> init();
  Future<void> pause();
  Future<void> play();
  VideoPlayerController get playerController;
}