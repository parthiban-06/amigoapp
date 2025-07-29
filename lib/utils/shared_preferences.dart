import 'dart:convert';

import 'package:encrypt_shared_preferences/provider.dart';

import '../features/ai_assistant/models/ai_get_preferences_questions_model.dart';

class Preferences {
  static const String email = "email";
  static const String name = "name";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String isSignUp = "isSignUp";
  static const String enableBiometric = "enableBiometric";
  static const String enableMfa = "enableMfa";
  static const String enableMfaTemp = "enableMfaTemp";
  static const String loginAttempts = "loginAttempts";
  static const String lockOutTime = "lockOutTime";
  static const String registerEmailFirstTime = "registerEmailFirstTime";

  // static const String forgotEmail = "forgot_email";
  static const String keyLanguageCode = 'language_code';
  static const String walletReminder = 'walletReminder';
  static const String keyIsUserLoggedInOnce = 'IsUserLoggedInOnce';
  static const String tutorialStatus = "tutorialStatus";
  static const String isCompanion = "isCompanion";
  static const String listCompanion = "listCompanion";
  static const String isRateUs = "isRateUs";
  static const String isWallet = "isWallet";
  static const String tutorialEvaScreenStatus = "tutorialEvaScreenStatus";
  static const String isComeFromReWatchHomeTutorial =
      "isComeFromReWatchHomeTutorial";
  static const String isComeFromReWatchEVATutorial =
      "isComeFromReWatchEVATutorial";
  static const String isPromptListLoaded = "isPromptListLoaded";
  static const String KeyUserModel = "KeyUserModel";
  static const String KeyIs24Time = "Is24Time";

  static const String isGettingToKnowDone = "gettingToKnowDone";
  static const String isGettingToKnowNavigation = "isGettingToKnowNavigation";
  static const String isWelcomeScreenSet = "WelcomeScreenSet";
  static const String isGettingScreenSet = "isGettingScreenSet";
  static const String isBiometricsSetupProgress = "BiometricsSetupProgress";
  static const String isNotificationPermissionEnable =
      "isNotificationPermissionEnable";
  static const String isNotificationSetupProgress =
      "isNotificationSetupProgress";

  static const String keyQuestionList = "keyQuestionList";
  static const String keyAppConfig = "appConfigData";
  static const String keyAnalyticsTracking = "appAnalyticsTracking";

  static EncryptedSharedPreferences? _preferences;

  static Future init() async {
    _preferences = EncryptedSharedPreferences.getInstance();
  }

  static reload() async {
    await _preferences?.reload();
  }

  static clear() async {
    await _preferences?.clear();
  }

  static removeKey(String key) async {
    return _preferences?.remove(key);
  }

  static getInt(String key) async {
    return _preferences?.getInt(key);
  }

  static setInt(String key, int value) async {
    return _preferences?.setInt(key, value, notify: true);
  }

  static getBool(String key) async {
    return _preferences?.getBoolean(key) ?? false;
  }

  static Future<bool?> getBoolWithNull(String key) async {
    return _preferences?.getBoolean(key);
  }

  static setBool(String key, bool value) async {
    return _preferences?.setBoolean(key, value, notify: true);
  }

  static getString(String key) async {
    return _preferences?.getString(key) ?? "";
  }

  static setString(String key, String value) async {
    return _preferences?.setString(key, value, notify: true);
  }

  static Future setDoubleValue(String key, double value) async {
    await _preferences?.setDouble(key, value, notify: true);
  }

  static getDoubleValue(String key) async {
    return _preferences?.getDouble(key);
  }

  static Future<void> setModelData<T>(String key, T value) async {
    if (value is String) {
      await _preferences?.setString(key, value);
    } else {
      await _preferences?.setString(key, jsonEncode(value));
    }
  }

  static Future<T?> getModelData<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    String? jsonString = _preferences?.getString(key);
    if (jsonString == null) return null;

    if (T == String) return jsonString as T;
    return fromJson(jsonDecode(jsonString));
  }

  static Future<void> saveQuestionsList(List<Questions> list) async {
    final jsonList = list.map((q) => q.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _preferences?.setString(keyQuestionList, jsonString);
  }

  static Future<List<Questions>?> getQuestionsList() async {
    final jsonString = _preferences?.getString(keyQuestionList);
    if (jsonString == null) return null;

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => Questions.fromJson(e)).toList();
  }

  static Future<void> setMapData(String key, Map<String, dynamic>? data) async {
    if (data != null) {
      await _preferences?.setString(key, jsonEncode(data));
    } else {
      await _preferences?.remove(key);
    }
  }

  static Future<Map<String, dynamic>?> getMapData(String key) async {
    final jsonString = _preferences?.getString(key);
    if (jsonString == null || jsonString.isEmpty) return null;
    return jsonDecode(jsonString);
  }
}
