import 'package:chat_flutter_firebase/app_models/message.dart';
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
        : const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Icon(Icons.downloading)),
        );
  }
}
