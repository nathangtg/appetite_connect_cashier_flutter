class Menu {
  final int id;
  final int restaurantId;
  final String name;
  final String category;
  final String description;
  final String? image;
  final double price;
  final String? display;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? menuImage;

  Menu({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.category,
    required this.description,
    this.image,
    required this.price,
    this.display,
    this.createdAt,
    this.updatedAt,
    this.menuImage,
  });

  Menu copyWith({
    int? id,
    int? restaurantId,
    String? name,
    String? category,
    String? description,
    String? image,
    double? price,
    String? display,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? menuImage,
  }) {
    return Menu(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      display: display ?? this.display,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      menuImage: menuImage ?? this.menuImage,
    );
  }

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      image: json['image'],
      price: double.parse(json['price']),
      display: json['display'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      menuImage: json['menuImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'category': category,
      'description': description,
      'image': image,
      'price': price.toString(),
      'display': display,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'menuImage': menuImage,
    };
  }
}
