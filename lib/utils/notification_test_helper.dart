import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:visaamigo/token_service.dart';
import 'package:visaamigo/utils/firebase_background_handler.dart';
import 'package:visaamigo/utils/utils.dart';

/// Helper class to test and demonstrate notification functionality
class NotificationTestHelper {
  static final FirebaseNotificationHandler _notificationHandler =
      FirebaseNotificationHandler();

  /// Test foreground notification handling
  static void testForegroundNotification(BuildContext context) {
    Utils.logPrint('🧪 Testing foreground notification...');

    // Simulate a notification when app is in foreground
    // Note: This will show a local notification banner for testing purposes
    // In real scenarios, foreground notifications don't show banners
    _notificationHandler.showNotification(
      'Test Notification',
      'This is a test notification when app is in foreground',
    );
  }

  /// Test Firebase messaging token
  static Future<void> testFirebaseToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      Utils.logPrint('🧪 Firebase Token: $token');
    } catch (e) {
      Utils.logPrint('❌ Error getting Firebase token: $e');
    }
  }

  /// Test notification permissions
  static Future<void> testNotificationPermissions() async {
    try {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      Utils.logPrint('🧪 Notification Settings:');
      Utils.logPrint(
          '  - Authorization Status: ${settings.authorizationStatus}');
      Utils.logPrint('  - Alert: ${settings.alert}');
      Utils.logPrint('  - Badge: ${settings.badge}');
      Utils.logPrint('  - Sound: ${settings.sound}');
    } catch (e) {
      Utils.logPrint('❌ Error getting notification settings: $e');
    }
  }

  /// Test foreground notification callback
  static void testForegroundNotificationCallback() {
    Utils.logPrint('🧪 Testing foreground notification callback...');
    TokenService.testForegroundNotificationCallback();
  }

  /// Test with iOS-like notification data structure
  static void testIOSNotificationData() {
    Utils.logPrint('🧪 Testing with iOS-like notification data structure...');

    // Simulate the exact data structure received from iOS
    final iosNotificationData = {
      'google.c.fid': 'eWVUHB31eEv_tOyUM7gAIf',
      'google.c.a.ts': 1751266408,
      'aps': {
        'alert': {
          'title': 'Test Notification',
          'body': 'This is a test notification from iOS'
        },
        'mutable-content': 1.0
      },
      'google.c.a.udt': 0,
      'google.c.a.c_id': 4810435441591144047,
      'google.c.a.e': 1,
      'google.c.a.c_l': 'test',
      'google.c.sender.id': 823730793969,
      'gcm.message_id': 1751266408743499,
      'gcm.n.e': 1
    };

    // Test the data conversion logic
    if (TokenService.foregroundNotificationCallback != null) {
      Utils.logPrint(
          '🧪 Executing callback with iOS-like data: $iosNotificationData');
      TokenService.foregroundNotificationCallback!(iosNotificationData);
    } else {
      Utils.logPrint('❌ Foreground notification callback is null!');
    }
  }

  /// Initialize notification handler for testing
  static Future<void> initializeForTesting(BuildContext context) async {
    Utils.logPrint('🧪 Initializing notification handler for testing...');
    await _notificationHandler.initializeFirebaseMessaging(context);
  }

  /// Show a custom notification
  static void showCustomNotification({
    required String title,
    required String body,
    String? payload,
  }) {
    _notificationHandler.showNotification(title, body);
    Utils.logPrint('🧪 Custom notification shown: $title - $body');
  }

  /// Get notification handler instance
  static FirebaseNotificationHandler get notificationHandler =>
      _notificationHandler;
}

/// Example usage in a widget:
///
/// ```dart
/// class NotificationTestWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text('Notification Test')),
///       body: Column(
///         children: [
///           ElevatedButton(
///             onPressed: () => NotificationTestHelper.testForegroundNotification(context),
///             child: Text('Test Foreground Notification'),
///           ),
///           ElevatedButton(
///             onPressed: () => NotificationTestHelper.testFirebaseToken(),
///             child: Text('Test Firebase Token'),
///           ),
///           ElevatedButton(
///             onPressed: () => NotificationTestHelper.testNotificationPermissions(),
///             child: Text('Test Permissions'),
///           ),
///           ElevatedButton(
///             onPressed: () => NotificationTestHelper.showCustomNotification(
///               title: 'Custom Notification',
///               body: 'This is a custom notification',
///             ),
///             child: Text('Show Custom Notification'),
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
