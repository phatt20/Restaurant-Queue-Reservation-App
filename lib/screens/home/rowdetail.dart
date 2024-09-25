import 'package:chat/screens/home/rowbuilder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Rowdetail extends StatelessWidget {
  final String text;
  final String rating;
  final bool star;
  final Color? color;
  const Rowdetail({
    super.key,
    required this.text,
    required this.rating,
    this.star = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (star)
              Icon(
                Icons.star_rate,
                size: 22,
                color: Colors.yellow,
                shadows: [
                  Shadow(
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
            const SizedBox(
              width: 5,
            ),
            Text(
              rating,
              style: GoogleFonts.notoSansThai(
                fontSize: 16,
                color: color ?? Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            SizedBox(
              width: 120,
              child: Text(
                text,
                style: GoogleFonts.notoSansThai(
                  fontSize: 18,
                  color: color ?? Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 35,
        ),
        const Row(
          children: [
            Rowbuilder(count: 1, text: "ไก่ทอด"),
            SizedBox(
              width: 10,
            ),
            Rowbuilder(
              count: 1,
              text: "อร่อยมาก",
              boxWidth: 80,
            ),
          ],
        ),
      ],
    );
  }
}
