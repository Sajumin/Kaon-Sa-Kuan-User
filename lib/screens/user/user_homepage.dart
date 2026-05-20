import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaon_sa_kuan/data/services/restaurant_service.dart';
import 'package:kaon_sa_kuan/models/restaurant.dart';
import 'package:kaon_sa_kuan/screens/user/user_decisions_page.dart';
import 'package:kaon_sa_kuan/screens/user/user_resto_details.dart';
import 'package:kaon_sa_kuan/widgets/user/user_resto_card.dart';
import 'package:kaon_sa_kuan/widgets/user/user_speech_bubble.dart';
import 'package:kaon_sa_kuan/utils/constants/restaurant_tags.dart';

class UserHomepage extends StatefulWidget {
  const UserHomepage({super.key});

  @override
  State<UserHomepage> createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  static const themeColor = Color(0xFFF28544);
  final RestaurantService _restaurantService = RestaurantService();
  final TextEditingController _searchController = TextEditingController();
  late final Stream<List<Restaurant>> _restaurantsStream;
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String? _selectedLocationFilter;
  String? _selectedFoodTypeFilter;


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

  void _openFilterSheet() {
    String? tempLocationFilter = _selectedLocationFilter;
    String? tempFoodTypeFilter = _selectedFoodTypeFilter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Filter restaurants',
                            style: GoogleFonts.poppins(
                              color: themeColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempLocationFilter = null;
                              tempFoodTypeFilter = null;
                            });
                          },
                          child: Text(
                            'Clear',
                            style: GoogleFonts.poppins(
                              color: themeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Location',
                      style: GoogleFonts.poppins(
                        color: themeColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildHorizontalChipList([
                      _buildFilterChip(
                        label: 'All locations',
                        isSelected: tempLocationFilter == null,
                        onSelected: () {
                          setModalState(() => tempLocationFilter = null);
                        },
                      ),
                      ...RestaurantOptions.locations.map(
                            (location) => _buildFilterChip(
                          label: location,
                          isSelected: tempLocationFilter == location,
                          onSelected: () {
                            setModalState(() => tempLocationFilter = location);
                          },
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Text(
                      'Food type',
                      style: GoogleFonts.poppins(
                        color: themeColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildHorizontalChipList([
                      _buildFilterChip(
                        label: 'All food types',
                        isSelected: tempFoodTypeFilter == null,
                        onSelected: () {
                          setModalState(() => tempFoodTypeFilter = null);
                        },
                      ),
                      ...RestaurantOptions.foodTypes.map(
                            (foodType) => _buildFilterChip(
                          label: foodType,
                          isSelected: tempFoodTypeFilter == foodType,
                          onSelected: () {
                            setModalState(() => tempFoodTypeFilter = foodType);
                          },
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedLocationFilter = tempLocationFilter;
                            _selectedFoodTypeFilter = tempFoodTypeFilter;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Apply filters',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHorizontalChipList(List<Widget> chips) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips
            .map(
              (chip) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: chip,
          ),
        )
            .toList(),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _restaurantsStream = _restaurantService.getRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    offset: const Offset(5, 25),
                    child: const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/og.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Restaurant>>(
              stream: _restaurantsStream,
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

                final visibleRestaurants = restaurants.where((restaurant) {
                  final query = _searchQuery.trim().toLowerCase();

                  final searchableText = [
                    restaurant.name,
                    restaurant.description,
                    restaurant.location,
                    restaurant.foodCategory,
                    ...restaurant.foodType,
                    ...restaurant.budgetTags,
                    ...restaurant.mealTags,
                  ].join(' ').toLowerCase();

                  final matchesSearch = query.isEmpty || searchableText.contains(query);

                  final matchesLocation = _selectedLocationFilter == null ||
                      restaurant.location == _selectedLocationFilter;

                  final matchesFoodType = _selectedFoodTypeFilter == null ||
                      restaurant.foodType.contains(_selectedFoodTypeFilter) ||
                      restaurant.foodCategory == _selectedFoodTypeFilter;

                  return matchesSearch && matchesLocation && matchesFoodType;
                }).toList();

                final hasActiveFilter = _selectedLocationFilter != null || _selectedFoodTypeFilter != null;

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
                          Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                cursorColor: themeColor,
                                selectionColor: themeColor.withOpacity(0.25),
                                selectionHandleColor: themeColor,
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              cursorColor: themeColor,
                              focusNode: _searchFocusNode,
                              onChanged: (value) {
                                setState(() => _searchQuery = value);
                              },
                              decoration: InputDecoration(
                                hintText: 'search for restaurant...',
                                hintStyle: GoogleFonts.poppins(
                                  color: themeColor.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                                prefixIcon: const Icon(Icons.search, color: themeColor),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: IconButton(
                                      icon: const Icon(Icons.tune),
                                      color: hasActiveFilter ? Colors.white : themeColor,
                                      style: IconButton.styleFrom(
                                        backgroundColor: hasActiveFilter ? themeColor : Colors.transparent,
                                        shape: const CircleBorder(),
                                      ),
                                      onPressed: _openFilterSheet,
                                    ),
                                  ),
                                ),
                                suffixIconConstraints: const BoxConstraints(
                                  minWidth: 48,
                                  minHeight: 48,
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: themeColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: themeColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: themeColor, width: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: visibleRestaurants.isEmpty
                            ? Center(
                              child: Text(
                                'No matching restaurants found.',
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                            )
                            : LayoutBuilder(
                              builder: (context, constraints) {
                                final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;

                                return GridView.builder(
                                  itemCount: visibleRestaurants.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: crossAxisCount == 2 ? 0.85 : 1.4,
                                  ),
                                  itemBuilder: (context, index) {
                                    final restaurant = visibleRestaurants[index];

                                    return RestaurantCard(
                                      restaurant: restaurant,
                                      onTap: () => _onRestaurantTap(restaurant),
                                    );
                                  },
                                );
                              },
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

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : themeColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: isSelected,
      selectedColor: themeColor,
      backgroundColor: themeColor.withOpacity(0.08),
      side: BorderSide(color: themeColor.withOpacity(0.45)),
      showCheckmark: false,
      onSelected: (_) => onSelected(),
    );
  }
}
