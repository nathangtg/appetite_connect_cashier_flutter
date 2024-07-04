import 'dart:convert';

import 'package:appetite_connect_cashier/views/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantsView extends StatefulWidget {
  const RestaurantsView({Key? key}) : super(key: key);

  @override
  State<RestaurantsView> createState() => _RestaurantsViewState();
}

class _RestaurantsViewState extends State<RestaurantsView> {
  bool _isLoading = false;
  List<dynamic> _restaurants = [];

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/admin/restaurants'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Successful response
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _restaurants = data;
        _isLoading = false;
      });
    } else {
      // Error handling
      setState(() {
        _isLoading = false;
      });
      // Show error message or handle as needed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch restaurants.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = _restaurants[index];
                return ListTile(
                  title: Text(restaurant['name']),
                  subtitle: Text(restaurant['description']),
                  leading: Image.network(restaurant['image_path']),
                  onTap: () {
                    // Handle tap on restaurant item
                    // For example, navigate to restaurant details page
                  },
                );
              },
            ),
    );
  }
}
