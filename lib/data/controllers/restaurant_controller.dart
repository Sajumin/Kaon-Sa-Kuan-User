import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaon_sa_kuan/models/restaurant.dart';
import 'package:kaon_sa_kuan/data/services/restaurant_service.dart';


class RestaurantController {
  final RestaurantService _restaurantService = RestaurantService();

  Future<void> addRestaurant({
    required String name,
    required String description,
    required String location,
    required String priceRange,
    required String openingHours,
    required String facebookPage,
    required List<String> tags,
    required String imageUrl,
  }) async {
    // Basic validation
    if (name.trim().isEmpty) {
      throw Exception("Restaurant name is required");
    }

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      currentUser = credential.user;
    }

    if (currentUser == null) {
      throw Exception("Unable to sign in anonymously.");
    }

    final restaurant = Restaurant(
      id: '',
      name: name.trim(),
      description: description.trim(),
      location: location.trim(),
      priceRange: priceRange.trim(),
      openingHours: openingHours.trim(),
      facebookPage: facebookPage.trim(),
      imageUrl: imageUrl.trim(),
      tags: tags,
      approvedBy: null,
      status: 'pending',
      createdByAdmin: false,
    );

    await _restaurantService.addRestaurant(restaurant);
  }
}
