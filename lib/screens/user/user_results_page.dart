import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaon_sa_kuan/models/restaurant.dart';
import 'package:kaon_sa_kuan/widgets/user/user_icon_chip.dart';

class ResultPage extends StatelessWidget {
  final Restaurant? restaurant;
  final VoidCallback onTryAgain;

  const ResultPage({
    super.key,
    required this.restaurant,
    required this.onTryAgain,
  });

  static const themeColor = Color(0xFFF28544);

  @override
  Widget build(BuildContext context) {
    final selectedRestaurant = restaurant;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: SafeArea(
              child: Row(
                children: [
                  const Expanded(
                    child: _SpeechBubble(
                      text: 'This is the kainan perfect for you!',
                    ),
                  ),
                  const SizedBox(width: 5),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/images/pig_mascot.png'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: selectedRestaurant == null
                ? Center(
              child: Text(
                'No approved restaurants available yet.',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            )
                : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: themeColor.withOpacity(0.4)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: selectedRestaurant.imageUrl.isNotEmpty
                          ? Image.network(
                        selectedRestaurant.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                          : _imagePlaceholder(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedRestaurant.name,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: themeColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 20,
                            runSpacing: 8,
                            children: [
                              InfoChip(
                                icon: Icons.location_on_outlined,
                                label: selectedRestaurant.location,
                              ),
                              InfoChip(
                                icon: Icons.payments_outlined,
                                label: selectedRestaurant.priceRange,
                              ),
                              InfoChip(
                                icon: Icons.access_time_outlined,
                                label: selectedRestaurant.openingHours,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            selectedRestaurant.description.isNotEmpty
                                ? selectedRestaurant.description
                                : 'No description available.',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (selectedRestaurant.tags.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: selectedRestaurant.tags
                                  .map((tag) => TagChip(label: tag))
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              children: [
                SizedBox(
                  width: 260,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: Text(
                      "Okay, I'll eat there!",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 260,
                  child: ElevatedButton(
                    onPressed: onTryAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D2D2D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: Text(
                      "Nope! Need a new one!",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 180,
      color: const Color(0xFFF5F5F5),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 48, color: Colors.black26),
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  final String text;

  const _SpeechBubble({required this.text});

  static const themeColor = Color(0xFFF28544);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}