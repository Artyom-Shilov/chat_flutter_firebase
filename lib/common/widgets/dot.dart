import 'package:flutter/material.dart';

class Dot extends StatelessWidget {

  const Dot({Key? key, required double dotSize, required this.color})
      : width = dotSize,
        height = dotSize,
        super(key: key);

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}