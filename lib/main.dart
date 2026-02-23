import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/review_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const LanguageTrainerApp());
}

class LanguageTrainerApp extends StatefulWidget {
  const LanguageTrainerApp({super.key});

  @override
  State<LanguageTrainerApp> createState() =>
      _LanguageTrainerAppState();
}

class _LanguageTrainerAppState
    extends State<LanguageTrainerApp> {

  bool isDarkMode = false;
  String userName = "Language Learner";

  // ===============================
  // LOAD SAVED DATA
  // ===============================
  Future<void> loadData() async {
    final prefs =
        await SharedPreferences.getInstance();

    setState(() {
      userName =
          prefs.getString("userName") ??
              "Language Learner";

      isDarkMode =
          prefs.getBool("darkMode") ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ===============================
  // CHANGE THEME
  // ===============================
  void toggleTheme(bool value) async {
    final prefs =
        await SharedPreferences.getInstance();

    setState(() {
      isDarkMode = value;
    });

    await prefs.setBool("darkMode", value);
  }

  // ===============================
  // CHANGE NAME
  // ===============================
  void changeName(String name) async {
    final prefs =
        await SharedPreferences.getInstance();

    setState(() {
      userName = name;
    });

    await prefs.setString("userName", name);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode:
          isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
        ),
      ),

      home: MainNavigation(
        isDarkMode: isDarkMode,
        onThemeChanged: toggleTheme,
        userName: userName,
        onNameChanged: changeName,
      ),
    );
  }
}

// ======================================
// MAIN NAVIGATION (มีเมนูล่าง)
// ======================================

class MainNavigation extends StatefulWidget {

  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  final String userName;
  final Function(String) onNameChanged;

  const MainNavigation({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.userName,
    required this.onNameChanged,
  });

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    final screens = [
      const HomeScreen(),
      PracticeScreen(),
      const ReviewScreen(),
      ProfileScreen(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        userName: widget.userName,
        onNameChanged: widget.onNameChanged,
      ),
    ];

    return Scaffold(

      body: screens[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Practice",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: "Review",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
