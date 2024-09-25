import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final double minWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.height,
    required this.onPressed,
    this.textStyle,
    required this.minWidth, required int width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Center(
            child: Container(
              constraints: BoxConstraints(minWidth: minWidth),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // ปรับตามความต้องการ
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: textStyle ??
                    TextStyle(
                      color: textColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
