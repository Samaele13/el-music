import 'package:el_music/app/config/theme/app_theme.dart';
import 'package:el_music/presentation/pages/main_navigation/main_navigation_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Music',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MainNavigationPage(),
    );
  }
}
