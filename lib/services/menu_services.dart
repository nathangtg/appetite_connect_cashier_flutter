import 'dart:convert';
import 'package:appetite_connect_cashier/models/menu.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuServices {
  static const String apiUrl =
      'http://127.0.0.1:8000/api'; // Replace with your API URL

  // Get Menu from API with Authorization
  Future<List<Menu>> getMenuFromAPI(int restaurantId) async {
    final token = await _getToken();

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$apiUrl/menus/$restaurantId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['menus'];
      return jsonData.map((json) => Menu.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load menu');
    }
  }

  // Get Restaurant Details from API
  Future<Map<String, dynamic>> getRestaurantFromAPI(String restaurantId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/restaurants/$restaurantId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }

  // Modify Menu Item in API
  Future<void> modifyMenuItemInAPI(
    String restaurantId,
    String menuId,
    Map<String, dynamic> formData,
  ) async {
    final token = await _getToken();

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    print(jsonEncode(formData));

    final response = await http.put(
      Uri.parse('$apiUrl/menus/$restaurantId/$menuId/update'),
      headers: headers,
      body: jsonEncode(formData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to modify menu item');
    }
  }

  // Modify Image in API
  Future<void> modifyImageInAPI(
    String restaurantId,
    String menuId,
    String imagePath,
  ) async {
    final token = await _getToken();

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    final url = '$apiUrl/menus/$restaurantId/$menuId/upload';

    // Create a MultipartFile from the image file
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath(
      'image', // Name of the field where the file is passed
      imagePath, // Path to the image file
      contentType:
          MediaType('image', 'jpeg'), // Adjust according to your file type
    ));

    // Send request
    var response = await request.send();

    // Handle response
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image');
    }
  }

  // Helper method to get token from local storage
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
