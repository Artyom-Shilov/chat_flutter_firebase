import 'package:flutter/material.dart';

abstract class SnackBars {

  static void showCommonSnackBar(String content, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: const EdgeInsets.all(25),
      content: Center(child: Text(content)),
    ));
  }
}