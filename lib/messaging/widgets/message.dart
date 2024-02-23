import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/common/date_formatting.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/messaging/controllers/video_message_cubit.dart';
import 'package:chat_flutter_firebase/messaging/controllers/video_message_cubit_impl.dart';
import 'package:chat_flutter_firebase/messaging/widgets/image_message_view.dart';
import 'package:chat_flutter_firebase/messaging/widgets/video_message_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {Key? key,
      required this.message,
      required this.senderInfo,
      required this.isAnotherMember})
      : super(key: key);

  final Message message;
  final UserInfo? senderInfo;
  final bool isAnotherMember;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: isAnotherMember ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width * 0.60),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: isAnotherMember
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Theme.of(context).primaryColor.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    senderInfo?.name ??
                        senderInfo?.email ??
                        senderInfo?.id ??
                        '',
                    style: TextStyle(color: Colors.lightBlue.shade800)),
                const SizedBox(height: Sizes.verticalInset2),
                if (message.type == MessageType.text) Text(message.text ?? ''),
                if (message.type == MessageType.image)
                  ImageMessageView(message: message),
                if (message.type == MessageType.video)
                  VideoMessageView(message: message),
                const SizedBox(height: Sizes.verticalInset2),
                Text(
                  DateFormatter.I.formatDate(message.millisSinceEpoch),
                  style: const TextStyle(color: Colors.black54, fontSize: 11),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
