import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/database/database_helper.dart';

class FoodFormDialog extends StatefulWidget {
  final Map<String, dynamic>? food;
  const FoodFormDialog({Key? key, this.food}) : super(key: key);

  @override
  _FoodFormDialogState createState() => _FoodFormDialogState();
}

class _FoodFormDialogState extends State<FoodFormDialog> {
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
        "image": _imagePath ?? "",  // Đảm bảo ảnh luôn là String
      };

      if (widget.food == null) {
        await DatabaseHelper.instance.insertFood(food);
      } else {
        await DatabaseHelper.instance.updateFood(food);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.food == null ? "Thêm món ăn" : "Sửa món ăn"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Hủy")),
        ElevatedButton(onPressed: _saveFood, child: Text("Lưu")),
      ],
    );
  }
}
