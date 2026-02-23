import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LanguageTrainerApp());
}

class LanguageTrainerApp extends StatelessWidget {
  const LanguageTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Trainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const HomeScreen(),
    );
  }
}
