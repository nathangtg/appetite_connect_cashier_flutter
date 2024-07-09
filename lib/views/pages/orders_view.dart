import 'package:appetite_connect_cashier/models/order.dart';
import 'package:appetite_connect_cashier/models/restaurant.dart';
import 'package:appetite_connect_cashier/services/order_services.dart';
import 'package:appetite_connect_cashier/services/restaurant_services.dart';
import 'package:appetite_connect_cashier/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class OrdersView extends StatefulWidget {
  final int restaurantId;

  OrdersView({Key? key, required this.restaurantId}) : super(key: key);

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final OrderService orderService = OrderService();
  late Future<List<Order>> _ordersFuture;
  String restaurantName = ''; // Variable to hold the restaurant name

  @override
  void initState() {
    super.initState();
    fetchRestaurant();
    _ordersFuture = orderService.getOrdersByRestaurant(widget.restaurantId);
  }

  // Fetch restaurant name based on restaurantId from JSON API
  Future<Restaurant> fetchRestaurant() async {
    try {
      Restaurant restaurant =
          await RestaurantServices().fetchRestaurant(widget.restaurantId);
      setState(() {
        restaurantName = restaurant.name;
      });
      return restaurant;
    } catch (e) {
      print('Error fetching restaurant: $e');
      rethrow; // Optionally rethrow the error for further handling
    }
  }

  // Function to build the list of ordered items for an order
  Widget buildOrderedItemsList(List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return ListTile(
          title: Text(item['menu_item']),
          subtitle:
              Text('Price: ${item['price']} | Quantity: ${item['quantity']}'),
          // Add more details as needed
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: Sidebar(restaurantId: widget.restaurantId),
          ),
          Expanded(
            child: FutureBuilder<List<Order>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No orders found.'));
                } else {
                  // Display orders using ListView.builder
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Order order = snapshot.data![index];
                      // Replace with your order item widget
                      return ExpansionTile(
                        title: Text('Order ID: ${order.id}'),
                        subtitle: Text('Total: ${order.total}'),
                        children: [
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: orderService.getOrderedItems(
                              widget.restaurantId.toString(),
                              order.id.toString(),
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Text('No items found for this order.');
                              } else {
                                return buildOrderedItemsList(snapshot.data!);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
