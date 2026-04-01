import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ThemeProvider manages the dark/light mode state of the app
class ThemeProvider extends ChangeNotifier {
  // Private variable to hold the current theme mode
  ThemeMode _themeMode;

  // Constructor sets the initial theme based on saved preferences
  ThemeProvider({bool initialDarkMode = false})
    : _themeMode = initialDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Getter to access the current theme mode
  ThemeMode get themeMode => _themeMode;

  // Helper getter to check if dark mode is currently active
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Function to turn dark mode on or off
  Future<void> toggleTheme(bool isOn) async {
    // Update the theme mode based on the user's choice
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    
    // Notify all listening widgets to rebuild with the new theme
    notifyListeners();
    
    // Save the theme preference to local storage so it persists across app restarts
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isOn);
  }
}
