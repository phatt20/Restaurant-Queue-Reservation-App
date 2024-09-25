import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Rowbuilder extends StatelessWidget {
  final int count;
  final String text;
  final double boxWidth;
  final Color? textColor;

  const Rowbuilder({
    super.key,
    required this.count,
    required this.text,
    this.boxWidth = 60.0,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(40),
          ),
          width: boxWidth,
          child: Center(
            // Centering the text
            child: Text(
              text,
              style: GoogleFonts.notoSansThai(
                fontSize: 14,
                color: textColor ?? Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}
