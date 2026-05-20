import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionScreen extends StatelessWidget {
  final String questionText;
  final int currentIndex;
  final int total;
  final List<String> choices;
  final String mascotImage;
  final void Function(String) onChoiceTap;
  final VoidCallback onBack;
  final bool isTiebreaker;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext; // optional — choices handle next normally

  const QuestionScreen({
    super.key,
    required this.questionText,
    required this.currentIndex,
    required this.total,
    required this.choices,
    required this.onChoiceTap,
    required this.onBack,
    required this.isTiebreaker,
    required this.onPrevious,
    required this.onNext, 
    required this.mascotImage,
  });

  static const themeColor = Color(0xFFF28544);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Top Bar ─────────────────────────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: onBack,
                  child: const Icon(Icons.arrow_back, size: 24),
                ),

                const SizedBox(height: 16),

                // Question counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: onPrevious,
                      child: Icon(
                        Icons.chevron_left,
                        size: 28,
                        color: onPrevious != null ? Colors.black87 : Colors.transparent,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      'Question $currentIndex/$total',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: onNext,
                      child: Icon(
                        Icons.chevron_right,
                        size: 28,
                        color: onNext != null ? Colors.black87 : Colors.transparent,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: currentIndex / total,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Question Bubble + Mascot ─────────────────────────────
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),

                // Speech bubble question
                Center(
                  child: _SpeechBubble(text: questionText),
                ),

                // Mascot circle — centered
                Transform.translate(
                  offset: const Offset(0, 0), // pops slightly below bubble
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(mascotImage),
                      ),
                    ),
                  ],
                ),
              ),
            ),

        // ── Choices Panel ────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: themeColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          height: 280,
          child: GridView.count(
            crossAxisCount: 2,
            physics: const BouncingScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.8,
            children: choices
                .map((choice) => _ChoiceButton(
                      label: choice,
                      onTap: () => onChoiceTap(choice),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ── Speech Bubble ─────────────────────────────────────────────────────────────

class _SpeechBubble extends StatelessWidget {
  final String text;
  static const themeColor = Color(0xFFF28544);

  const _SpeechBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: themeColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(4),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Tail pointing down-left toward mascot
        Positioned(
          bottom: -10,
          left: 20,
          child: CustomPaint(
            size: const Size(14, 12),
            painter: _TailPainter(),
          ),
        ),
      ],
    );
  }
}

class _TailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFF28544);
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Choice Button ─────────────────────────────────────────────────────────────

class _ChoiceButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ChoiceButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}