import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaon_sa_kuan/models/restaurant.dart';

class RestaurantService {
  final CollectionReference<Map<String, dynamic>> _restaurantsCollection =
  FirebaseFirestore.instance.collection('restaurants');

  Future<void> addRestaurant(Restaurant restaurant) async {
    await _restaurantsCollection.add({
      ...restaurant.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Restaurant>> getRestaurants() {
    return _restaurantsCollection
        .where('status', isEqualTo: 'approved')
        .where('createdByAdmin', isEqualTo: true)
        .where('approvedBy', isNotEqualTo: null)
        .where('isStillOperating', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => Restaurant.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

}
