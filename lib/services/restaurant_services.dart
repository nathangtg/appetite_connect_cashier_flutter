import 'package:appetite_connect_cashier/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RestaurantServices {
  static const String apiUrl = 'http://127.0.0.1:8000/api/restaurants';

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fetch all restaurants
  Future<List<Restaurant>> fetchRestaurants() async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['restaurants'];
      List<Restaurant> restaurants =
          data.map((json) => Restaurant.fromJson(json)).toList();
      return restaurants;
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  // Fetch restaurant based on restaurantId
  Future<Restaurant> fetchRestaurant(int restaurantId) async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/$restaurantId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      Restaurant restaurant = Restaurant.fromJson(data);
      print(data);
      return restaurant;
    } else {
      throw Exception('Failed to load restaurant');
    }
  }
}
