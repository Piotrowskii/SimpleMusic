import 'package:flutter/material.dart';

class ColorProvider extends ChangeNotifier{

  static Color primaryColor = Color.fromARGB(255, 58, 89, 209);
  static ThemeData currentTheme = ThemeData(scaffoldBackgroundColor: Colors.white,primaryColor: Color.fromARGB(255,58, 89, 209),inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white,iconColor: Colors.white),appBarTheme: AppBarTheme(color: Colors.white,backgroundColor: Colors.white) );

}