import 'package:appetite_connect_cashier/views/pages/menu_view.dart';
import 'package:appetite_connect_cashier/views/pages/orders_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appetite_connect_cashier/views/auth/login_view.dart';
import 'package:appetite_connect_cashier/views/pages/restaurants_detailed.dart';
import 'package:appetite_connect_cashier/views/pages/restaurants_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<String?>(
        future: _getToken(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              return const RestaurantsView(); // Display RestaurantsView as homepage
            } else {
              return LoginView(); // Redirect to login if token is not available
            }
          }
        },
      ),
      routes: {
        '/home': (context) => const RestaurantsView(),
        '/login': (context) => LoginView(),
      },
      onGenerateRoute: (settings) {
        if (settings.name != null) {
          if (settings.name == '/orders') {
            // Navigate to OrdersView with restaurantId provided
            return MaterialPageRoute(
              builder: (context) {
                final int? restaurantId = settings.arguments as int?;
                if (restaurantId != null) {
                  return OrdersView(restaurantId: restaurantId);
                } else {
                  // Handle case where restaurantId is not available
                  return const Scaffold(
                    body: Center(
                      child: Text('Restaurant ID not provided'),
                    ),
                  );
                }
              },
            );
          } else if (settings.name!.startsWith('/restaurants')) {
            // Extract restaurantId from route path
            final idStr = settings.name!.substring('/restaurants/'.length);
            final id = int.tryParse(idStr);
            if (id != null) {
              return MaterialPageRoute(
                builder: (context) => RestaurantsDetailed(id: id),
              );
            }
          } else if (settings.name!.startsWith('/menus')) {
            return MaterialPageRoute(
              builder: (context) {
                final int? restaurantId = settings.arguments as int?;
                if (restaurantId != null) {
                  return MenuView(restaurantId: restaurantId);
                } else {
                  return const Scaffold(
                    body: Center(
                      child: Text('Restaurant ID not provided'),
                    ),
                  );
                }
              },
            );
          }
        }
        // Default route not found handling
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
      },
    );
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
