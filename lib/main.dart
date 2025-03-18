import '/screen/food_list_screen.dart';
import 'package:flutter/material.dart';
import 'screen/food_form_dialog.dart';

void main() {
  runApp(MaterialApp(home: FoodListScreen(), debugShowCheckedModeBanner: false));
}

class MyApp extends StatelessWidget {
  @override
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}