import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/responsive_util.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/shared_preferences.dart';

class SelectLanguageGenericProvider extends BaseProvider {
  String? _selectedLanguage;
  Locale? _locale;

  // Store ARB data for the current language
  Map<String, dynamic> _currentArbData = {};

  // Cache for loaded ARB files to avoid repeated loading
  // final Map<String, Map<String, dynamic>> _arbCache = {};

  Locale? get locale => _locale;

  // Getter to access current ARB data
  Map<String, dynamic> get currentArbData => _currentArbData;

  bool get isRTL {
    return (_selectedLanguage == 'ar' || _selectedLanguage == 'he');
  }

  bool get isDe {
    return (_selectedLanguage == 'de');
  }

  SelectLanguageGenericProvider() {
    loadSavedLocale();
  }

  void updateLanguageCode(String languageCode) {
    _selectedLanguage = languageCode;
    setState();
  }

  Future<void> loadSavedLocale() async {
    Utils.logPrintAnalytics("loadSavedLocale code -- ${_selectedLanguage}");
    final String? languageCode =
        await Preferences.getString(Preferences.keyLanguageCode);

    if (!languageCode.isNullOrEmpty) {
      _locale = Locale(languageCode!);
    }
    setState();
  }

  String get selectedLanguage => _selectedLanguage ?? "";

  Future<void> setLanguage(String code) async {
    _selectedLanguage = code;
    _locale = Locale(code);
    Intl.defaultLocale = code;
    FirebaseAnalyticsService.userLanguage = code;

    setState();
  }

  /// Load ARB file for the specified language code
  Future<void> loadArbFile(String langCode) async {
    try {
      // Check if already cached
      // if (_arbCache.containsKey(langCode)) {
      //   _currentArbData = _arbCache[langCode]!;
      //   Utils.logPrintAnalytics("Loaded ARB from cache for language: $langCode");
      //   return;
      // }

      // Construct the ARB file path
      String arbFilePath = 'lib/l10n/intl_$langCode.arb';

      Utils.logPrintAnalytics("Loading ARB file: $arbFilePath");

      // Load the ARB file content
      String arbContent = await rootBundle.loadString(arbFilePath);

      // Parse JSON content
      Map<String, dynamic> arbData = json.decode(arbContent);

      // Cache the loaded data
      // _arbCache[langCode] = arbData;
      _currentArbData = arbData;
    } catch (e) {
      Utils.logPrintAnalytics(
          "Error loading ARB file for language $langCode: $e");

      // Fallback to English if the requested language file doesn't exist
      if (langCode != 'en') {
        Utils.logPrintAnalytics("Falling back to English ARB file");
        await loadArbFile('en');
      } else {
        _currentArbData = {};
      }
    }
    if (ResponsiveUtil.isWeb) {
      Future.delayed(const Duration(milliseconds: 100));
      final dynamic document = getDocument();
      document?.documentElement?.setAttribute('lang', langCode);
    }
  }

  /// Get localized string by key from current ARB data
  String getLocalizedString(String key, {String? fallback}) {
    if (_currentArbData.containsKey(key)) {
      return _currentArbData[key].toString();
    }

    Utils.logPrintAnalytics("Key '$key' not found in ARB data");
    return fallback ?? key;
  }

  /// Get all translation keys (excluding metadata keys that start with @)
  List<String> getAllTranslationKeys() {
    return _currentArbData.keys.where((key) => !key.startsWith('@')).toList();
  }

  /// Find key by value (reverse lookup)
  String getKeyFromValue(String targetValue) {
    for (String key in _currentArbData.keys) {
      if (!key.startsWith('@') &&
          _currentArbData[key].toString().toLowerCase() ==
              targetValue.toLowerCase()) {
        return key;
      }
    }
    return "";
  }

  /// Get all translations as a clean map (without metadata)
  Map<String, String> getAllTranslations() {
    Map<String, String> translations = {};
    for (String key in _currentArbData.keys) {
      if (!key.startsWith('@')) {
        translations[key] = _currentArbData[key].toString();
      }
    }
    return translations;
  }

  /// Check if a translation key exists
  bool hasTranslation(String key) {
    return _currentArbData.containsKey(key);
  }

  /// Clear ARB cache (useful for testing or memory management)
  void clearArbCache() {
    // _arbCache.clear();
    _currentArbData = {};
    Utils.logPrintAnalytics("ARB cache cleared");
  }

  // Get document safely on Web
  dynamic getDocument() {
    try {
      return (const bool.fromEnvironment('dart.library.html'))
          ? throw UnsupportedError("Not running on Web")
          : throw UnsupportedError("Not running on Web");
    } catch (e) {
      return null;
    }
  }
}
