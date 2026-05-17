import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'clickResto.dart';
import 'decisions_page.dart';
import '../../models/restaurant_data.dart';
import '../../widgets/restaurant_card.dart';
import '../../widgets/speech_bubble.dart';

class UserHomepage extends StatefulWidget {
  const UserHomepage({super.key});

 @override
  State<UserHomepage> createState() => _UserHomepageState();
}
class _UserHomepageState extends State<UserHomepage> {
  static const themeColor = Color(0xFFF28544);

   final List<RestaurantData> _restaurants = const [
    RestaurantData(
      id: '1',
      name: 'Manang Betch',
      location: 'CUB, Stall #2',
      price: 'Php 5 – Php 100',
      hours: '8am–5pm',
      description: 'Your favorite homecooked meals away from home! We serve affordable, comforting dishes from breakfast to dinner.',
      tags: ['lunch', 'chicken', 'pork'],
    ),
    RestaurantData(
      id: '2',
      name: 'Beans and Bubbles',
      location: 'Brgy. Mat-y',
      price: 'Php 130 – Php 250',
      hours: '8am–3am',
      description: 'Your favorite coffee shop place with yummy pastries.',
      tags: ['cake', 'bread', 'coffee'],
    ),
  ];

   void _onRestaurantTap(RestaurantData restaurant) {
     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestaurantDetailPage(restaurant: restaurant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //Header 
          Container(
            color: themeColor,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Greeting text
                    Expanded(
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
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    // Pig mascot
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (_) => const FoodDecisionMaker()),
                      ),
                    child: Transform.translate(
                      offset: const Offset(15, 30), // pops slightly below header
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white.withOpacity(0.0),
                        backgroundImage:
                            const AssetImage('assets/images/pig_mascot.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //Body
          Expanded(
            child: Column(
              children: [
                Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                    alignment: Alignment.centerRight,
                    child: SpeechBubble(
                      text: "can't decide where to eat? tap me for help!",
                      themeColor: themeColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'search for restaurant...',
                      hintStyle: GoogleFonts.poppins(
                        color: themeColor.withOpacity(0.7),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(Icons.search, color: themeColor),
                      suffixIcon: const Icon(Icons.tune, color: themeColor),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: themeColor, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: themeColor, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: themeColor, width: 2),
                            )
                          ),
                        ),
                     ],
                    ),
                  ),

                  //const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            ..._restaurants.map((r) => RestaurantCard(
                              restaurant: r,
                              onTap: () => _onRestaurantTap(r),
                        )),
                      ]
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
}