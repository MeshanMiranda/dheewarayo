import 'package:flutter/material.dart';

// Color Palette based on design document
// These are the base colors used throughout the app
const Color primaryDark = Color(0xFF003366); // Dark Blue
const Color secondaryLight = Color(0xFF66CCFF); // Light Blue
const Color backgroundWhite = Color(0xFFFFFFFF); // White
const Color textPrimary = Color(0xFF333333); // Dark Text
const Color textSecondary = Color(0xFFEEEEEE); // Light Text

// The main light theme configuration for the app
final ThemeData dheewarayoTheme = ThemeData(
  // Use a modern, readable font for all text
  fontFamily: 'Roboto',

  // Primary color for the app (used for AppBar, primary buttons)
  primaryColor: primaryDark,

  // Scaffold background color (the main background of screens)
  scaffoldBackgroundColor: backgroundWhite,

  // Color scheme for modern Material 3 design, organizing colors logically
  colorScheme: const ColorScheme.light(
    primary: primaryDark,
    secondary: secondaryLight,
    surface: backgroundWhite,
    error: Colors.red,
    onPrimary: textSecondary, // Text on primary color
    onSecondary: textPrimary, // Text on secondary color
    onSurface: textPrimary, // Text on surface color
    onError: textSecondary, // Text on error color
    brightness: Brightness.light,
  ),

  // Configuration for the AppBar (top navigation bar)
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryDark,
    foregroundColor: textSecondary,
    elevation: 0, // Removes the shadow under the AppBar
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: textSecondary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Configuration for raised buttons (ElevatedButton)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: secondaryLight,
      foregroundColor: primaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),

  // Configuration for cards (Card widget)
  cardTheme: CardThemeData(
    color: backgroundWhite,
    elevation: 2, // Slight shadow for depth
    surfaceTintColor: backgroundWhite,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
  ),

  // Configuration for the bottom navigation bar
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: primaryDark,
    selectedItemColor: secondaryLight, // Color for the active tab
    unselectedItemColor: textSecondary, // Color for inactive tabs
    type: BottomNavigationBarType.fixed, // Keeps all tabs visible
    elevation: 8,
  ),
);

// Define dark theme colors
// These colors replace the light ones when dark mode is enabled
const Color darkBackground = Color(0xFF121212); // Very dark grey for background
const Color darkSurface = Color(0xFF1E1E1E); // Slightly lighter grey for cards
const Color darkPrimary = Color(
  0xFF80d4ff,
); // Lighter version of primary for dark mode
const Color darkSecondary = Color(0xFF66CCFF);

// The main dark theme configuration for the app
final ThemeData dheewarayoDarkTheme = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: darkPrimary,
  scaffoldBackgroundColor: darkBackground,
  colorScheme: const ColorScheme.dark(
    primary: darkPrimary,
    secondary: darkSecondary,
    surface: darkSurface,
    error: Colors.redAccent,
    onPrimary: darkBackground,
    onSecondary: darkBackground,
    onSurface: textSecondary,
    onError: textSecondary,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: darkSurface,
    foregroundColor: textSecondary,
    elevation: 0, // Removes the shadow under the AppBar
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: textSecondary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkPrimary,
      foregroundColor: darkBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
  cardTheme: CardThemeData(
    color: darkSurface,
    elevation: 2, // Slight shadow for depth
    surfaceTintColor: darkSurface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: darkSurface,
    selectedItemColor: darkPrimary, // Color for the active tab
    unselectedItemColor: Colors.grey, // Color for inactive tabs
    type: BottomNavigationBarType.fixed, // Keeps all tabs visible
    elevation: 8,
  ),
);
