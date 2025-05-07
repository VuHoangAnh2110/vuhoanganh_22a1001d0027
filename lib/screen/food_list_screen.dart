import 'dart:io';
import 'dart:ui';
import '/screen/food_form_screen.dart';
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

  // Hiện thị dạng dialog để nhập thông tin 
  void _addOrEditFood({Map<String, dynamic>? food}) async {
    final result = await showDialog(
      context: context,
      builder: (context) => FoodFormDialog(food: food),
    );
    if (result == true) {
      _loadFoods();
    }
  }

  // Hiển thị một trang mới để nhập thông tin
   void _addOrEditFood1({Map<String, dynamic>? food}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FoodFormScreen(food: food)),
    );
    if (result == true) {
      _loadFoods();
    }
  }

  void _deleteFood(int id) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xác nhận xóa"),
        content: Text("Bạn có chắc chắn muốn xóa món ăn này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Xóa"),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await DatabaseHelper.instance.deleteFood(id);
      _loadFoods();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quản lý món ăn")),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ảnh nền dịch sang phải
          Positioned(
            left: 90, // Dịch ảnh nền sang phải 50 pixel (có thể chỉnh sửa)
            child: Image.asset(
              "assets/icon/back.jpg",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width, // Đảm bảo ảnh đủ rộng
              height: MediaQuery.of(context).size.height,
            ),
          ),
          // Lớp làm mờ
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), // Điều chỉnh độ mờ
            child: Container(
              color: Colors.black.withOpacity(0.1), // Overlay để dễ nhìn nội dung
            ),
          ),
          // Nội dung chính
          foods.isEmpty
              ? Center(
                  child: Text(
                    "Chưa có món ăn nào",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    return Card(
                      color: Colors.white.withOpacity(0.8), // Làm mờ card
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditFood1(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

}
