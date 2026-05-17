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
        margin: const EdgeInsets.only(bottom: 20),
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
            // Image placeholder
            Container(
              height: 110,
              decoration: const BoxDecoration(
                color: Color(0xFFFDF0E8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Center(
                child: Icon(Icons.restaurant,
                    color: themeColor.withOpacity(0.3), size: 48),
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