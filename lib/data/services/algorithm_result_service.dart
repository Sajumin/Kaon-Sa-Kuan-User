import 'package:kaon_sa_kuan/models/restaurant.dart';

class AlgorithmResultService {
  Restaurant pickRestaurant({
    required List<Restaurant> restaurants,
    required List<String?> answers,
  }) {
    Restaurant best = restaurants.first;
    int bestScore = -1;

    for (final restaurant in restaurants) {
      final score = scoreRestaurant(restaurant, answers);

      if (score > bestScore ||
          (score == bestScore &&
              _isBetterTieBreaker(restaurant, best, answers))) {
        best = restaurant;
        bestScore = score;
      }
    }

    return best;
  }

  int scoreRestaurant(Restaurant restaurant, List<String?> answers) {
    final budget = answers[0];
    final mood = answers[1];
    final craving = answers[2];
    final location = answers[3];
    final meal = answers[4];

    var score = 0;

    if (_matchesBudget(restaurant, budget)) score += 3;
    if (_matchesMood(restaurant, mood)) score += 3;
    if (_matchesCraving(restaurant, craving)) score += 5;

    if (location == 'Anywhere') {
      score += 1;
    } else if (restaurant.location == location) {
      score += 3;
    }

    if (restaurant.mealTags.contains(meal)) score += 2;
    if (_isOpenDuringMeal(restaurant, meal)) score += 1;

    return score;
  }

  bool _matchesBudget(Restaurant restaurant, String? answer) {
    final range = switch (answer) {
      'Below PHP 80' => [0, 80],
      'PHP 81 - PHP 150' => [81, 150],
      'PHP 151 - PHP 300' => [151, 300],
      'PHP 300+' => [301, 99999],
      _ => [0, 99999],
    };

    return restaurant.averageCostMin <= range[1] &&
        restaurant.averageCostMax >= range[0];
  }

  bool _matchesMood(Restaurant restaurant, String? answer) {
    if (answer == null || answer == 'Not Sure') return true;

    if (answer == 'Grilled / Seafood') {
      return restaurant.foodCategory == 'Grilled' ||
          restaurant.foodType.contains('Ihaw') ||
          restaurant.foodType.contains('Seafood');
    }

    if (answer == 'Desserts / Snacks') {
      return restaurant.foodCategory.contains('Desserts') ||
          restaurant.foodType.contains('Pastry') ||
          restaurant.foodType.contains('Street Food');
    }

    return restaurant.foodCategory == answer;
  }

  bool _matchesCraving(Restaurant restaurant, String? answer) {
    if (answer == null) return false;

    if (answer == 'Savory') {
      return restaurant.foodType.any(
            (type) => [
          'Karinderya',
          'Silog',
          'Ilonggo',
          'Ihaw',
          'Seafood',
          'Samgyup',
          'Bar-type',
        ].contains(type),
      );
    }

    if (answer == 'Sweet') {
      return restaurant.foodType.any(
            (type) => ['Pastry', 'Cafe'].contains(type),
      );
    }

    if (answer == 'Grilled') {
      return restaurant.foodCategory == 'Grilled' ||
          restaurant.foodType.contains('Ihaw');
    }

    return restaurant.foodType.contains(answer);
  }

  bool _isOpenDuringMeal(Restaurant restaurant, String? meal) {
    final openMinutes = _timeToMinutes(restaurant.openTime);
    final closeMinutes = _timeToMinutes(restaurant.closeTime);
    final mealMinutes = _mealTimeToMinutes(meal);

    if (openMinutes == null || closeMinutes == null || mealMinutes == null) {
      return false;
    }

    if (closeMinutes < openMinutes) {
      return mealMinutes >= openMinutes || mealMinutes <= closeMinutes;
    }

    return mealMinutes >= openMinutes && mealMinutes <= closeMinutes;
  }

  int? _timeToMinutes(String time) {
    final parts = time.split(':');

    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return null;

    return hour * 60 + minute;
  }

  int? _mealTimeToMinutes(String? meal) {
    return switch (meal) {
      'Breakfast' => 8 * 60,
      'Lunch' => 12 * 60,
      'Merienda' => 15 * 60,
      'Dinner' => 19 * 60,
      _ => null,
    };
  }

  bool _isBetterTieBreaker(
      Restaurant candidate,
      Restaurant currentBest,
      List<String?> answers,
      ) {
    final tieBreaker = answers[5];

    if (tieBreaker == 'Cheapest Option') {
      return candidate.averageCostMin < currentBest.averageCostMin;
    }

    if (tieBreaker == 'Best Food Match') {
      final craving = answers[2];

      final candidateMatches = _matchesCraving(candidate, craving);
      final currentMatches = _matchesCraving(currentBest, craving);

      if (candidateMatches != currentMatches) {
        return candidateMatches;
      }

      return candidate.foodType.length > currentBest.foodType.length;
    }

    return false;
  }
}