import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
//import '../../screens/user/user_resto_details.dart';

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: const Color(0xFFF28544)),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: const Color(0xFFF28544),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class TagChip extends StatelessWidget {
  final String label;

  const TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF28544).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: const Color(0xFFF28544),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
} 