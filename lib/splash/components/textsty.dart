import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleFontText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  const GoogleFontText({
    super.key,
    required this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.lato(
          textStyle: textStyle ??
              const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ), // ใช้ Google Fonts ตามต้องการ หรือเพิ่มตามตัวอย่าง
        ));
  }
}
