import 'package:flutter/material.dart';

// Color Palette based on design document
const Color primaryDark = Color(0xFF003366); // Dark Blue
const Color secondaryLight = Color(0xFF66CCFF); // Light Blue
const Color backgroundWhite = Color(0xFFFFFFFF); // White
const Color textPrimary = Color(0xFF333333); // Dark Text
const Color textSecondary = Color(0xFFEEEEEE); // Light Text

final ThemeData dheewarayoTheme = ThemeData(
  // Use a modern, readable font
  fontFamily: 'Roboto',

  // Primary color for the app (used for AppBar, primary buttons)
  primaryColor: primaryDark,

  // Scaffold background color
  scaffoldBackgroundColor: backgroundWhite,

  // Color scheme for modern Material 3 design
  colorScheme: ColorScheme.light(
    primary: primaryDark,
    secondary: secondaryLight,
    surface: backgroundWhite,
    background: backgroundWhite,
    error: Colors.red,
    onPrimary: textSecondary, // Text on primary color
    onSecondary: textPrimary, // Text on secondary color
    onSurface: textPrimary, // Text on surface color
    onBackground: textPrimary, // Text on background color
    onError: textSecondary, // Text on error color
    brightness: Brightness.light,
  ),

  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryDark,
    foregroundColor: textSecondary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: textSecondary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: secondaryLight,
      foregroundColor: primaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),

  cardTheme: CardThemeData(
    color: backgroundWhite,
    elevation: 2,
    surfaceTintColor: backgroundWhite,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: primaryDark,
    selectedItemColor: secondaryLight,
    unselectedItemColor: textSecondary,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
);
