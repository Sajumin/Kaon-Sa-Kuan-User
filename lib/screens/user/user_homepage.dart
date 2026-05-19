import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaon_sa_kuan/data/services/restaurant_service.dart';
import 'package:kaon_sa_kuan/models/restaurant.dart';
import 'package:kaon_sa_kuan/screens/user/user_decisions_page.dart';
import 'package:kaon_sa_kuan/screens/user/user_resto_details.dart';
import 'package:kaon_sa_kuan/widgets/user/user_resto_card.dart';
import 'package:kaon_sa_kuan/widgets/user/user_speech_bubble.dart';

class UserHomepage extends StatefulWidget {
  const UserHomepage({super.key});

  @override
  State<UserHomepage> createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  static const themeColor = Color(0xFFF28544);
  final RestaurantService _restaurantService = RestaurantService();

  void _onRestaurantTap(Restaurant restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestaurantDetailPage(restaurant: restaurant),
      ),
    );
  }

  void _openDecisionMaker() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FoodDecisionMaker()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: themeColor,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good day, kuan.',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'What are we craving today?',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _openDecisionMaker,
                  child: Transform.translate(
                    offset: const Offset(15, 30),
                    child: const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/pig_mascot.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Restaurant>>(
              stream: _restaurantService.getRestaurants(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: themeColor),
                  );
                }

                final restaurants = snapshot.data ?? [];

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _openDecisionMaker,
                              child: const SpeechBubble(
                                text: "can't decide where to eat? tap me for help!",
                                themeColor: themeColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'search for restaurant...',
                              hintStyle: GoogleFonts.poppins(
                                color: themeColor.withOpacity(0.7),
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(Icons.search, color: themeColor),
                              suffixIcon: const Icon(Icons.tune, color: themeColor),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: themeColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: themeColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (restaurants.isEmpty)
                              Center(
                                child: Text(
                                  'No approved restaurants yet.',
                                  style: GoogleFonts.poppins(color: Colors.grey),
                                ),
                              )
                            else
                              ...restaurants.map(
                                (restaurant) => RestaurantCard(
                                  restaurant: restaurant,
                                  onTap: () => _onRestaurantTap(restaurant),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
