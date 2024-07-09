import 'dart:io';

import 'package:flutter/material.dart';
import 'package:appetite_connect_cashier/models/menu.dart';
import 'package:appetite_connect_cashier/models/restaurant.dart';
import 'package:appetite_connect_cashier/services/menu_services.dart';
import 'package:appetite_connect_cashier/services/restaurant_services.dart';
import 'package:appetite_connect_cashier/widgets/sidebar.dart';
import 'package:image_picker/image_picker.dart';

class MenuView extends StatefulWidget {
  final int restaurantId;

  MenuView({Key? key, required this.restaurantId}) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  late Future<List<Menu>> _menusFuture;
  final MenuServices _menuServices = MenuServices();
  final RestaurantServices _restaurantServices = RestaurantServices();
  String restaurantName = '';

  @override
  void initState() {
    super.initState();
    fetchRestaurant();
    _menusFuture = _menuServices.getMenuFromAPI(widget.restaurantId);
  }

  Future<void> fetchRestaurant() async {
    try {
      Restaurant restaurant =
          await _restaurantServices.fetchRestaurant(widget.restaurantId);
      setState(() {
        restaurantName = restaurant.name;
      });
    } catch (e) {
      print('Error fetching restaurant: $e');
    }
  }

  Future<void> _editMenu(Menu menu) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMenuScreen(menu: menu),
      ),
    );

    if (result == true) {
      // Refresh menu list
      await _refreshMenuList();
    }
  }

  Future<void> _refreshMenuList() async {
    setState(() {
      _menusFuture = _menuServices.getMenuFromAPI(widget.restaurantId);
    });
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
            child: FutureBuilder<List<Menu>>(
              future: _menusFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No menus found.'));
                } else {
                  // Display menus using ListView.builder
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Menu menu = snapshot.data![index];
                      return ListTile(
                        title: Text(menu.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: ${menu.price.toStringAsFixed(2)}'),
                            Text('Category: ${menu.category}'),
                            Text('Description: ${menu.description}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editMenu(menu),
                        ),
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

class EditMenuScreen extends StatefulWidget {
  final Menu menu;

  EditMenuScreen({Key? key, required this.menu}) : super(key: key);

  @override
  _EditMenuScreenState createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.menu.name;
    _categoryController.text = widget.menu.category;
    _descriptionController.text = widget.menu.description;
    _priceController.text = widget.menu.price.toStringAsFixed(2);
  }

  void _saveMenu() async {
    try {
      Map<String, dynamic> updateData = {
        'name': _nameController.text,
        'category': _categoryController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
      };

      // You can now call your service to update the menu item
      await MenuServices().modifyMenuItemInAPI(
        widget.menu.restaurantId.toString(),
        widget.menu.id.toString(),
        updateData,
      );

      Navigator.pop(context, true);
    } catch (e) {
      print('Error saving menu: $e');

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save menu. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMenu,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
