import 'package:flutter/material.dart';
import '../../models/restaurant_data.dart';

class RestaurantCard extends StatelessWidget {
   final RestaurantData restaurant;
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
      child: SizedBox(
        height: 200, 
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
          // Image placeholder
          Expanded(
          flex: 3, 
          child: Container(
            //height: 110,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFDF0E8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Center(
              child: Icon(Icons.restaurant,
                  color: themeColor.withOpacity(0.3), size: 48),
            ),
          ),
        ),

          // Info
          Expanded(
            flex: 2, 
            child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontFamily: 'Afacad',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 15, color: themeColor),
                    const SizedBox(width: 3),
                    Flexible(
                    child: Text(restaurant.location,
                        style: const TextStyle(
                            fontFamily: 'Afacad', color: themeColor, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                      ),
                  ),
                    const SizedBox(width: 12),
                    const Icon(Icons.payments_outlined,
                        size: 15, color: themeColor),
                    const SizedBox(width: 4),
                    Flexible(
                    child: Text(restaurant.price,
                        style: const TextStyle(
                            fontFamily: 'Afacad', color: themeColor, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      ),
    );
  }
}