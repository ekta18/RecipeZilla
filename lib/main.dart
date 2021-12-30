import 'package:flutter/material.dart';
import 'package:recipezilla_app/views/home.dart';

void main() {
  runApp(const RecipeZillaApp());
}

class RecipeZillaApp extends StatelessWidget {
  const RecipeZillaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
