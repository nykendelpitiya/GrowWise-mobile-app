import 'package:flutter/material.dart';

class T extends ChangeNotifier {
  static final T instance = T._internal();

  factory T() => instance;

  T._internal();

  String _currentLanguage = "en";

  String get currentLanguage => _currentLanguage;

  final Map<String, Map<String, String>> _cache = {};

  void changeLanguage(String lang) {
    _currentLanguage = lang;
    notifyListeners();
  }

  void saveTranslation({
    required String lang,
    required String key,
    required String value,
  }) {
    _cache.putIfAbsent(lang, () => {});
    _cache[lang]![key] = value;
  }

  String? getTranslation({
    required String lang,
    required String key,
  }) {
    return _cache[lang]?[key];
  }
}