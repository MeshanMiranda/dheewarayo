import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// LocaleProvider manages the language state of the app
class LocaleProvider extends ChangeNotifier {
  // Private variable to hold the current language (locale)
  Locale _locale;

  // Constructor sets up the default language (English by default)
  LocaleProvider({String initialLocale = 'en'})
    : _locale = Locale(initialLocale);

  // Getter to access the current language from other parts of the app
  Locale get locale => _locale;

  // Function to change the app's language
  Future<void> setLocale(Locale newLocale) async {
    // Only allow English ('en') and Sinhala ('si')
    if (!['en', 'si'].contains(newLocale.languageCode)) return;

    // Only update if the new language is different from the current one
    if (_locale != newLocale) {
      _locale = newLocale;
      // Notify all listening widgets to rebuild with the new language
      notifyListeners();
      
      // Save the selected language to local storage so it persists across app restarts
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', newLocale.languageCode);
    }
  }
}
