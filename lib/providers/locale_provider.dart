import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale;

  LocaleProvider({String initialLocale = 'en'})
    : _locale = Locale(initialLocale);

  Locale get locale => _locale;

  Future<void> setLocale(Locale newLocale) async {
    if (!['en', 'si'].contains(newLocale.languageCode)) return;
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', newLocale.languageCode);
    }
  }
}
