import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryText extends StatefulWidget {
  @override
  _SummaryTextState createState() => _SummaryTextState();
}

class _SummaryTextState extends State<SummaryText> {
  bool isExpanded = false;

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'summary',
            style: GoogleFonts.notoSansThai(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 8), // เพิ่มช่องว่างระหว่าง texts
          Text(
            'This is a detailed description of the summary. ${isExpanded ? 'Here is more detailed text that is shown when "more" is clicked. ' : ''}Click on ${isExpanded ? 'less' : 'more'} to show ${isExpanded ? 'less' : 'more'} text.',
            style: GoogleFonts.notoSansThai(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5),
          ),
          TextButton(
            onPressed: toggleExpand,
            child: Text(isExpanded ? 'less' : 'more'),
          ),
        ],
      ),
    );
  }
}
