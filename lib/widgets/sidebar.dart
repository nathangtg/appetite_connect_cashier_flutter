import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool sidebarOpen = true;

  void toggleSidebar() {
    setState(() {
      sidebarOpen = !sidebarOpen;
    });
  }

  void redirectToDashboard() {
    Navigator.pushNamed(context, '/home');
  }

  void redirectToOrders() {
    // Implement navigation to Orders
  }

  void redirectToRestaurant() {
    // Implement navigation to Restaurant
  }

  void redirectToMenu() {
    // Implement navigation to Menu
  }

  void logout() {
    // Implement logout functionality
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
                  onPressed: redirectToDashboard,
                  child: const Text('Go to Dashboard'),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Orders'),
            onTap: redirectToOrders,
          ),
          ListTile(
            title: const Text('Restaurant'),
            onTap: redirectToRestaurant,
          ),
          ListTile(
            title: const Text('Menu'),
            onTap: redirectToMenu,
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: logout,
          ),
        ],
      ),
    );
  }
}
