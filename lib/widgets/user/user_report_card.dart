import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatelessWidget {
  final String text;
  final DateTime timestamp;

  const ReportCard({
    super.key,
    required this.text,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFFF28544);
    String formattedTime;
    DateTime now = DateTime.now();

    if (timestamp.day == now.day && timestamp.month == now.month && timestamp.year == now.year) {
      formattedTime = DateFormat('h:mm a').format(timestamp);
    } else {
      formattedTime = DateFormat('MMM d, h:mm a').format(timestamp);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: themeColor.withOpacity(0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 8, top: 4),
          child: Text(
            formattedTime,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}