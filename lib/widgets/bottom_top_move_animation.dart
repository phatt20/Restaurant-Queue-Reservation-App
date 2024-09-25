import 'package:flutter/material.dart';

class BottomTopMoveAnimation extends StatelessWidget {
  const BottomTopMoveAnimation({
    super.key,
    required this.animationController,
    required this.child,
  });

  final AnimationController animationController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animationController,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 40 * (1.0 - animationController.value), 0.0),
            child: this.child, // Ensure using this.child instead of child
          ),
        );
      },
    );
  }
}
