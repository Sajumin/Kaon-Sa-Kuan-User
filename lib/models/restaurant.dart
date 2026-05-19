class Restaurant {
  final String id;
  final String name;
  final String description;
  final String location;
  final String foodCategory;
  final List<String> foodType;
  final int averageCostMin;
  final int averageCostMax;
  final List<String> budgetTags;
  final String openTime;
  final String closeTime;
  final List<String> mealTags;
  final String facebookPage;
  final String imageUrl;
  final String? approvedBy;
  final String status;
  final bool createdByAdmin;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.foodCategory,
    required this.foodType,
    required this.averageCostMin,
    required this.averageCostMax,
    required this.budgetTags,
    required this.openTime,
    required this.closeTime,
    required this.mealTags,
    required this.facebookPage,
    required this.imageUrl,
    this.approvedBy,
    required this.status,
    required this.createdByAdmin,
  });

  String get priceRange => 'PHP $averageCostMin - PHP $averageCostMax';
  String get openingHours => '$openTime - $closeTime';

  List<String> get tags => [
    foodCategory,
    ...foodType,
    ...budgetTags,
    ...mealTags,
  ].where((tag) => tag.trim().isNotEmpty).toSet().toList();

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'location': location,
    'foodCategory': foodCategory,
    'foodType': foodType,
    'averageCostMin': averageCostMin,
    'averageCostMax': averageCostMax,
    'budgetTags': budgetTags,
    'openTime': openTime,
    'closeTime': closeTime,
    'mealTags': mealTags,
    'facebookPage': facebookPage,
    'imageUrl': imageUrl,
    'approvedBy': approvedBy,
    'status': status,
    'createdByAdmin': createdByAdmin,
  };

  factory Restaurant.fromMap(String id, Map<String, dynamic> map) {
    return Restaurant(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      foodCategory: map['foodCategory'] ?? '',
      foodType: List<String>.from(map['foodType'] ?? []),
      averageCostMin: (map['averageCostMin'] as num?)?.toInt() ?? 0,
      averageCostMax: (map['averageCostMax'] as num?)?.toInt() ?? 0,
      budgetTags: List<String>.from(map['budgetTags'] ?? []),
      openTime: map['openTime'] ?? '',
      closeTime: map['closeTime'] ?? '',
      mealTags: List<String>.from(map['mealTags'] ?? []),
      facebookPage: map['facebookPage'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      approvedBy: map['approvedBy'] as String?,
      status: map['status'] ?? 'pending',
      createdByAdmin: map['createdByAdmin'] ?? false,
    );
  }
}