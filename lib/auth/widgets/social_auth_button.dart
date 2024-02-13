import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({Key? key, required this.onPressed, required this.content, this.backgroundColor = Colors.white}) : super(key: key);

  final void Function()? onPressed;
  final Widget content;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: const CircleBorder(),
          elevation: 2
      ),
      onPressed: onPressed,
      child: content
    );
  }
}
