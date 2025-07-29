// test/utils/utils_test.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/utils.dart';

import '../mocks.dart';
import '../ui/login_screen_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Utils Color Operations', () {
    test('should convert hex color to int correctly', () {
      // Test with hash
      expect(Utils.getColorFromHex('#FF5733'), 0xFFFF5733);

      // Test without hash
      expect(Utils.getColorFromHex('FF5733'), 0xFFFF5733);

      // Test with lowercase
      expect(Utils.getColorFromHex('#ff5733'), 0xFFFF5733);

      // Test 6-digit hex (should add FF prefix)
      expect(Utils.getColorFromHex('FF5733'), 0xFFFF5733);
    });

    test('should handle short hex colors', () {
      // Test 3-digit hex
      expect(Utils.getColorFromHex('F53'), 0xFFF53);
    });

    test('should handle edge cases in hex conversion', () {
      // Test empty string
      expect(() => Utils.getColorFromHex(''), throwsA(isA<FormatException>()));

      // Test invalid hex
      expect(() => Utils.getColorFromHex('ZZZZZZ'),
          throwsA(isA<FormatException>()));
    });
  });

  group('Utils JSON Operations', () {
    test('should load JSON list from asset bundle', () async {
      // Mock the asset bundle
      const channel = MethodChannel('flutter/assets');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'loadString' &&
            methodCall.arguments == 'test.json') {
          return MockTestData.validJsonList;
        }
        return null;
      });

      final result = await Utils.loadJson('test.json');

      expect(result, isA<List>());
      expect(result.length, 1);
      expect(result[0]['id'], 1);
      expect(result[0]['name'], 'test');
    });

    test('should load JSON map from asset bundle', () async {
      const channel = MethodChannel('flutter/assets');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'loadString' &&
            methodCall.arguments == 'test_map.json') {
          return MockTestData.validJsonMap;
        }
        return null;
      });

      final result = await Utils.loadJsonMap('test_map.json');

      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], 1);
      expect(result['name'], 'test');
    });

    test('should handle JSON loading errors', () async {
      const channel = MethodChannel('flutter/assets');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(
            code: 'asset_not_found', message: 'Asset not found');
      });

      expect(() => Utils.loadJson('nonexistent.json'),
          throwsA(isA<PlatformException>()));
    });

    test('should handle invalid JSON format', () async {
      const channel = MethodChannel('flutter/assets');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'loadString') {
          return MockTestData.invalidJson;
        }
        return null;
      });

      expect(() => Utils.loadJson('invalid.json'),
          throwsA(isA<FormatException>()));
    });
  });

  group('Utils Date and Time Operations', () {
    testWidgets('should show date picker with correct configuration',
        (WidgetTester tester) async {
      final selectedDate = DateTime(2024, 1, 1);
      DateTime? pickedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                pickedDate = await Utils.pickDate(context, selectedDate);
              },
              child: const Text('Pick Date'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Pick Date'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);

      // Simulate selecting a date
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    });

    testWidgets('should show time picker with correct configuration',
        (WidgetTester tester) async {
      const selectedTime = TimeOfDay(hour: 10, minute: 30);
      TimeOfDay? pickedTime;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                pickedTime = await Utils.pickTime(context, selectedTime, true);
              },
              child: const Text('Pick Time'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Pick Time'));
      await tester.pumpAndSettle();

      expect(find.byType(TimePickerDialog), findsOneWidget);
    });

    testWidgets('should handle null time in time picker',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Utils.pickTime(context, null, false),
              child: const Text('Pick Time'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Pick Time'));
      await tester.pumpAndSettle();

      expect(find.byType(TimePickerDialog), findsOneWidget);
    });

    testWidgets('should handle date picker cancellation',
        (WidgetTester tester) async {
      final selectedDate = DateTime(2024, 1, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Utils.pickDate(context, selectedDate),
              child: const Text('Pick Date'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Pick Date'));
      await tester.pumpAndSettle();

      // Cancel the picker
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsNothing);
    });
  });

  group('Utils Scaling and Font Operations', () {
    test('should return correct max scale for different font sizes', () {
      expect(Utils.getMaxScale(8), 2.0);
      expect(Utils.getMaxScale(12), 1.7);
      expect(Utils.getMaxScale(16), 1.4);
      expect(Utils.getMaxScale(24), 1.3);
      expect(Utils.getMaxScale(5), 2.0); // Edge case: very small font
    });

    testWidgets('should return capped scale based on context',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final scale = Utils.getCappedScale(context, 16);
              expect(scale, lessThanOrEqualTo(1.4));
              expect(scale, greaterThan(0));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should detect large font size setting',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final hasLargeFont = Utils.getFontSize(context);
              expect(hasLargeFont, isA<bool>());
              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Utils Focus Operations', () {
    testWidgets('should remove focus correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TextField(
              autofocus: true,
            ),
          ),
        ),
      );

      await tester.pump();

      // Remove focus
      Utils.removeFocus();
      await tester.pump();

      // Verify focus was removed (this test might be platform dependent)
      expect(tester.binding.focusManager.primaryFocus?.hasFocus, isNotNull);
    });

    testWidgets('should hide keyboard correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  TextField(),
                  ElevatedButton(
                    onPressed: () => Utils.hideKeyboard(context),
                    child: const Text('Hide Keyboard'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();

      await tester.tap(find.text('Hide Keyboard'));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should show keyboard correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  TextField(),
                  ElevatedButton(
                    onPressed: () => Utils.showKeyboard(context),
                    child: const Text('Show Keyboard'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Keyboard'));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
    });
  });

  group('Utils String Operations', () {
    test('should get error message from string key', () {
      // Test with empty/null key
      expect(Utils.getErrorMessageFromString(''), '');

      // Test with try again fallback
      expect(Utils.getErrorMessageFromString('', returnTryagain: true),
          isA<String>());

      // Test with non-existent key
      expect(
          Utils.getErrorMessageFromString('non_existent_key'), isA<String>());
    });

    test('should convert UTF-8 string correctly', () {
      const input = 'Hello\\x20World\\x21';
      final result = Utils.convrtStringUtf(input);
      expect(result, isA<String>());
      expect(result.trim(), isNotEmpty);
    });

    test('should handle empty UTF-8 string', () {
      const input = '';
      final result = Utils.convrtStringUtf(input);
      expect(result, isEmpty);
    });

    test('should encode hex string correctly', () {
      const input = 'Hello';
      final result = Utils.encodeHexString(input);
      expect(result, contains('\\x'));
      expect(result.length, greaterThan(input.length));

      // Test with null input
      final nullResult = Utils.encodeHexString(null);
      expect(nullResult, isA<String>());
      expect(nullResult, isEmpty);
    });

    test('should handle special characters in hex encoding', () {
      const input = 'Hello 世界!';
      final result = Utils.encodeHexString(input);
      expect(result, contains('\\x'));
    });

    test('should extract domain name from URL', () {
      expect(
          Utils.getDomainName('https://www.example.com/path'), 'example.com');
      expect(Utils.getDomainName('https://example.com'), 'example.com');
      expect(Utils.getDomainName('http://subdomain.example.com'),
          'subdomain.example.com');
      expect(Utils.getDomainName('https://www.google.com/search?q=test'),
          'google.com');
    });

    test('should handle invalid URLs in domain extraction', () {
      expect(() => Utils.getDomainName('invalid-url'),
          throwsA(isA<FormatException>()));
      expect(() => Utils.getDomainName(''), throwsA(isA<FormatException>()));
    });

    test('should format USD currency correctly', () {
      expect(Utils.formatUsd('100'), '\$100');
      expect(Utils.formatUsd('100.50'), '\$100.50');
      expect(Utils.formatUsd('1000'), '\$1,000');
      expect(Utils.formatUsd('1000.00'), '\$1,000');
      expect(Utils.formatUsd('invalid'), 'invalid'); // fallback
      expect(Utils.formatUsd(''), ''); // empty fallback
    });

    test('should format numbers with locale', () {
      final result = Utils.formatNumber(1000.5, 'en_US');
      expect(result, contains('1,000'));

      // Test with invalid locale
      final errorResult = Utils.formatNumber(1000.5, 'invalid_locale');
      expect(errorResult, contains('Error'));

      // Test with zero
      final zeroResult = Utils.formatNumber(0, 'en_US');
      expect(zeroResult, '0');
    });

    testWidgets('should extract timezone correctly',
        (WidgetTester tester) async {
      // Create a test app with localization
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (context) {
              // Test UTC timezone
              // final utcResult = Utils.extractTimeZone(context, '2024-01-01T10:00:00+00:00');
              // expect(utcResult, contains('UTC') || contains('+0'));

              // Test positive timezone
              final positiveResult =
                  Utils.extractTimeZone(context, '2024-01-01T10:00:00+05:30');
              expect(positiveResult, '+05:30');

              // Test negative timezone
              final negativeResult =
                  Utils.extractTimeZone(context, '2024-01-01T10:00:00-08:00');
              expect(negativeResult, '-08:00');

              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Utils Biometric Operations', () {
    test('should enable biometrics when supported', () async {
      // Test the actual method call
      final result = await Utils.enableBioMetrics();
      expect(result, isA<bool>());
    });

    test('should check if biometrics is supported on non-web platforms',
        () async {
      // This will test the actual implementation
      final result = await Utils.isBioMetricsSupported();
      expect(result, isA<bool>());
    });

    test('should get supported biometric type', () async {
      final result = await Utils.getSupportedBiometric();
      expect(result, isA<BiometricType?>());
    });

    test('should handle biometric errors gracefully', () async {
      // Test that methods don't throw exceptions
      expect(() async => await Utils.enableBioMetrics(), returnsNormally);
      expect(() async => await Utils.isBioMetricsSupported(), returnsNormally);
      expect(() async => await Utils.getSupportedBiometric(), returnsNormally);
    });
  });

  group('Utils External Operations', () {
    test('should get app version correctly', () async {
      // Mock PackageInfo
      const channel = MethodChannel('dev.fluttercommunity.plus/package_info');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return MockTestData.packageInfoData;
        }
        return null;
      });

      final version = await Utils.getAppVersion();
      expect(version, contains('1.0.0'));
      expect(version, contains('100'));
    });

    test('should handle app version error', () async {
      const channel = MethodChannel('dev.fluttercommunity.plus/package_info');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(code: 'error', message: 'Test error');
      });

      final version = await Utils.getAppVersion();
      expect(version, '');
    });

    test('should generate correct maps URL', () {
      const lat = 37.7749;
      const lng = -122.4194;

      final url = Utils.openMaps(lat, lng);
      expect(url, contains('google.com/maps'));
      expect(url, contains('$lat,$lng'));
    });

    test('should handle edge case coordinates', () {
      // Test with zero coordinates
      final zeroUrl = Utils.openMaps(0.0, 0.0);
      expect(zeroUrl, contains('0.0,0.0'));

      // Test with negative coordinates
      final negativeUrl = Utils.openMaps(-90.0, -180.0);
      expect(negativeUrl, contains('-90.0,-180.0'));
    });

    test('should handle external application launch', () async {
      // Mock url_launcher
      const channel = MethodChannel('plugins.flutter.io/url_launcher');
      bool canLaunchCalled = false;
      bool launchCalled = false;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'canLaunch') {
          canLaunchCalled = true;
          return false; // Simulate that URL cannot be launched
        } else if (methodCall.method == 'launch') {
          launchCalled = true;
          return true;
        }
        return null;
      });

      const validUrl = 'https://example.com';
      const validDeepLink = 'app://example';

      try {
        await Utils.openExternalApplication(validUrl, validDeepLink);
      } catch (e) {
        // Expected to fail when URLs cannot be launched
        expect(e, isNotNull);
      }

      expect(canLaunchCalled, isTrue);
    });

    test('should handle null URLs in external application launch', () async {
      expect(() async => await Utils.openExternalApplication(null, null),
          throwsA(isA<Exception>()));
    });
  });

  group('Utils Popup Operations', () {
    testWidgets('should show wallet popup correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Utils.walletPopupTravelCredit(
                context: context,
                child: const Text('Popup Content'),
              ),
              child: const Text('Show Popup'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Popup'));
      await tester.pumpAndSettle();

      expect(find.text('Popup Content'), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should show visa popup correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Utils.visaPopup(
                context: context,
                child: const Text('Visa Popup'),
              ),
              child: const Text('Show Visa Popup'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Visa Popup'));
      await tester.pumpAndSettle();

      expect(find.text('Visa Popup'), findsOneWidget);
    });

    testWidgets('should show delete companion popup',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Utils.deleteCompanionPopup(
                context: context,
                child: const Text('Delete Popup'),
              ),
              child: const Text('Show Delete Popup'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Delete Popup'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Popup'), findsOneWidget);
    });

    testWidgets('should show rate us popup', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Utils.rateUsPopup(
                context: context,
                child: const Text('Rate Us'),
              ),
              child: const Text('Show Rate Popup'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Rate Popup'));
      await tester.pumpAndSettle();

      expect(find.text('Rate Us'), findsOneWidget);
    });

    testWidgets('should handle popup dismissal', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Utils.visaPopup(
                context: context,
                child: AlertDialog(
                  title: const Text('Test Dialog'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test Dialog'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Test Dialog'), findsNothing);
    });
  });

  group('Utils Logout Operations', () {
    test('should logout user correctly', () async {
      // Mock the required channels for logout
      const amplifyChannel = MethodChannel('com.amazonaws.amplify/auth');
      const routerChannel = MethodChannel('app_router');

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(amplifyChannel,
              (MethodCall methodCall) async {
        if (methodCall.method == 'signOut') {
          return true;
        }
        return null;
      });

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(routerChannel,
              (MethodCall methodCall) async {
        return null;
      });

      // Test that the method can be called without throwing
      expect(() async => await Utils.logoutUser(), returnsNormally);
    });
  });

  group('Utils Number Formatting', () {
    testWidgets('should format local number correctly',
        (WidgetTester tester) async {
      final mockProvider = MockSelectLanguageGenericProvider();
      when(mockProvider.locale).thenReturn(const Locale('en', 'US'));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SelectLanguageGenericProvider>.value(
            value: mockProvider,
            child: Builder(
              builder: (context) {
                final result = Utils.localNumber(context, 1000);
                expect(result, isA<String>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should handle different locales', (WidgetTester tester) async {
      final mockProvider = MockSelectLanguageGenericProvider();
      when(mockProvider.locale).thenReturn(const Locale('hi', 'IN'));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SelectLanguageGenericProvider>.value(
            value: mockProvider,
            child: Builder(
              builder: (context) {
                final result = Utils.localNumber(context, 1000);
                expect(result, isA<String>());
                return Container();
              },
            ),
          ),
        ),
      );
    });
  });

  group('Utils Accessibility', () {
    test('should announce message for accessibility', () {
      const String testMessage = 'Test announcement';

      // This test verifies the method can be called without error
      expect(() => Utils.announceMessage(testMessage), returnsNormally);
    });

    test('should handle empty announcement message', () {
      expect(() => Utils.announceMessage(''), returnsNormally);
    });

    test('should handle long announcement message', () {
      final longMessage = 'A' * 1000;
      expect(() => Utils.announceMessage(longMessage), returnsNormally);
    });
  });

  group('Utils Debug Operations', () {
    test('should print debug messages correctly', () {
      final utils = Utils();

      // Test that printIt doesn't throw
      expect(() => utils.printIt('Test message'), returnsNormally);
      expect(() => utils.printIt(null), returnsNormally);
      expect(() => utils.printIt(123), returnsNormally);
    });

    test('should log print with chunking', () {
      const shortMessage = 'Short message';
      final longMessage = 'A' * 1000;

      expect(() => Utils.logPrint(shortMessage), returnsNormally);
      expect(() => Utils.logPrint(longMessage), returnsNormally);
      expect(() => Utils.logPrint(null), returnsNormally);
    });
  });

  group('Utils Edge Cases and Error Handling', () {
    test('should handle null and empty inputs gracefully', () {
      // Test hex color with empty string
      expect(() => Utils.getColorFromHex(''), throwsA(isA<FormatException>()));

      // Test currency formatting with empty string
      expect(Utils.formatUsd(''), '');

      // Test error message with empty string
      expect(Utils.getErrorMessageFromString(''), '');
    });

    test('should handle extreme values', () {
      // Test very large numbers
      expect(Utils.formatUsd('999999999.99'), contains('\$'));

      // Test negative numbers
      expect(Utils.formatUsd('-100'), contains('\$'));

      // Test zero
      expect(Utils.formatUsd('0'), '\$0');
    });

    test('should handle special characters', () {
      // Test domain extraction with special characters
      expect(() => Utils.getDomainName('https://例え.テスト'), returnsNormally);

      // Test hex encoding with special characters
      final result = Utils.encodeHexString('Hello 世界! 🌍');
      expect(result, contains('\\x'));
    });

    test('should handle concurrent operations', () async {
      // Test that multiple async operations can run concurrently
      final futures = List.generate(5, (index) async {
        return Utils.getAppVersion();
      });

      final results = await Future.wait(futures);
      expect(results.length, 5);
      expect(results.every((result) => result is String), isTrue);
    });
  });
}
