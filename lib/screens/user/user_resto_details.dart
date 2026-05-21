import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaon_sa_kuan/models/restaurant.dart';
import 'package:kaon_sa_kuan/widgets/user/user_icon_chip.dart';
//import '../../widgets/user_nav_bar.dart';

class RestaurantDetailPage extends StatelessWidget {
  final Restaurant restaurant;

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);

    if (url.isEmpty) return;

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  const RestaurantDetailPage({super.key, required this.restaurant});

  static const themeColor = Color(0xFFF28544);

  @override
  Widget build(BuildContext context) {
    final facebookUrl = restaurant.facebookPage ?? '';

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
                    style: const TextStyle (
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
                  restaurant.imageUrl.isNotEmpty
                      ? Image.network(
                          restaurant.imageUrl,
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
                            Expanded(
                              child: InfoChip(
                                icon: Icons.location_on_outlined,
                                label: restaurant.location,
                              ),
                            ),
                            Expanded(
                              child: InfoChip(
                                icon: Icons.payments_outlined,
                                label: restaurant.priceRange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: InfoChip(
                                icon: Icons.access_time_outlined,
                                label:
                                    '${formatTime12Hour(restaurant.openTime)} - ${formatTime12Hour(restaurant.closeTime)}',
                              ),
                            ),
                            Expanded(
                              child: InfoChip(
                                icon: Icons.storefront_outlined,
                                label: restaurant.name,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          restaurant.description.isNotEmpty
                              ? restaurant.description
                              : 'No description available.',
                          style: const TextStyle(
                            fontFamily: 'Afacad',
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (facebookUrl.isNotEmpty)
                          GestureDetector(
                            onTap: () => _launchURL(facebookUrl),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Facebook Link: ',
                                    style: TextStyle(
                                      fontFamily: 'Afacad',
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  TextSpan(
                                    text: facebookUrl,
                                    style: const TextStyle(
                                      fontFamily: 'Afacad',
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 2, 11,
                                          143),
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          Color.fromARGB(255, 2, 11, 143),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          const Text(
                            'Facebook Page: Not available',
                            style: TextStyle(
                              fontFamily: 'Afacad',
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        const SizedBox(height: 15),
                        if (restaurant.tags.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: restaurant.tags
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

  String formatTime12Hour(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return time;

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;

    return '$hour12:$minute $period';
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
