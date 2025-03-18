# vuhoanganh_22a1001d0027

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Quản Lý Món Ăn - Flutter App

## Giới Thiệu

Dự án này là một ứng dụng Flutter giúp quản lý danh sách món ăn. Chức năng chính bao gồm:
- Hiển thị danh sách món ăn
- Thêm, sửa, xóa món ăn
- Chọn hình ảnh cho món ăn
- Lưu trữ dữ liệu bằng SQLite

## Cài Đặt

### Yêu Cầu
- Flutter SDK
- Dart SDK
- Thiết bị hoặc giả lập Android/iOS

### Cách Chạy Dự Án
1. Clone repo:
   ```sh
   git clone https://github.com/VuHoangAnh2110/vuhoanganh_22a1001d0027.git
   cd vuhoanganh_22a1001d0027
   ```
2. Cài đặt package:
   ```sh
   flutter pub get
   ```
3. Chạy app:
   ```sh
   flutter run
   ```

## Cấu Trúc Thư Mục
```
flutter-food-manager/
│── lib/
│   │── main.dart          # Chạy ứng dụng
│   │── screen/
│   │   │── food_list_screen.dart  # Màn hình danh sách món ăn
│   │   │── food_form_screen.dart  # Màn hình thêm/sửa món ăn
│   │── database/
│   │   │── database_helper.dart  # Xử lý SQLite
│── assets/
│── pubspec.yaml          # Các dependencies
│── README.md             # Tài liệu hướng dẫn
```

## Chức Năng Chi Tiết

### 1. Hiển Thị Danh Sách Món Ăn
- Sử dụng `ListView.builder` để hiển thị danh sách
- Hỗ trợ hiển thị hình ảnh đính kèm

### 2. Thêm/Sửa Món Ăn
- Chuyển sang một trang mới khi bấm «+ Add»
- Form nhập tên, giá, đơn vị, hình ảnh

### 3. Xóa Món Ăn
- Nút xóa trên mỗi món ăn trong danh sách
- Xoá dữ liệu khỏi SQLite

## Dependencies
- `sqflite` - Quản lý dữ liệu SQLite
- `path_provider` - Lưu trữ tập tin
- `image_picker` - Chọn hình ảnh từ thư viện

## Liên Hệ
Tác giả: [Your Name]
GitHub: [Your Repo]
Email: your-email@example.com

