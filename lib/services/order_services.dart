import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appetite_connect_cashier/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  static const String apiUrl = 'http://127.0.0.1:8000/api';

  // Get Token
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Order>> getOrdersByRestaurant(int restaurantId) async {
    final token = await _getToken();

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$apiUrl/orders/$restaurantId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body)['orders'];
      return responseData.map((json) => Order.fromJson(json)).toList();
    } else {
      print(response.body);
      throw Exception('Failed to load orders');
    }
  }

  Future<List<Order>> getOrdersByUser() async {
    final token = await _getToken();

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$apiUrl/orders'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body)['orders'];
      return responseData.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<Order> getOrderById(String orderId, int restaurantId) async {
    final token = await _getToken();

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$apiUrl/orders/$restaurantId/$orderId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      return Order.fromJson(
          responseData); // Adjust according to your Order.fromJson method
    } else {
      throw Exception('Failed to load order');
    }
  }

  Future<Order> createOrder({
    required String email,
    required String status,
    required String orderType,
    required int tableNumber,
    required String paymentMethod,
    required String paymentStatus,
    required String restaurantId,
    required List<Map<String, dynamic>> items,
  }) async {
    final token = await _getToken();

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'email': email,
      'status': status,
      'order_type': orderType,
      'table_number': tableNumber,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'restaurantId': restaurantId,
      'items': items,
    });

    final response = await http.post(
      Uri.parse('$apiUrl/orders/$restaurantId/create'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      return Order.fromJson(
          responseData); // Adjust according to your Order.fromJson method
    } else {
      throw Exception('Failed to create order');
    }
  }

  Future<List<Map<String, dynamic>>> getOrderedItems(
    String restaurantId,
    String orderId,
  ) async {
    final token = await _getToken();

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$apiUrl/orders/$restaurantId/$orderId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body)['items'];
      return responseData.cast<Map<String, dynamic>>().toList();
    } else {
      throw Exception('Failed to load ordered items');
    }
  }

  Future<Order> updateOrder(
    String restaurantId,
    String orderId,
    Map<String, dynamic> orderData,
  ) async {
    final token = await _getToken();

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.put(
      Uri.parse('$apiUrl/orders/$restaurantId/$orderId/update'),
      headers: headers,
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      return Order.fromJson(
          responseData); // Adjust according to your Order.fromJson method
    } else {
      throw Exception('Failed to update order');
    }
  }

  Future<void> giveRating({
    required String restaurantId,
    required String orderId,
    required int rating,
    required String comment,
  }) async {
    final token = await _getToken();

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'order_id': orderId,
      'restaurant_id': restaurantId,
      'rating': rating,
      'comment': comment,
    });

    final response = await http.post(
      Uri.parse('$apiUrl/rate/$restaurantId/$orderId'),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to give rating');
    }
  }
}
