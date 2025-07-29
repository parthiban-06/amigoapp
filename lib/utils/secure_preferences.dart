import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:visaamigo/utils/utils.dart';

@deprecated
class SecureStoragePreferences {
  static const String email = "email";
  static const String name = "name";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String isSignUp = "isSignUp";
  static const String tutorialStatus = "tutorialStatus";
  static const String enableBiometric = "enableBiometric";
  static const String forgotEmail = "forgot_email";
  static const String LOCALE_KEY = 'locale';
  static const String keyLanguageCode = 'language_code';

  static FlutterSecureStorage? _preferences;

  static Future init() async => _preferences = FlutterSecureStorage();

  static clear() async {
    await _preferences?.deleteAll();
  }

  static removeKey(String key) async {
    return _preferences?.delete(key: key);
  }

  static getInt(String key) async {
    return (await _preferences?.containsKey(key: key) != null)
        ? int.parse(await _preferences?.read(key: key) ?? "-1")
        : -1;
  }

  static setInt(String key, int value) async {
    return _preferences?.write(key: key, value: value.toString());
  }

  static getBool(String key) async {
    return await _preferences!.containsKey(key: key)
        ? (await _preferences?.read(key: key) == "true" ? true : false)
        : false;
  }

  static setBool(String key, bool value) async {
    try {
      return _preferences?.write(key: key, value: value.toString());
    } catch (e) {
      Utils.logPrint("error: $e");
    }
  }

  static getString(String key) async {
    return await _preferences?.read(key: key);
  }

  static setString(String key, String value) async {
    return await _preferences?.write(key: key, value: value);
  }

  static Future setDouble(String key, double value) async {
    await _preferences?.write(key: key, value: value.toString());
  }

  static getDouble(String key) async {
    return (await _preferences?.containsKey(key: key) != null)
        ? double.parse(await _preferences?.read(key: key) ?? "0")
        : 0;
  }
}
