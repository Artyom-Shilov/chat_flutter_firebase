import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/widgets/loading_animation.dart';
import 'package:chat_flutter_firebase/messaging/controllers/video_message_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/video_message_cubit_impl.dart';
import 'package:chat_flutter_firebase/messaging/widgets/video_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoMessageView extends StatelessWidget {
  const VideoMessageView({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return message.fileRef != null
        ? BlocProvider<VideoMessageCubit>(
            create: (context) =>
                VideoMessageCubitImpl(videoUrl: message.fileRef!),
            child: const VideoItem())
        : Padding(
          padding: const EdgeInsets.all(Sizes.verticalInset1),
            child: Center(
                child: LoadingAnimation(
                    color: Theme.of(context).primaryColor)),
          );
  }
}
