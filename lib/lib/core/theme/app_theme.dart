
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF07569A);
  static const Color darkColor = Color(0xFF083D70);
  static const Color backgroundColor = Color(0xFFF3F6FA);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: darkColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
