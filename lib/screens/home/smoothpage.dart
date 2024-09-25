import 'package:flutter/material.dart';

class SmoothPageIndicator extends StatefulWidget {
  final PageController controller;
  final int count;

  const SmoothPageIndicator({
    super.key,
    required this.controller,
    required this.count,
  });

  @override
  _SmoothPageIndicatorState createState() => _SmoothPageIndicatorState();
}

class _SmoothPageIndicatorState extends State<SmoothPageIndicator> {
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.controller.initialPage;
    widget.controller.addListener(_pageListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_pageListener);
    super.dispose();
  }

  void _pageListener() {
    setState(() {
      currentPage = widget.controller.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.count,
        (index) => buildDot(index: index),
      ),
    );
  }

  Widget buildDot({required int index}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentPage == index ? Colors.white : Colors.white54,
      ),
    );
  }
}
