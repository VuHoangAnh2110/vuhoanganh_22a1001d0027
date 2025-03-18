import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/database/database_helper.dart';

class FoodFormScreen extends StatefulWidget {
  final Map<String, dynamic>? food;
  const FoodFormScreen({Key? key, this.food}) : super(key: key);

  @override
  _FoodFormScreenState createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends State<FoodFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _unitController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.food?['name'] ?? '');
    _priceController = TextEditingController(text: widget.food?['price'] ?? '');
    _unitController = TextEditingController(text: widget.food?['unit'] ?? '');
    _imagePath = widget.food?['image'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _saveFood() async {
    if (_formKey.currentState!.validate()) {
      final food = {
        "id": widget.food?['id'],
        "name": _nameController.text,
        "price": _priceController.text,
        "unit": _unitController.text,
        "image": _imagePath ?? "",
      };

      if (widget.food == null) {
        await DatabaseHelper.instance.insertFood(food);
      } else {
        await DatabaseHelper.instance.updateFood(food);
      }

      Navigator.pop(context, true); // Trả về "true" để cập nhật danh sách
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food == null ? "Thêm món ăn" : "Sửa món ăn"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Tên món ăn"),
                validator: (value) => value!.isEmpty ? "Nhập tên món ăn" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Giá"),
                validator: (value) => value!.isEmpty ? "Nhập giá" : null,
              ),
              TextFormField(
                controller: _unitController,
                decoration: InputDecoration(labelText: "Đơn vị tính"),
                validator: (value) => value!.isEmpty ? "Nhập đơn vị tính" : null,
              ),
              SizedBox(height: 10),
              _imagePath != null
                  ? Image.file(File(_imagePath!), height: 100) // Hiển thị ảnh
                  : Text("Chưa có ảnh"),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Chọn ảnh"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveFood,
                child: Text("Lưu món ăn"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
