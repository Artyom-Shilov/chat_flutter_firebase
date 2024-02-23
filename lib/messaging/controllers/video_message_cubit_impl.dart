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
    await _controller.initialize();
    await _controller.setLooping(true);
    emit(state.copyWith(status: VideoMessageStatus.ready));
  }

  @override
  VideoPlayerController get playerController => _controller;

  @override
  Future<void> pause() async {
    await playerController.pause();
    emit(state.copyWith(isPlaying: false));
  }

  @override
  Future<void> play() async {
    await playerController.play();
    emit(state.copyWith(isPlaying: true));
  }

  @override
  Future<void> close() async {
    await _controller.dispose();
    return super.close();
  }
}