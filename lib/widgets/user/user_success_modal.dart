import 'package:flutter/material.dart';

class UserSuccessModal extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  const UserSuccessModal({
    super.key,
    required this.title,
    required this.message,
    this.buttonLabel = 'Got it!',
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF4CAF50),
            size: 60,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Afacad',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Afacad',
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF47B42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              buttonLabel,
              style: const TextStyle(
                fontFamily: 'Afacad',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
