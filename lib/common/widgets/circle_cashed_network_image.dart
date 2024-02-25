import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleCashedNetworkImage extends StatelessWidget {

  const CircleCashedNetworkImage(
      {Key? key,
      required this.url,
      this.errorWidget = const Icon(Icons.error_outline),
      this.placeholder = const CircularProgressIndicator(),
      required this.radius})
      : super(key: key);

  final String url;
  final Widget placeholder;
  final Widget errorWidget;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Center(child: placeholder),
      errorWidget: (context, url, error) => Center(child: errorWidget),
    );
  }
}
