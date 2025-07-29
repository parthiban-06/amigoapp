import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:visaamigo/analytics/firebase_analytics_servicerAnalyticsId = "";
      FirebaseAnalyticsService.nonInteraction = true;
      FirebaseAnalyticsService.userLanguage = "en";
      FirebaseAnalyticsService.packageInfo = null;
      FirebaseAnalyticsService.androidInfo = null;
      FirebaseAnalyticsService.iosInfo = null;
    });

    group('Device Analytics Info Tests', () {
      test('should return device info with user analytics ID', () {
        // Arrange
        FirebaseAnalyticsService.userAnalyticsId = 'user123';
        final info = <String, Object>{};

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['user_id'], 'user123');
        expect(result['user_authenticated_state'], 'authenticated');
        expect(result['user_state'], 'registered');
        expect(result['language'], 'en');
        expect(result['language_code'], 'en-IN');
        expect(result['nonInteraction'], '1');
        expect(result['uiInteraction'], '0');
        expect(result['timestamp'], isNotNull);
        expect(result['reffered_from'], 'email');
        expect(result['screen_resolution'], isNotNull);
      });

      test('should return device info for anonymous user', () {
        // Arrange
        FirebaseAnalyticsService.userAnalyticsId = '';
        final info = <String, Object>{};

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['user_authenticated_state'], 'non authenticated');
        expect(result['user_state'], 'anonymous');
      });

      test('should return device info with different language', () {
        // Arrange
        FirebaseAnalyticsService.userLanguage = 'fr';
        final info = <String, Object>{};

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['language'], 'fr');
        expect(result['language_code'], 'fr-CA');
      });

      test('should return device info with non-interaction flag false', () {
        // Arrange
        FirebaseAnalyticsService.nonInteraction = false;
        final info = <String, Object>{};

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['nonInteraction'], '0');
        expect(result['uiInteraction'], '1');
      });

      test('should handle null info parameter', () {
        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(null);

        // Assert
        expect(result, isNotNull);
        expect(result['language'], 'en');
        expect(result['language_code'], 'en-IN');
      });

      test('should handle empty info parameter', () {
        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

        // Assert
        expect(result, isNotNull);
        expect(result['language'], 'en');
        expect(result['language_code'], 'en-IN');
      });

      test('should handle unknown language code', () {
        // Arrange
        FirebaseAnalyticsService.userLanguage = 'unknown';
        final info = <String, Object>{};

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['language'], 'unknown');
        expect(result['language_code'], 'en-IN'); // Default fallback
      });

      test('should handle very long user analytics ID', () {
        // Arrange
        final longId = 'a' * 10000;
        FirebaseAnalyticsService.userAnalyticsId = longId;
        final info = <String, Object>{};

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['user_id'], longId);
        expect(result['user_authenticated_state'], 'authenticated');
        expect(result['user_state'], 'registered');
      });

      test('should handle very long language codes', () {
        // Arrange
        FirebaseAnalyticsService.userLanguage = 'a' * 100;
        final info = <String, Object>{};

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['language'], 'a' * 100);
        expect(result['language_code'], 'en-IN'); // Default fallback
      });
    });

    group('Language Region Map Tests', () {
      test('should have correct language region mappings', () {
        final expectedMappings = {
          'en': 'en-IN',
          'fr': 'fr-CA',
          'es': 'es-MX',
          'ar': 'ar-SA',
          'de': 'de-DE',
          'ja': 'ja-JP',
          'ko': 'ko-KR',
          'pt': 'pt-BR',
          'zh': 'zh-CN',
        };

        for (final entry in expectedMappings.entries) {
          expect(
            FirebaseAnalyticsService.languageRegionMap[entry.key],
            entry.value,
            reason: 'Language ${entry.key} should map to ${entry.value}',
          );
        }
      });

      test('should handle case-insensitive language lookup', () {
        // Arrange
        FirebaseAnalyticsService.userLanguage = 'FR';
        final info = <String, Object>{};

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['language'], 'FR');
        expect(result['language_code'], 'fr-CA');
      });

      test('should handle empty language region map', () {
        // Arrange
        final originalMap = Map<String, String>.from(
            FirebaseAnalyticsService.languageRegionMap);
        FirebaseAnalyticsService.languageRegionMap.clear();

        // Act
        final info = <String, Object>{};
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['language'], 'en');
        expect(result['language_code'], 'en-IN'); // Should still have default

        // Cleanup
        FirebaseAnalyticsService.languageRegionMap = originalMap;
      });
    });

    group('Route Change Tests', () {
      test('should handle route change with null route', () {
        // Arrange
        final service = FirebaseAnalyticsService();

        // Act & Assert
        expect(
          () => service.onRouteChanged(''),
          returnsNormally,
        );
      });

      test('should handle route change with whitespace route', () {
        // Arrange
        final service = FirebaseAnalyticsService();

        // Act & Assert
        expect(
          () => service.onRouteChanged('   '),
          returnsNormally,
        );
      });

      test('should handle route change with special characters', () {
        // Arrange
        final service = FirebaseAnalyticsService();

        // Act & Assert
        expect(
          () => service.onRouteChanged('/route-with-special-chars!@#'),
          returnsNormally,
        );
      });

      test('should handle route change with very long route', () {
        // Arrange
        final service = FirebaseAnalyticsService();
        final longRoute = '/${'a' * 1000}';

        // Act & Assert
        expect(
          () => service.onRouteChanged(longRoute),
          returnsNormally,
        );
      });

      test('should handle route change with query parameters', () {
        // Arrange
        final service = FirebaseAnalyticsService();

        // Act & Assert
        expect(
          () => service.onRouteChanged('/search?q=test&page=1'),
          returnsNormally,
        );
      });

      test('should handle route change with fragments', () {
        // Arrange
        final service = FirebaseAnalyticsService();

        // Act & Assert
        expect(
          () => service.onRouteChanged('/profile#settings'),
          returnsNormally,
        );
      });

      test('should handle route change with multiple slashes', () {
        // Arrange
        final service = FirebaseAnalyticsService();

        // Act & Assert
        expect(
          () => service.onRouteChanged('///deep/nested///route///'),
          returnsNormally,
        );
      });

      test('should handle route change with only slashes', () {
        // Arrange
        final service = FirebaseAnalyticsService();

        // Act & Assert
        expect(
          () => service.onRouteChanged('///'),
          returnsNormally,
        );
      });

      test('should handle route change with only special characters', () {
        // Arrange
        final service = FirebaseAnalyticsService();

        // Act & Assert
        expect(
          () => service.onRouteChanged('/!@#\$%^&*()'),
          returnsNormally,
        );
      });
    });

    group('Analytics Constants Tests', () {
      test('should have all required event name constants', () {
        expect(AnalyticsEventConst.EVENT_NAME_APP_OPEN, 'app_opened');
        expect(AnalyticsEventConst.EVENT_NAME_EXIT_SCREENVIEWED,
            'exit_screenviewed');
        expect(AnalyticsEventConst.EVENT_NAME_SCREEN_VIEW, 'app_screen_view');
        expect(AnalyticsEventConst.EVENT_NAME_UI_INTERACTION, 'ui_interaction');
        expect(AnalyticsEventConst.EVENT_NAME_HOME_ITINERARY, 'home_Itinerary');
        expect(AnalyticsEventConst.EVENT_NAME_WALLET_CLICKED, 'wallet_clicked');
        expect(AnalyticsEventConst.EVENT_NAME_EVAASSISTANT_OPENED,
            'evaassistant_opened');
        expect(AnalyticsEventConst.EVENT_NAME_EVAASSISTANT_SEARCHINITIATE,
            'evaassistant_searchinitiate');
        expect(AnalyticsEventConst.EVENT_NAME_EVAASSISTANT_SCREENVIEWED,
            'evaassistant_screenviewed');
        expect(AnalyticsEventConst.EVENT_NAME_ADD_ITINERARY,
            'itineraryCreation_addNewEventButton');
        expect(AnalyticsEventConst.EVENT_NAME_RESGITRATION_FORM_START,
            'registration_form_start');
        expect(AnalyticsEventConst.EVENT_NAME_RESGITRATION_FORM_SUBMIT,
            'registration_form_submit');
        expect(AnalyticsEventConst.EVENT_NAME_RESGITRATION_SUCCESS,
            'registration_success');
        expect(AnalyticsEventConst.EVENT_NAME_EMAIL_AUTH_SCREEN,
            'email_auth_screen');
        expect(AnalyticsEventConst.EVENT_NAME_DYNAMIC_LINK_OPENED,
            'dynamiclink_app_opened');
        expect(AnalyticsEventConst.EVENT_NAME_EMAIL_AUTH_ERROR,
            'email_auth_error');
        expect(AnalyticsEventConst.EVENT_NAME_EMAIL_AUTH_SUCCESS,
            'email_auth_success');
        expect(AnalyticsEventConst.EVENT_NAME_OTP_SCREENVIEW, 'otp_screenview');
        expect(AnalyticsEventConst.EVENT_NAME_OTP_VERIFICATIONERROR,
            'otp_verificationerror');
        expect(AnalyticsEventConst.EVENT_NAME_OTP_VERIFICATIONSUCCESS,
            'otp_verificationsuccess');
        expect(AnalyticsEventConst.EVENT_NAME_COMPANION_FORM_ERROR,
            'companionDetails_formerror');
        expect(AnalyticsEventConst.EVENT_NAME_EDIT_COMPANION_FORM_ERROR,
            'editCompanion_formError');
      });

      test('should have all required parameter name constants', () {
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT, 'ui_element');
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION,
            'ui_element_location');
        expect(AnalyticsEventConst.PARAM_NAME_TILE_NAME, 'tile_name');
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LABEL,
            'ui_element_label');
        expect(AnalyticsEventConst.PARAM_NAME_SOURCE_SCREEN, 'source_screen');
      });

      test('should have all required form constants', () {
        expect(
            AnalyticsEventConst.FORM_ID_RESGITRATION, 'form_registration_01');
        expect(AnalyticsEventConst.FORM_NAME_RESGITRATION, 'registration_page');
      });

      test('should have all required authentication constants', () {
        expect(AnalyticsEventConst.ANALYTICS_AUTHENTICATED, 'authenticated');
        expect(AnalyticsEventConst.ANALYTICS_NON_AUTHENTICATED,
            'non_authenticated');
      });
    });

    group('Static Variable Management Tests', () {
      test('should handle static variable modifications', () {
        // Arrange
        final originalUserId = FirebaseAnalyticsService.userAnalyticsId;
        final originalLanguage = FirebaseAnalyticsService.userLanguage;

        // Act
        FirebaseAnalyticsService.userAnalyticsId = 'test_user';
        FirebaseAnalyticsService.userLanguage = 'fr';

        // Assert
        expect(FirebaseAnalyticsService.userAnalyticsId, 'test_user');
        expect(FirebaseAnalyticsService.userLanguage, 'fr');

        // Cleanup
        FirebaseAnalyticsService.userAnalyticsId = originalUserId;
        FirebaseAnalyticsService.userLanguage = originalLanguage;
      });

      test('should handle device category modifications', () {
        // Arrange
        final originalCategory = FirebaseAnalyticsService.device_category;

        // Act
        FirebaseAnalyticsService.device_category = 'tablet';

        // Assert
        expect(FirebaseAnalyticsService.device_category, 'tablet');

        // Cleanup
        FirebaseAnalyticsService.device_category = originalCategory;
      });

      test('should handle nonInteraction flag modifications', () {
        // Arrange
        final originalFlag = FirebaseAnalyticsService.nonInteraction;

        // Act
        FirebaseAnalyticsService.nonInteraction = false;

        // Assert
        expect(FirebaseAnalyticsService.nonInteraction, false);

        // Cleanup
        FirebaseAnalyticsService.nonInteraction = originalFlag;
      });

      test('should handle previousPage modifications', () {
        // Arrange
        final originalPage = FirebaseAnalyticsService.previousPage;

        // Act
        FirebaseAnalyticsService.previousPage = '/test_page';

        // Assert
        expect(FirebaseAnalyticsService.previousPage, '/test_page');

        // Cleanup
        FirebaseAnalyticsService.previousPage = originalPage;
      });

      test('should handle genericUiElement modifications', () {
        // Arrange
        final originalElement = FirebaseAnalyticsService.genericUiElement;

        // Act
        FirebaseAnalyticsService.genericUiElement = 'test_element';

        // Assert
        expect(FirebaseAnalyticsService.genericUiElement, 'test_element');

        // Cleanup
        FirebaseAnalyticsService.genericUiElement = originalElement;
      });
    });

    group('Integration Tests', () {
      test('should handle complete device info generation', () {
        // Arrange
        FirebaseAnalyticsService.userAnalyticsId = 'user123';
        FirebaseAnalyticsService.userLanguage = 'en';
        FirebaseAnalyticsService.nonInteraction = true;

        // Act
        final info = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

        // Assert
        expect(info['user_id'], 'user123');
        expect(info['language'], 'en');
        expect(info['language_code'], 'en-IN');
        expect(info['nonInteraction'], '1');
        expect(info['uiInteraction'], '0');
        expect(info['timestamp'], isNotNull);
        expect(info['reffered_from'], 'email');
      });

      test('should handle device info with all optional parameters', () {
        // Arrange
        FirebaseAnalyticsService.userAnalyticsId = 'user456';
        FirebaseAnalyticsService.userLanguage = 'fr';

        // Act
        final info = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

        // Assert
        expect(info['user_id'], 'user456');
        expect(info['language'], 'fr');
        expect(info['language_code'], 'fr-CA');
      });

      test('should handle multiple language changes', () {
        // Test multiple languages
        final languages = ['en', 'fr', 'es', 'de', 'ja'];
        for (final lang in languages) {
          // Arrange
          FirebaseAnalyticsService.userLanguage = lang;

          // Act
          final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

          // Assert
          expect(result['language'], lang);
        }
      });

      test('should handle rapid state changes', () {
        // Arrange
        final service = FirebaseAnalyticsService();

        // Act & Assert - Test rapid route changes
        for (int i = 0; i < 10; i++) {
          expect(
            () => service.onRouteChanged('/route_$i'),
            returnsNormally,
          );
        }
      });
    });

    group('Coverage Enhancement Tests', () {
      test('should test all language region map entries', () {
        // Test all supported languages
        final supportedLanguages =
            FirebaseAnalyticsService.languageRegionMap.keys.toList();

        for (final language in supportedLanguages) {
          // Arrange
          FirebaseAnalyticsService.userLanguage = language;

          // Act
          final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

          // Assert
          expect(result['language'], language);
          expect(result['language_code'],
              FirebaseAnalyticsService.languageRegionMap[language]);
        }
      });

      test('should test all interaction flag combinations', () {
        // Test both true and false values
        final testValues = [true, false];

        for (final value in testValues) {
          // Arrange
          FirebaseAnalyticsService.nonInteraction = value;

          // Act
          final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

          // Assert
          expect(result['nonInteraction'], value ? '1' : '0');
          expect(result['uiInteraction'], value ? '0' : '1');
        }
      });

      test('should test all authentication states', () {
        // Test authenticated and anonymous states
        final testStates = ['', 'user123', 'another_user'];

        for (final userId in testStates) {
          // Arrange
          FirebaseAnalyticsService.userAnalyticsId = userId;

          // Act
          final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

          // Assert
          if (userId.isNotEmpty) {
            expect(result['user_id'], userId);
            expect(result['user_authenticated_state'], 'authenticated');
            expect(result['user_state'], 'registered');
          } else {
            expect(result['user_authenticated_state'], 'non authenticated');
            expect(result['user_state'], 'anonymous');
          }
        }
      });

      test('should test all supported languages with device info', () {
        // Test all supported languages
        final supportedLanguages = [
          'en',
          'fr',
          'es',
          'ar',
          'de',
          'ja',
          'ko',
          'pt',
          'zh'
        ];

        for (final language in supportedLanguages) {
          // Arrange
          FirebaseAnalyticsService.userLanguage = language;

          // Act
          final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

          // Assert
          expect(result['language'], language);
          expect(result['language_code'], isNotNull);
        }
      });

      test('should test edge cases for user analytics ID', () {
        // Test various user ID scenarios
        final testIds = [
          '',
          'user123',
          'a' * 1000,
          'user-with-special-chars!@#'
        ];

        for (final userId in testIds) {
          // Arrange
          FirebaseAnalyticsService.userAnalyticsId = userId;

          // Act
          final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

          // Assert
          if (userId.isNotEmpty) {
            expect(result['user_id'], userId);
            expect(result['user_authenticated_state'], 'authenticated');
            expect(result['user_state'], 'registered');
          } else {
            expect(result['user_authenticated_state'], 'non authenticated');
            expect(result['user_state'], 'anonymous');
          }
        }
      });

      test('should test edge cases for language codes', () {
        // Test various language scenarios
        final testLanguages = ['en', 'FR', 'unknown', 'a' * 100, ''];

        for (final language in testLanguages) {
          // Arrange
          FirebaseAnalyticsService.userLanguage = language;

          // Act
          final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

          // Assert
          expect(result['language'], language);
          expect(result['language_code'], isNotNull);
        }
      });

      test('should test multiple device info calls with different states', () {
        // Test multiple calls with different states
        for (int i = 0; i < 5; i++) {
          // Arrange
          FirebaseAnalyticsService.userAnalyticsId = 'user$i';
          FirebaseAnalyticsService.userLanguage = i % 2 == 0 ? 'en' : 'fr';
          FirebaseAnalyticsService.nonInteraction = i % 2 == 0;

          // Act
          final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

          // Assert
          expect(result['user_id'], 'user$i');
          expect(result['language'], i % 2 == 0 ? 'en' : 'fr');
          expect(result['nonInteraction'], i % 2 == 0 ? '1' : '0');
        }
      });
    });

    group('Error Handling Tests', () {
      test('should handle exceptions in getDeviceAnalyticsInfo gracefully', () {
        // Arrange
        final info = <String, Object>{};

        // Force an exception by setting invalid values
        FirebaseAnalyticsService.packageInfo = null;
        FirebaseAnalyticsService.androidInfo = null;
        FirebaseAnalyticsService.iosInfo = null;

        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.getDeviceAnalyticsInfo(info),
          returnsNormally,
        );
      });

      test('should handle null info parameter in getDeviceAnalyticsInfo', () {
        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.getDeviceAnalyticsInfo(null),
          returnsNormally,
        );
      });

      test('should handle empty info parameter in getDeviceAnalyticsInfo', () {
        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.getDeviceAnalyticsInfo({}),
          returnsNormally,
        );
      });
    });
  });
}
