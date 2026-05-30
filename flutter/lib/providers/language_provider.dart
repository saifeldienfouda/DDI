import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _langKey = "app_language";
  Locale _locale = const Locale('en');

  LanguageProvider() {
    _loadLanguageFromPrefs();
  }

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  void setLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, languageCode);
  }

  void toggleLanguage() {
    if (isArabic) {
      setLanguage('en');
    } else {
      setLanguage('ar');
    }
  }

  void _loadLanguageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_langKey) ?? 'en';
    _locale = Locale(langCode);
    notifyListeners();
  }
}
