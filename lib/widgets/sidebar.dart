import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int restaurantId;

  const Sidebar({Key? key, required this.restaurantId}) : super(key: key);

  void redirectToDashboard(BuildContext context) {
    Navigator.pushNamed(context, '/home');
  }

  void redirectToOrders(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/orders',
      arguments: restaurantId, // Pass restaurantId as arguments
    );
  }

  void redirectToRestaurant(BuildContext context) {
    Navigator.pushNamed(context, '/restaurants');
  }

  void redirectToMenu(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/menus',
      arguments: restaurantId,
    );
  }

  void logout(BuildContext context) {
    // Implement logout functionality, such as clearing session or navigating to login
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => redirectToDashboard(context),
                  child: const Text('Go to Dashboard'),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Orders'),
            onTap: () => redirectToOrders(context),
          ),
          ListTile(
            title: const Text('Restaurant'),
            onTap: () => redirectToRestaurant(context),
          ),
          ListTile(
            title: const Text('Menu'),
            onTap: () => redirectToMenu(context),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }
}
