import 'dart:developer';

import 'package:chat_flutter_firebase/messaging/controllers/video_message_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/video_message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoMessageCubitImpl extends Cubit<VideoMessageState> implements VideoMessageCubit {
  VideoMessageCubitImpl({required this.videoUrl})
      : super(const VideoMessageState(status: VideoMessageStatus.loading)) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
  }

  final String videoUrl;
  late final VideoPlayerController _controller;


  @override
  Future<void> init() async {
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      emit(state.copyWith(status: VideoMessageStatus.ready));

    } catch (e, printStack) {
      log(printStack.toString());
    }
  }

  @override
  VideoPlayerController get playerController => _controller;

  @override
  Future<void> pause() async {
    try {
      await playerController.pause();
      emit(state.copyWith(isPlaying: false));
    } catch (e, printStack) {
      log(printStack.toString());
    }
  }

  @override
  Future<void> play() async {
    try {
    await playerController.play();
    emit(state.copyWith(isPlaying: true));
    } catch (e, printStack) {
      log(printStack.toString());
    }
  }

  @override
  Future<void> close() async {
    await _controller.dispose();
    return super.close();
  }
}