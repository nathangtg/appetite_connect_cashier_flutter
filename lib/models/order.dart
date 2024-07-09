import 'dart:convert';

class Order {
  final int id;
  final int restaurantId;
  final int userId;
  final String email;
  final double total;
  final String status;
  final String orderType;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? tableNumber; // Nullable field

  Order({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.email,
    required this.total,
    required this.status,
    required this.orderType,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    this.tableNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      userId: json['user_id'],
      email: json['email'],
      total: double.parse(json['total']),
      status: json['status'],
      orderType: json['order_type'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      tableNumber: json['table_number'], // nullable field handling
    );
  }
}

// Function to fetch and parse JSON data into a list of Order objects
List<Order> parseOrders(String jsonString) {
  final parsed = jsonDecode(jsonString).cast<Map<String, dynamic>>();
  return parsed.map<Order>((json) => Order.fromJson(json)).toList();
}
