import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/utils/device_security_service.dart';

void main() {
  group('DeviceSecurityService Tests', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    group('Web Platform Tests', () {
      test('should return false for all checks on web platform', () async {
        // Mock web platform
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('device_security_channel'),
          (MethodCall methodCall) async {
            // This should not be called on web
            throw PlatformException(code: 'NOT_IMPLEMENTED');
          },
        );

        // Note: In a real web environment, kIsWeb would be true
        // For testing purposes, we'll test the individual methods
        final isCompromised = await DeviceSecurityService.isDeviceCompromised();
        final isDeveloperMode =
            await DeviceSecurityService.isDeveloperModeEnabled();
        final securityResult =
            await DeviceSecurityService.performSecurityCheck();

        // These should handle errors gracefully and return safe defaults
        expect(isCompromised, isFalse);
        expect(isDeveloperMode, isFalse);
        expect(securityResult['isSecure'], isTrue);
        // Note: In real web environment this would be 'web', but in test it will be platform-specific
        expect(securityResult['platform'], isA<String>());
      });
    });

    group('Mobile Platform Tests', () {
      test('should handle successful security checks', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('device_security_channel'),
          (MethodCall methodCall) async {
            switch (methodCall.method) {
              case 'isDeviceCompromised':
                return false;
              case 'isDeveloperModeEnabled':
                return false;
              case 'performSecurityCheck':
                return {
                  'isCompromised': false,
                  'isDeveloperMode': false,
                  'isSecure': true,
                  'platform': Platform.isAndroid ? 'android' : 'ios',
                };
              default:
                throw PlatformException(code: 'NOT_IMPLEMENTED');
            }
          },
        );

        final isCompromised = await DeviceSecurityService.isDeviceCompromised();
        final isDeveloperMode =
            await DeviceSecurityService.isDeveloperModeEnabled();
        final securityResult =
            await DeviceSecurityService.performSecurityCheck();

        expect(isCompromised, isFalse);
        expect(isDeveloperMode, isFalse);
        expect(securityResult['isSecure'], isTrue);
        expect(securityResult['platform'], isA<String>());
      });

      test('should handle compromised device detection', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('device_security_channel'),
          (MethodCall methodCall) async {
            switch (methodCall.method) {
              case 'isDeviceCompromised':
                return true;
              case 'isDeveloperModeEnabled':
                return false;
              case 'performSecurityCheck':
                return {
                  'isCompromised': true,
                  'isDeveloperMode': false,
                  'isSecure': false,
                  'platform': Platform.isAndroid ? 'android' : 'ios',
                };
              default:
                throw PlatformException(code: 'NOT_IMPLEMENTED');
            }
          },
        );

        final isCompromised = await DeviceSecurityService.isDeviceCompromised();
        final securityResult =
            await DeviceSecurityService.performSecurityCheck();

        expect(isCompromised, isTrue);
        expect(securityResult['isCompromised'], isTrue);
        expect(securityResult['isSecure'], isFalse);
      });

      test('should handle developer mode detection', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('device_security_channel'),
          (MethodCall methodCall) async {
            switch (methodCall.method) {
              case 'isDeviceCompromised':
                return false;
              case 'isDeveloperModeEnabled':
                return true;
              case 'performSecurityCheck':
                return {
                  'isCompromised': false,
                  'isDeveloperMode': true,
                  'isSecure': false,
                  'platform': Platform.isAndroid ? 'android' : 'ios',
                };
              default:
                throw PlatformException(code: 'NOT_IMPLEMENTED');
            }
          },
        );

        final isDeveloperMode =
            await DeviceSecurityService.isDeveloperModeEnabled();
        final securityResult =
            await DeviceSecurityService.performSecurityCheck();

        expect(isDeveloperMode, isTrue);
        expect(securityResult['isDeveloperMode'], isTrue);
        expect(securityResult['isSecure'], isFalse);
      });

      test('should handle platform exceptions gracefully', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('device_security_channel'),
          (MethodCall methodCall) async {
            throw PlatformException(
              code: 'SECURITY_CHECK_ERROR',
              message: 'Security check failed',
            );
          },
        );

        final isCompromised = await DeviceSecurityService.isDeviceCompromised();
        final isDeveloperMode =
            await DeviceSecurityService.isDeveloperModeEnabled();
        final securityResult =
            await DeviceSecurityService.performSecurityCheck();

        // Should return safe defaults in case of error
        expect(isCompromised, isFalse);
        expect(isDeveloperMode, isFalse);
        expect(securityResult['isSecure'], isTrue);
        expect(securityResult['error'], isA<String>());
      });

      test('should handle unexpected exceptions gracefully', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('device_security_channel'),
          (MethodCall methodCall) async {
            throw Exception('Unexpected error');
          },
        );

        final isCompromised = await DeviceSecurityService.isDeviceCompromised();
        final isDeveloperMode =
            await DeviceSecurityService.isDeveloperModeEnabled();
        final securityResult =
            await DeviceSecurityService.performSecurityCheck();

        // Should return safe defaults in case of error
        expect(isCompromised, isFalse);
        expect(isDeveloperMode, isFalse);
        expect(securityResult['isSecure'], isTrue);
        expect(securityResult['error'], isA<String>());
      });
    });
  });
}
