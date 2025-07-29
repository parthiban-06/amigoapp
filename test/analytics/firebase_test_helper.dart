import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper class to initialize Firebase for testing
class FirebaseTestHelper {
  static bool _isInitialized = false;

  /// Initialize Firebase for testing
  static Future<void> initializeFirebaseForTesting() async {
    if (_isInitialized) return;

    TestWidgetsFlutterBinding.ensureInitialized();

    // Set up Firebase Core for testing
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/firebase_core');

    // Mock Firebase Core responses
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'Firebase#initializeCore':
          return [
            {
              'name': '[DEFAULT]',
              'options': {
                'apiKey': 'test-api-key',
                'appId': 'test-app-id',
                'messagingSenderId': 'test-sender-id',
                'projectId': 'test-project-id',
              },
              'pluginConstants': {},
            }
          ];
        case 'Firebase#initializeApp':
          return {
            'name': '[DEFAULT]',
            'options': {
              'apiKey': 'test-api-key',
              'appId': 'test-app-id',
              'messagingSenderId': 'test-sender-id',
              'projectId': 'test-project-id',
            },
            'pluginConstants': {},
          };
        default:
          return null;
      }
    });

    // Mock Firebase Analytics responses with more comprehensive coverage
    const MethodChannel analyticsChannel =
        MethodChannel('plugins.flutter.io/firebase_analytics');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(analyticsChannel,
            (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'Analytics#logEvent':
          // Mock successful event logging
          return null;
        case 'Analytics#logScreenView':
          // Mock successful screen view logging
          return null;
        case 'Analytics#setUserId':
          // Mock successful user ID setting (including null values)
          return null;
        case 'Analytics#setUserProperty':
          // Mock successful user property setting (including null values)
          return null;
        case 'Analytics#setAnalyticsCollectionEnabled':
          // Mock successful analytics collection setting
          return null;
        default:
          return null;
      }
    });

    // Initialize Firebase
    await Firebase.initializeApp();
    _isInitialized = true;
  }

  /// Reset Firebase state
  static void resetFirebase() {
    _isInitialized = false;
  }
}
