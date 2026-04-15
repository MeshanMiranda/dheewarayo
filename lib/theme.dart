import 'package:flutter/material.dart';

const Color primaryDark = Color(0xFF003366);
const Color secondaryLight = Color(0xFF66CCFF);
const Color backgroundWhite = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF333333);
const Color textSecondary = Color(0xFFEEEEEE);

final ThemeData dheewarayoTheme = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: primaryDark,
  scaffoldBackgroundColor: backgroundWhite,

  colorScheme: const ColorScheme.light(
    primary: primaryDark,
    secondary: secondaryLight,
    surface: backgroundWhite,
    error: Colors.red,
    onPrimary: textSecondary,
    onSecondary: textPrimary,
    onSurface: textPrimary,
    onError: textSecondary,
    brightness: Brightness.light,
  ),

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

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: primaryDark,
    selectedItemColor: secondaryLight,
    unselectedItemColor: textSecondary,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
);

const Color darkBackground = Color(0xFF121212);
const Color darkSurface = Color(0xFF1E1E1E);
const Color darkPrimary = Color(0xFF80d4ff);
const Color darkSecondary = Color(0xFF66CCFF);

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
    elevation: 0,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
  cardTheme: CardThemeData(
    color: darkSurface,
    elevation: 2,
    surfaceTintColor: darkSurface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: darkSurface,
    selectedItemColor: darkPrimary,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
);
