import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/app_models/user_info.dart';
import 'package:chat_flutter_firebase/common/app_text.dart';
import 'package:chat_flutter_firebase/common/date_formatting.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/widgets/cached_avatar.dart';
import 'package:chat_flutter_firebase/common/widgets/loading_animation.dart';
import 'package:chat_flutter_firebase/messaging/widgets/image_message_view.dart';
import 'package:chat_flutter_firebase/messaging/widgets/video_message_view.dart';
import 'package:flutter/material.dart';

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
    final userName = senderInfo?.name ?? senderInfo?.email ?? senderInfo?.id ?? '';
    final width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          isAnotherMember
              ? CachedAvatar(
                  photoUrl: senderInfo?.photoUrl,
                  name: userName,
                  placeholderWidget:
                      LoadingAnimation(color: Theme.of(context).primaryColor),
                  radius: 25)
              : const Spacer(),
          const SizedBox(width: 15),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width * 0.7),
                  child: Column(
              crossAxisAlignment: isAnotherMember ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                if (isAnotherMember) ...[
                  Text(
                      senderInfo?.name ??
                          senderInfo?.email ??
                          senderInfo?.id ??
                          '',
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: Sizes.verticalInset2)
                ],
                Card(
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: senderInfo == null
                          ? const Text(MessagingTexts.memberLeftChatRu,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500))
                          : switch (message.type) {
                              MessageType.text => Text(message.text ?? '',
                                  style: const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w500)),
                              MessageType.video =>
                                VideoMessageView(message: message),
                              MessageType.image =>
                                ImageMessageView(message: message)
                            }),
                ),
                const SizedBox(height: Sizes.verticalInset2),
                Text(DateFormatter.I.formatDate(message.millisSinceEpoch),
                    style: const TextStyle(color: Colors.black54, fontSize: 11)),
              ],
            ),
          ),
          if (!isAnotherMember) ...[
            const SizedBox(width: 15),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: CachedAvatar(
                photoUrl: senderInfo?.photoUrl,
                name: userName,
                radius: 25,
                placeholderWidget:
                    LoadingAnimation(color: Theme.of(context).primaryColor),
              ),
            )
          ],
        ],
      ),
    );
  }
}
