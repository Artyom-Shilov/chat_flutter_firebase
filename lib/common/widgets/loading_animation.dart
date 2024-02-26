import 'package:chat_flutter_firebase/common/widgets/dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoadingAnimation extends HookWidget {
  final double size;
  final Color color;

  const LoadingAnimation({
    Key? key,
    required this.color,
    this.size = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationController =
        useAnimationController(duration: const Duration(seconds: 1))..repeat();
    final double dotSize = size * 0.17;
    final double gapBetweenDots = (size - (4 * dotSize)) / 3;
    final double previousDotPosition = -(gapBetweenDots + dotSize);
    final shrinkTween = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0, 0.4),
    ));
    final growingTween = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: animationController, curve: const Interval(0.3, 0.7)));
    final dotShiftTween =
        Tween<Offset>(begin: Offset.zero, end: Offset(previousDotPosition, 0))
            .animate(CurvedAnimation(
                parent: animationController,
                curve: const Interval(0.22, 0.82)));
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Transform.scale(
                scale: shrinkTween.value,
                child: Dot(
                  color: color,
                  dotSize: dotSize,
                ),
              ),
              ShiftingDot(
                  animation: dotShiftTween, color: color, dotSize: dotSize),
              ShiftingDot(
                  animation: dotShiftTween, color: color, dotSize: dotSize),
              Stack(
                children: <Widget>[
                  Transform.scale(
                    scale: growingTween.value,
                    child: Dot(
                      color: color,
                      dotSize: dotSize,
                    ),
                  ),
                  ShiftingDot(
                      animation: dotShiftTween, color: color, dotSize: dotSize),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class ShiftingDot extends StatelessWidget {
  const ShiftingDot(
      {Key? key,
      required this.animation,
      required this.color,
      required this.dotSize})
      : super(key: key);

  final Animation<Offset> animation;
  final Color color;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: animation.value, child: Dot(dotSize: dotSize, color: color));
  }
}
