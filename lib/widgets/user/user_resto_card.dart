import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaon_sa_kuan/models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFFF28544);

    return GestureDetector(
      onTap: onTap,
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
            // Restaurant Image with Placeholder Logic
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: restaurant.imageUrl.trim().isEmpty
                  ? Container(
                    color: const Color(0xFFFDF0E8),
                    child: Center(
                      child: Icon(Icons.restaurant,
                          color: themeColor.withOpacity(0.3), size: 48),
                    ),
                  )
                  : Image.network(
                    restaurant.imageUrl.trim(),
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFFFDF0E8),
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFFDF0E8),
                      child: Center(
                        child: Icon(Icons.broken_image,
                            color: themeColor.withOpacity(0.3), size: 48),
                      ),
                    ),
                  ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 15, color: themeColor),
                      const SizedBox(width: 3),
                      Text(restaurant.location,
                          style: GoogleFonts.poppins(
                              color: themeColor, fontSize: 12)),
                      const SizedBox(width: 25),
                      const Icon(Icons.payments_outlined,
                          size: 15, color: themeColor),
                      const SizedBox(width: 4),
                      Text(restaurant.priceRange,
                          style: GoogleFonts.poppins(
                              color: themeColor, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
