import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeitcode/theme/themeData.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = AppThemes.darkTheme;
  bool _isDarkMode = true;

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('Users').doc(user.uid).snapshots().listen((snapshot) {
        if (snapshot.exists) {
          bool isDark = snapshot['darkmode'] ?? true;
          _currentTheme = isDark ? AppThemes.darkTheme : AppThemes.lightTheme;
          _isDarkMode = isDark;
          notifyListeners(); // 🔄 Met à jour toute l'application
        }
      });
    }
  }

  void toggleTheme() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
        'darkmode': !_isDarkMode,
      });
    }
  }
}
