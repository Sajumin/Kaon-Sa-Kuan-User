import 'package:flutter/material.dart';
import '../../models/restaurant_data.dart'; 
import '../../widgets/chip.dart'; 
//import '../../widgets/bottom_navbar.dart';

class RestaurantDetailPage extends StatelessWidget {
  final RestaurantData restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  static const themeColor = Color(0xFFF28544);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: themeColor,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    restaurant.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Afacad',
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // balance the back button
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  restaurant.imageUrl != null
                      ? Image.network(
                          restaurant.imageUrl!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imagePlaceholder(),
                        )
                      : _imagePlaceholder(),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InfoChip(
                              icon: Icons.location_on_outlined,
                              label: restaurant.location,
                            ),
                            const SizedBox(width: 95),
                            InfoChip(
                              icon: Icons.payments_outlined,
                              label: restaurant.price,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            InfoChip(
                              icon: Icons.access_time_outlined,
                              label: restaurant.hours ?? '8am–5pm',
                            ),
                            const SizedBox(width: 100),
                            InfoChip(
                              icon: Icons.storefront_outlined,
                              label: restaurant.name,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                          restaurant.description ??
                              'No description available.',
                          style: const TextStyle(
                            fontFamily: 'Afacad',
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (restaurant.tags != null &&
                            restaurant.tags!.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: restaurant.tags!
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
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 200,
      color: const Color(0xFFF5F5F5),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 48, color: Colors.black26),
      ),
    );
  }
}