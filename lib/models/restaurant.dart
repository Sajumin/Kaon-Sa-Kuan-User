class Restaurant{
  final String id;
  final String name;
  final String description;
  final String location;
  final String priceRange;
  final String openingHours;
  final String facebookPage;
  final String imageUrl;
  final List<String> tags;
  final String? approvedBy;
  final String status;
  final bool createdByAdmin;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.priceRange,
    required this.openingHours,
    required this.facebookPage,
    required this.imageUrl,
    required this.tags,
    this.approvedBy,
    required this.status,
    required this.createdByAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'priceRange': priceRange,
      'openingHours': openingHours,
      'facebookPage': facebookPage,
      'imageUrl': imageUrl,
      'tags': tags,
      'approvedBy': approvedBy,
      'status': status,
      'createdByAdmin': createdByAdmin,
    };
  }

  factory Restaurant.fromMap(String id, Map<String, dynamic> map) {
    return Restaurant(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      priceRange: map['priceRange'] ?? '',
      openingHours: map['openingHours'] ?? '',
      facebookPage: map['facebookPage'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      approvedBy: map['approvedBy'] as String?,
      status: map['status'] ?? 'pending',
      createdByAdmin: map['createdByAdmin'] ?? false,
    );
  }
}
