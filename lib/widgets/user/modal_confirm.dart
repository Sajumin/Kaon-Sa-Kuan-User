import 'package:flutter/material.dart';

const Color kWarmTangerine = Color(0xFFF47B42);
const Color kGoldenBorder  = Color(0xFFF9C06A);
const Color kCardBg        = Color(0xFFFFF5F0);

// Semantic action colours
const Color kApproveGreen    = Color(0xFF4CAF50);
const Color kApproveGreenBg  = Color(0xFFE8F5E9);
const Color kDeletePink      = Color(0xFFE91E63);
const Color kDeletePinkBg    = Color(0xFFFCE4EC);

/// Generic confirmation dialog used for approve / delete actions.
///
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => AdminConfirmModal(
///     icon: Icons.delete_outline_rounded,
///     iconColor: kDeletePink,
///     iconBgColor: kDeletePinkBg,
///     title: 'Remove This Resto?',
///     message: '"$name" will be permanently removed.',
///     confirmLabel: 'Yes, delete it.',
///     confirmColor: kDeletePink,
///     confirmBgColor: kDeletePinkBg,
///     onConfirm: () { Navigator.pop(context); },
///   ),
/// );
/// ```
class UserConfirmModal extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String message;
  final String confirmLabel;
  final Color confirmColor;
  final Color confirmBgColor;
  final VoidCallback onConfirm;

  const UserConfirmModal({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.confirmColor,
    required this.confirmBgColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon badge
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withOpacity(0.3), width: 2),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(height: 16),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Afacad',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Afacad',
                fontSize: 15,
                color: Colors.black.withOpacity(0.5),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                // Cancel
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.black.withOpacity(0.1), width: 1.5),
                      ),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Afacad',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Confirm
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: confirmBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: confirmColor, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          confirmLabel,
                          style: TextStyle(
                            fontFamily: 'Afacad',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: confirmColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}