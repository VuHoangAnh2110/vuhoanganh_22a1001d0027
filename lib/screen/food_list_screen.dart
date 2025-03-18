import 'dart:io';
import '/screen/food_form_dialog.dart';
import 'package:flutter/material.dart';
import '/database/database_helper.dart';

class FoodListScreen extends StatefulWidget {
  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  List<Map<String, dynamic>> foods = [];

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    final data = await DatabaseHelper.instance.fetchFoods();
    setState(() {
      foods = data;
    });
  }

  void _addOrEditFood({Map<String, dynamic>? food}) async {
    final result = await showDialog(
      context: context,
      builder: (context) => FoodFormDialog(food: food),
    );
    if (result == true) {
      _loadFoods();
    }
  }

  void _deleteFood(int id) async {
    await DatabaseHelper.instance.deleteFood(id);
    _loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quản lý món ăn")),
      body: foods.isEmpty
          ? Center(child: Text("Chưa có món ăn nào"))
          : ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return Card(
                  child: ListTile(
                    leading: food["image"] != null && food["image"].isNotEmpty
                        ? Image.file(File(food["image"]), width: 50, height: 50, fit: BoxFit.cover)
                        : Icon(Icons.image, size: 50, color: Colors.grey),
                    title: Text(food["name"]),
                    subtitle: Text("Giá: ${food["price"]} (${food["unit"]})"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _addOrEditFood(food: food)),
                        IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteFood(food["id"])),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditFood(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
