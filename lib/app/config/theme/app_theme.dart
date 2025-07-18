import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static final Color _lightPrimaryColor = const Color(0xFF4B6F61);
  static final Color _lightBackgroundColor = const Color(0xFFFFFFFF);
  static final Color _lightTextColor = const Color(0xFF121212);

  static final Color _darkPrimaryColor = const Color(0xFF669985);
  static final Color _darkBackgroundColor = const Color(0xFF121212);
  static final Color _darkTextColor = const Color(0xFFF5F5F5);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _lightBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: _lightTextColor),
      titleTextStyle: GoogleFonts.manrope(
        color: _lightTextColor,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      onPrimary: Colors.white,
      secondary: _lightPrimaryColor,
      background: _lightBackgroundColor,
      onBackground: _lightTextColor,
      surface: _lightBackgroundColor,
      onSurface: _lightTextColor,
    ),
    textTheme: GoogleFonts.manropeTextTheme().apply(
      bodyColor: _lightTextColor,
      displayColor: _lightTextColor,
    ),
    iconTheme: IconThemeData(color: _lightTextColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: _lightPrimaryColor,
      unselectedItemColor: Colors.grey.shade600,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _darkBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: _darkTextColor),
      titleTextStyle: GoogleFonts.manrope(
        color: _darkTextColor,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: _darkPrimaryColor,
      onPrimary: Colors.black,
      secondary: _darkPrimaryColor,
      background: _darkBackgroundColor,
      onBackground: _darkTextColor,
      surface: _darkBackgroundColor,
      onSurface: _darkTextColor,
    ),
    textTheme: GoogleFonts.manropeTextTheme().apply(
      bodyColor: _darkTextColor,
      displayColor: _darkTextColor,
    ),
    iconTheme: IconThemeData(color: _darkTextColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1F1F1F),
      selectedItemColor: _darkPrimaryColor,
      unselectedItemColor: Colors.grey.shade500,
    ),
  );
}
