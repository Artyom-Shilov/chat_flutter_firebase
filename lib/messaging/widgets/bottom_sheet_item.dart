import 'package:flutter/material.dart';

class BottomSheetItem extends StatelessWidget {
  const BottomSheetItem(
      {Key? key,
      required this.text,
      required this.icon,
      this.onTap,
      required this.isBottomLined})
      : super(key: key);

  final String text;
  final Widget icon;
  final Function()? onTap;
  final bool isBottomLined;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 30),
      shape: isBottomLined ? const Border(bottom: BorderSide()) : null,
      onTap: onTap,
      leading: icon,
      title: Text(text),
    );
  }
}
