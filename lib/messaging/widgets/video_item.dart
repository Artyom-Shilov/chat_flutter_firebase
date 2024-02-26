import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/widgets/loading_animation.dart';
import 'package:chat_flutter_firebase/messaging/controllers/video_message_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/video_message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends HookWidget {
  const VideoItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<VideoMessageCubit>(context);
    final controller = cubit.playerController;
    useEffect(() {
      cubit.init();
      return null;
    });
    return BlocBuilder<VideoMessageCubit, VideoMessageState>(
        builder: (context, state) {
      return state.status == VideoMessageStatus.loading
          ? Padding(
            padding: const EdgeInsets.all(Sizes.verticalInset1),
            child: Center(child: LoadingAnimation(color: Theme.of(context).primaryColor)),
          )
          : Stack(
              alignment: AlignmentDirectional.center,
              children: [
                AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller)),
                IconButton(
                  color: Colors.white60,
                  onPressed: () async {
                    state.isPlaying ? await cubit.pause() : await cubit.play();
                  },
                  icon: state.isPlaying
                      ? const Icon(Icons.pause, size: 30)
                      : const Icon(Icons.play_arrow, size: 30),
                )
              ],
            );
    });
  }
}
