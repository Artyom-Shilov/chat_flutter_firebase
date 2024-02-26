import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter_firebase/app_models/message.dart';
import 'package:chat_flutter_firebase/common/sizes.dart';
import 'package:chat_flutter_firebase/common/widgets/loading_animation.dart';
import 'package:flutter/material.dart';

class ImageMessageView extends StatelessWidget {
  const ImageMessageView({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return message.fileRef != null
        ? CachedNetworkImage(
            imageUrl: message.fileRef!,
            placeholder: (context, url) => Padding(
              padding: const EdgeInsets.all(Sizes.verticalInset1),
              child: Center(
                  child: LoadingAnimation(color: Theme.of(context).primaryColor)),
            ),
            errorWidget: (context, url, error) =>
                const Padding(
                  padding: EdgeInsets.all(Sizes.verticalInset1),
                  child: Center(child: Icon(Icons.error_outline)),
                ))
        : Padding(
            padding: const EdgeInsets.all(Sizes.verticalInset1),
            child: Center(
                child: LoadingAnimation(
              color: Theme.of(context).primaryColor)),
        );
  }
}
