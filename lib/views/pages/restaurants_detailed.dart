import 'package:flutter/material.dart';
import 'package:appetite_connect_cashier/widgets/sidebar.dart';

class RestaurantsDetailed extends StatefulWidget {
  final int id;

  const RestaurantsDetailed({Key? key, required this.id}) : super(key: key);

  @override
  State<RestaurantsDetailed> createState() => _RestaurantsDetailedState();
}

class _RestaurantsDetailedState extends State<RestaurantsDetailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Details'),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: Sidebar(
              restaurantId: widget.id,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Restaurant ID: ${widget.id}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
