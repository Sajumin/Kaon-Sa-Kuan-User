import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final String text;

  const ReportCard({required this.text});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFFF28544);

    return Container(
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
        style: const TextStyle(
          fontFamily: 'Afacad',
          fontSize: 13,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }
}