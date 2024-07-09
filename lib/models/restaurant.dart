class Restaurant {
  final int id;
  final int adminId;
  final String name;
  final String description;
  final String address;
  final String imagePath;
  final int preparationTime;
  final String cuisine;
  final String priceRange;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isOpen;
  final int numberOfTables;
  final double averageRating;

  Restaurant({
    required this.id,
    required this.adminId,
    required this.name,
    required this.description,
    required this.address,
    required this.imagePath,
    required this.preparationTime,
    required this.cuisine,
    required this.priceRange,
    required this.createdAt,
    required this.updatedAt,
    required this.isOpen,
    required this.numberOfTables,
    required this.averageRating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    String formatCuisine(String cuisine) {
      if (cuisine.isEmpty) return cuisine;
      return cuisine[0].toUpperCase() + cuisine.substring(1).toLowerCase();
    }

    return Restaurant(
      id: json['id'],
      adminId: json['admin_id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      imagePath: json['image_path'],
      preparationTime: json['preparation_time'],
      cuisine: formatCuisine(json['cuisine']),
      priceRange: json['price_range'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isOpen: json['is_open'],
      numberOfTables: json['number_of_tables'],
      averageRating: json['average_rating'].toDouble(),
    );
  }
}
