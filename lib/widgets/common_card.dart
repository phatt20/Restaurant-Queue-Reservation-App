import 'package:flutter/material.dart';

class CommonCardState extends StatefulWidget {
  const CommonCardState(
      {super.key, this.color, required this.radius, this.child});
  final Color? color;
  final double radius;
  final Widget? child;
  @override
  State<StatefulWidget> createState() {
    return _CommonCardState();
  }
}

class _CommonCardState extends State<CommonCardState> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius)),
      child: widget.child,
    );
  }
}
