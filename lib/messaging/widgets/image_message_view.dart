import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:flutter/material.dart';

class ImageMessageView extends StatelessWidget {
  const ImageMessageView({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return message.fileRef != null
        ? CachedNetworkImage(
            imageUrl: message.fileRef!,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error_outline)))
        : const Center(child: Icon(Icons.downloading));
  }
}
