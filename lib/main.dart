import 'package:favors/pages/home.dart';
import 'package:favors/pages/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final lightTheme = ThemeData(
    fontFamily: "Ubuntu",
    primarySwatch: Colors.lightGreen,
    primaryColor: Colors.lightGreen.shade600,
    accentColor: Colors.orangeAccent.shade400,
    cardColor: Colors.lightGreen.shade100,
    primaryColorBrightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter', theme: lightTheme, home: LoginPage());
  }
}
