import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/utils/utils.dart';

class TokenService {
  static const MethodChannel _channel = MethodChannel('tokenChannel');

  // Callback for foreground notifications
  static Function(Map<String, dynamic>)? onForegroundNotificationReceived;

  // Getter for testing purposes
  static Function(Map<String, dynamic>)? get foregroundNotificationCallback =>
      onForegroundNotificationReceived;

  // Set up method call handler to receive tokens
  static void setupTokenListener(BuildContext? context) {
    Utils.logPrint('🔧 Setting up TokenService method channel listener...');
    _channel.setMethodCallHandler((call) => _handleMethodCall(call, context));
    Utils.logPrint('✅ TokenService method channel listener setup completed');
  }

  // Handle incoming method calls
  static Future<dynamic> _handleMethodCall(MethodCall call,
      [BuildContext? context]) async {
    Utils.logPrint('📱 TokenService received method call: \\${call.method}');

    switch (call.method) {
      case 'onFCMTokenReceived':
        return _handleFCMTokenReceived(call.arguments);
      case 'onAPNSTokenReceived':
        return _handleAPNSTokenReceived(call.arguments);
      case 'onNotificationTapped':
        return _handleNotificationTapped(call.arguments);
      case 'onNotificationSettingsOpened':
        return _handleNotificationSettingsOpened();
      case 'onForegroundNotificationReceived':
        return _handleForegroundNotificationReceived(call.arguments, context);
      default:
        return _handleUnknownMethod(call.method);
    }
  }

  // Handle FCM token received
  static void _handleFCMTokenReceived(dynamic arguments) {
    Utils.logPrint('FCM Token received: $arguments');
    // Handle FCM token
  }

  // Handle APNS token received
  static void _handleAPNSTokenReceived(dynamic arguments) {
    Utils.logPrint('APNS Token received: $arguments');
    // Handle APNS token
  }

  // Handle notification tap
  static void _handleNotificationTapped(dynamic arguments) {
    Utils.logPrint('Notification tapped: $arguments');
    Utils.logPrint('Arguments type: ${arguments.runtimeType}');

    if (arguments is Map) {
      final notificationData = _convertMapData(arguments);
      Utils.logPrint('Converted tap notification data: $notificationData');
      // Handle the notification tap data here
    }
  }

  // Handle notification settings opened
  static void _handleNotificationSettingsOpened() {
    Utils.logPrint('Notification settings opened');
    // Handle settings opened
  }

  // Handle foreground notification received
  static void _handleForegroundNotificationReceived(dynamic arguments,
      [BuildContext? context]) {
    Utils.logPrint('🎯 Foreground notification received: $arguments');
    Utils.logPrint(
        '🎯 Callback is null: \\${onForegroundNotificationReceived == null}');
    Utils.logPrint('🎯 Arguments type: \\${arguments.runtimeType}');

    if (arguments is Map) {
      final notificationData = _convertMapData(arguments);
      Utils.logPrint('🎯 Converted notification data: $notificationData');
      _executeForegroundCallback(notificationData);
    } else {
      Utils.logPrint(
          '❌ Foreground notification arguments are not Map: \\${arguments.runtimeType}');
    }
  }

  // Handle unknown method call
  static void _handleUnknownMethod(String method) {
    Utils.logPrint('❓ Unknown method call: $method');
  }

  // Convert Map<Object?, Object?> to Map<String, dynamic>
  static Map<String, dynamic> _convertMapData(Map rawMap) {
    final notificationData = <String, dynamic>{};

    for (final entry in rawMap.entries) {
      final key = entry.key?.toString() ?? '';
      final value = entry.value;
      notificationData[key] = value;
    }

    return notificationData;
  }

  // Execute foreground notification callback
  static void _executeForegroundCallback(
      Map<String, dynamic> notificationData) {
    if (onForegroundNotificationReceived != null) {
      Utils.logPrint('🎯 Executing foreground notification callback');
      onForegroundNotificationReceived!(notificationData);
    } else {
      Utils.logPrint('❌ Foreground notification callback is null!');
    }
  }

  // Set callback for foreground notifications
  static void setForegroundNotificationCallback(
      Function(Map<String, dynamic>) callback) {
    Utils.logPrint('🔧 Setting foreground notification callback...');
    onForegroundNotificationReceived = callback;
    Utils.logPrint('✅ Foreground notification callback set successfully');
  }

  // Get FCM Token
  static Future<String?> getFCMToken() async {
    try {
      final String token = await _channel.invokeMethod('getFCMToken');
      return token;
    } on PlatformException catch (e) {
      Utils.logPrint('Error getting FCM token: ${e.message}');
      return null;
    }
  }

  // Get APNS Token
  static Future<String?> getAPNSToken() async {
    try {
      final String token = await _channel.invokeMethod('getAPNSToken');
      return token;
    } on PlatformException catch (e) {
      Utils.logPrint('Error getting APNS token: ${e.message}');
      return null;
    }
  }

  // Get Notification Settings
  static Future<Map<String, dynamic>?> getNotificationSettings() async {
    try {
      final Map<String, dynamic> settings =
          await _channel.invokeMethod('getNotificationSettings');
      return settings;
    } on PlatformException catch (e) {
      Utils.logPrint('Error getting notification settings: ${e.message}');
      return null;
    }
  }

  // Test method to verify callback is working
  static void testForegroundNotificationCallback() {
    Utils.logPrint('🧪 Testing foreground notification callback...');
    if (onForegroundNotificationReceived != null) {
      final testData = {
        'test': 'data',
        'timestamp': DateTime.now().toIso8601String(),
        'message': 'This is a test notification callback',
      };
      Utils.logPrint('🧪 Executing test callback with data: $testData');
      onForegroundNotificationReceived!(testData);
    } else {
      Utils.logPrint('❌ Foreground notification callback is null during test!');
    }
  }
}
