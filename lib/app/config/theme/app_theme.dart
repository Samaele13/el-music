import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static final Color _lightPrimaryColor = const Color(0xFF5C7E6D);
  static final Color _lightBackgroundColor = const Color(0xFFF7F7F7);
  static final Color _lightTextColor = const Color(0xFF1C1C1E);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _lightBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: _lightTextColor),
      titleTextStyle: GoogleFonts.manrope(
        color: _lightTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      onPrimary: Colors.white,
      secondary: _lightPrimaryColor,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: _lightTextColor,
    ),
    textTheme: GoogleFonts.manropeTextTheme().apply(
      bodyColor: _lightTextColor,
      displayColor: _lightTextColor,
    ),
    iconTheme: IconThemeData(
      color: _lightTextColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: _lightPrimaryColor,
      unselectedItemColor: Colors.grey.shade500,
      elevation: 5,
      
    ),
  );
}
