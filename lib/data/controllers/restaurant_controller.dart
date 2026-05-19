import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaon_sa_kuan/models/restaurant.dart';
import 'package:kaon_sa_kuan/data/services/restaurant_service.dart';


class RestaurantController {
  final RestaurantService _restaurantService = RestaurantService();

  Future<void> addRestaurant({
    required String name,
    required String description,
    required String location,
    required String foodCategory,
    required List<String> foodType,
    required int averageCostMin,
    required int averageCostMax,
    required List<String> budgetTags,
    required String openTime,
    required String closeTime,
    required List<String> mealTags,
    required String facebookPage,
    required String imageUrl,
  }) async {
    if (name.trim().isEmpty) {
      throw Exception("Restaurant name is required");
    }

    if (averageCostMax < averageCostMin) {
      throw Exception("Priciest meal must be higher than cheapest meal.");
    }

    final restaurant = Restaurant(
      id: '',
      name: name.trim(),
      description: description.trim(),
      location: location,
      foodCategory: foodCategory,
      foodType: foodType,
      averageCostMin: averageCostMin,
      averageCostMax: averageCostMax,
      budgetTags: budgetTags,
      openTime: openTime,
      closeTime: closeTime,
      mealTags: mealTags,
      facebookPage: facebookPage.trim(),
      imageUrl: imageUrl.trim(),
      approvedBy: null,
      status: 'pending',
      createdByAdmin: false,
    );

    await _restaurantService.addRestaurant(restaurant);
  }
}
