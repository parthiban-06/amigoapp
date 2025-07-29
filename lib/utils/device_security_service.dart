import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:visaamigo/utils/utils.dart';

class DeviceSecurityService {
  static const MethodChannel _channel =
      MethodChannel('device_security_channel');

  /// Checks if the device is rooted (Android) or jailbroken (iOS)
  /// Returns true if device is compromised, false otherwise
  static Future<bool> isDeviceCompromised() async {
    // Skip check on web platform
    if (kIsWeb) {
      return false;
    }

    try {
      final bool isCompromised =
          await _channel.invokeMethod('isDeviceCompromised');
      Utils.logPrint('Device compromised check result: $isCompromised');
      return isCompromised;
    } on PlatformException catch (e) {
      Utils.logPrint('Error checking device compromise: ${e.message}');
      // In case of error, assume device is safe to avoid blocking legitimate users
      return false;
    } catch (e) {
      Utils.logPrint('Unexpected error in device compromise check: $e');
      return false;
    }
  }

  /// Checks if developer mode is enabled on the device
  /// Returns true if developer mode is enabled, false otherwise
  static Future<bool> isDeveloperModeEnabled() async {
    // Skip check on web platform
    if (kIsWeb) {
      return false;
    }

    try {
      final bool isDeveloperMode =
          await _channel.invokeMethod('isDeveloperModeEnabled');
      Utils.logPrint('Developer mode check result: $isDeveloperMode');
      return isDeveloperMode;
    } on PlatformException catch (e) {
      Utils.logPrint('Error checking developer mode: ${e.message}');
      // In case of error, assume developer mode is disabled to avoid blocking legitimate users
      return false;
    } catch (e) {
      Utils.logPrint('Unexpected error in developer mode check: $e');
      return false;
    }
  }

  /// Comprehensive device security check
  /// Returns a map with security status information
  static Future<Map<String, dynamic>> performSecurityCheck() async {
    // Skip check on web platform
    if (kIsWeb) {
      return {
        'isCompromised': false,
        'isDeveloperMode': false,
        'isSecure': true,
        'platform': 'web',
      };
    }

    try {
      final dynamic result =
          await _channel.invokeMethod('performSecurityCheck');
      Utils.logPrint('Security check result: $result');

      // Handle type casting safely
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      } else {
        return {};
      }
    } on PlatformException catch (e) {
      Utils.logPrint('Error performing security check: ${e.message}');
      // In case of error, assume device is secure to avoid blocking legitimate users
      return {
        'isCompromised': false,
        'isDeveloperMode': false,
        'isSecure': true,
        'platform': Platform.isAndroid ? 'android' : 'ios',
        'error': e.message,
      };
    } catch (e) {
      Utils.logPrint('Unexpected error in security check: $e');
      return {
        'isCompromised': false,
        'isDeveloperMode': false,
        'isSecure': true,
        'platform': Platform.isAndroid ? 'android' : 'ios',
        'error': e.toString(),
      };
    }
  }
}
