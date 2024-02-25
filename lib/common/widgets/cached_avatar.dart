import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedAvatar extends StatelessWidget {
  const CachedAvatar(
      {Key? key,
      required this.photoUrl,
      required this.name,
      required this.radius,
      this.errorWidget = const Icon(Icons.error_outline),
      this.placeholderWidget = const CircularProgressIndicator()})
      : super(key: key);

  final String? photoUrl;
  final String name;
  final Widget placeholderWidget;
  final Widget errorWidget;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return photoUrl == null
        ? CircleAvatar(
            radius: radius,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
            child: Center(
                child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )))
        : CachedNetworkImage(
            imageUrl: photoUrl!,
            imageBuilder: (context, imageProvider) => Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
            placeholder: (context, url) => Center(child: placeholderWidget),
            errorWidget: (context, url, error) => Center(child: errorWidget));
  }
}
