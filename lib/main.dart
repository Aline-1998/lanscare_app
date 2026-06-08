import 'package:flutter/material.dart';
import 'posyandu_lansia/onboarding_page.dart';
import 'posyandu_lansia/data_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DataStore();
    return AnimatedBuilder(
      animation: store,
      builder: (context, child) {
        return MaterialApp(
          title: 'LansCare',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F5A5C),
              primary: const Color(0xFF0F5A5C),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F5A5C),
              primary: const Color(0xFF0F5A5C),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: store.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const OnboardingPage(),
        );
      },
    );
  }
}
