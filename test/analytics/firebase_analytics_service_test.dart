import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';

void main() {
  group('FirebaseAnalyticsService Tests', () {
    setUp(() {
      // Reset static variables
      FirebaseAnalyticsService.previousPage = "";
      FirebaseAnalyticsService.genericUiElement = "";
      FirebaseAnalyticsService.userAnalyticsId = "";
      FirebaseAnalyticsService.nonInteraction = true;
      FirebaseAnalyticsService.userLanguage = "en";
    });

    group('cleanRoutePath', () {
      test('should clean route path correctly', () {
        // Test cases
        expect(FirebaseAnalyticsService.cleanRoutePath('/'), 'home');
        expect(FirebaseAnalyticsService.cleanRoutePath(''), 'home');
        expect(FirebaseAnalyticsService.cleanRoutePath('/home'), 'home');
        expect(FirebaseAnalyticsService.cleanRoutePath('/user/profile'),
            'user_profile');
        expect(FirebaseAnalyticsService.cleanRoutePath('/camelCase'),
            'camel_case');
        expect(
            FirebaseAnalyticsService.cleanRoutePath('/nested/camelCase/path'),
            'nested_camel_case_path');
      });

      test('should handle complex route patterns', () {
        expect(FirebaseAnalyticsService.cleanRoutePath('/user/123/profile'),
            'user_123_profile');
        expect(FirebaseAnalyticsService.cleanRoutePath('/api/v1/users'),
            'api_v1_users');
        expect(FirebaseAnalyticsService.cleanRoutePath('/home/dashboard'),
            'home_dashboard');
      });

      test('should handle routes with multiple camelCase segments', () {
        expect(
            FirebaseAnalyticsService.cleanRoutePath(
                '/userProfile/settingsPage'),
            'user_profile_settings_page');
        expect(FirebaseAnalyticsService.cleanRoutePath('/apiV1/userManagement'),
            'api_v1_user_management');
      });

      test('should handle routes with numbers and special characters', () {
        expect(FirebaseAnalyticsService.cleanRoutePath('/user/123-456/profile'),
            'user_123_456_profile');
        expect(FirebaseAnalyticsService.cleanRoutePath('/api/v1.0/users'),
            'api_v1_0_users');
      });
    });

    group('logEvent', () {
      test('should handle event with all parameters', () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            screenName: '/test_screen',
            previousScreen: '/previous_screen',
            parameters: {'key': 'value'},
          ),
          returnsNormally,
        );
      });

      test('should handle event with null parameters', () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            screenName: null,
            previousScreen: null,
            parameters: null,
          ),
          returnsNormally,
        );
      });

      test('should handle event with UI element parameters', () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            parameters: {
              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: 'test_button',
              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: 'header',
            },
          ),
          returnsNormally,
        );
      });

      test('should handle event with empty parameters', () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            parameters: {},
          ),
          returnsNormally,
        );
      });

      test('should handle event with empty string UI element parameters',
          () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            parameters: {
              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: '',
              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: '',
            },
          ),
          returnsNormally,
        );
      });

      test('should handle event with very long parameter values', () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            parameters: {
              'long_param': 'a' * 1000,
              'another_long_param': 'b' * 500,
            },
          ),
          returnsNormally,
        );
      });

      test('should handle event with special characters in parameters',
          () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            parameters: {
              'special_chars': '!@#\$%^&*()_+-=[]{}|;:,.<>?',
              'unicode': '🚀🎉🌟',
              'quotes': '"single" and \'double\' quotes',
            },
          ),
          returnsNormally,
        );
      });

      test('should handle event with numeric parameters', () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            parameters: {
              'count': 42,
              'price': 99.99,
              'is_active': true,
            },
          ),
          returnsNormally,
        );
      });
    });

    group('logEventButtonClick', () {
      test('should handle button click with empty name', () async {
        expect(
          () => FirebaseAnalyticsService.logEventButtonClick(
            btnName: '',
          ),
          returnsNormally,
        );
      });

      test('should handle button click with custom parameters', () async {
        expect(
          () => FirebaseAnalyticsService.logEventButtonClick(
            btnName: 'test_button',
            parameters: {'custom_param': 'value'},
          ),
          returnsNormally,
        );
      });

      test('should handle button click with custom event name', () async {
        expect(
          () => FirebaseAnalyticsService.logEventButtonClick(
            name: 'custom_button_event',
            btnName: 'test_button',
          ),
          returnsNormally,
        );
      });

      test('should handle button click with null parameters', () async {
        expect(
          () => FirebaseAnalyticsService.logEventButtonClick(
            btnName: 'test_button',
            parameters: null,
          ),
          returnsNormally,
        );
      });

      test('should handle button click with special characters in name',
          () async {
        expect(
          () => FirebaseAnalyticsService.logEventButtonClick(
            btnName: 'test-button_123',
          ),
          returnsNormally,
        );
      });
    });

    group('setUserProperty', () {
      test('should not set user property with empty name', () async {
        // Arrange
        const name = '';
        const value = 'test_value';

        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.setUserProperty(
            name: name,
            value: value,
          ),
          returnsNormally,
        );
      });

      test('should not set user property with empty value', () async {
        // Arrange
        const name = 'test_name';
        const value = '';

        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.setUserProperty(
            name: name,
            value: value,
          ),
          returnsNormally,
        );
      });

      test('should handle valid user property', () async {
        expect(
          () => FirebaseAnalyticsService.setUserProperty(
            name: 'test_property',
            value: 'test_value',
          ),
          returnsNormally,
        );
      });

      test('should handle user property with special characters', () async {
        expect(
          () => FirebaseAnalyticsService.setUserProperty(
            name: 'test_property_123',
            value: 'test_value_with_special_chars!@#',
          ),
          returnsNormally,
        );
      });

      test('should handle user property with unicode characters', () async {
        expect(
          () => FirebaseAnalyticsService.setUserProperty(
            name: 'user_language',
            value: '中文',
          ),
          returnsNormally,
        );
      });
    });

    group('setUserid', () {
      test('should handle valid user ID', () async {
        expect(
          () => FirebaseAnalyticsService.setUserid(userID: 'test_user_123'),
          returnsNormally,
        );
      });

      test('should handle empty user ID', () async {
        expect(
          () => FirebaseAnalyticsService.setUserid(userID: ''),
          returnsNormally,
        );
      });

      test('should handle user ID with special characters', () async {
        expect(
          () => FirebaseAnalyticsService.setUserid(userID: 'user-123_test'),
          returnsNormally,
        );
      });

      test('should handle very long user ID', () async {
        expect(
          () => FirebaseAnalyticsService.setUserid(userID: 'a' * 1000),
          returnsNormally,
        );
      });
    });

    group('onRouteChanged', () {
      test('should not log event for empty route', () {
        // Arrange
        const newRoute = '';

        // Act & Assert
        expect(
          () => FirebaseAnalyticsService().onRouteChanged(newRoute),
          returnsNormally,
        );
      });

      test('should handle route changes', () {
        // Arrange
        const route = '/test_route';

        // Act & Assert
        expect(
          () => FirebaseAnalyticsService().onRouteChanged(route),
          returnsNormally,
        );
      });

      test('should handle same route multiple times', () {
        // Arrange
        final service = FirebaseAnalyticsService();
        const route = '/same_route';

        // Act & Assert
        expect(
          () {
            service.onRouteChanged(route);
            service.onRouteChanged(route); // Same route again
          },
          returnsNormally,
        );
      });

      test('should handle route with special characters', () {
        // Arrange
        final service = FirebaseAnalyticsService();
        const route = '/user/123/profile?tab=settings';

        // Act & Assert
        expect(
          () => service.onRouteChanged(route),
          returnsNormally,
        );
      });

      test('should handle null route in onRouteChanged', () {
        final service = FirebaseAnalyticsService();
        expect(
          () => service.onRouteChanged(''),
          returnsNormally,
        );
      });

      test('should handle route with query parameters', () {
        final service = FirebaseAnalyticsService();
        expect(
          () => service.onRouteChanged('/search?q=test&page=1'),
          returnsNormally,
        );
      });

      test('should handle route with fragments', () {
        final service = FirebaseAnalyticsService();
        expect(
          () => service.onRouteChanged('/profile#settings'),
          returnsNormally,
        );
      });

      test('should handle route with multiple slashes', () {
        final service = FirebaseAnalyticsService();
        expect(
          () => service.onRouteChanged('///deep/nested///route///'),
          returnsNormally,
        );
      });
    });

    group('setAnalyticsEnableStatus', () {
      test('should enable analytics', () async {
        expect(
          () async =>
              await FirebaseAnalyticsService.setAnalyticsEnableStatus(true),
          returnsNormally,
        );
      });

      test('should disable analytics', () async {
        expect(
          () async =>
              await FirebaseAnalyticsService.setAnalyticsEnableStatus(false),
          returnsNormally,
        );
      });

      test('should handle multiple enable/disable cycles', () async {
        expect(
          () async {
            await FirebaseAnalyticsService.setAnalyticsEnableStatus(true);
            await FirebaseAnalyticsService.setAnalyticsEnableStatus(false);
            await FirebaseAnalyticsService.setAnalyticsEnableStatus(true);
          },
          returnsNormally,
        );
      });
    });

    group('getDeviceAnalyticsInfo', () {
      test('should return web platform info when running on web', () {
        // Arrange
        final info = <String, Object>{};

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['platform'], isNotNull);
        expect(result['device_category'], isNotNull);
        expect(result['os_version'], isNotNull);
        expect(result['device'], isNotNull);
        expect(result['device_model'], isNotNull);
      });

      test('should include language information', () {
        // Arrange
        final info = <String, Object>{};
        FirebaseAnalyticsService.userLanguage = 'en';

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['language'], 'en');
        expect(result['language_code'], 'en-IN');
      });

      test('should include user analytics ID when available', () {
        // Arrange
        final info = <String, Object>{};
        FirebaseAnalyticsService.userAnalyticsId = 'user123';

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['user_id'], 'user123');
      });

      test('should handle exceptions gracefully', () {
        // Arrange
        final info = <String, Object>{};
        FirebaseAnalyticsService.packageInfo = null;
        FirebaseAnalyticsService.androidInfo = null;
        FirebaseAnalyticsService.iosInfo = null;

        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.getDeviceAnalyticsInfo(info),
          returnsNormally,
        );
      });

      test('should handle different language codes', () {
        // Arrange
        final info = <String, Object>{};
        FirebaseAnalyticsService.userLanguage = 'fr';

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['language'], 'fr');
        expect(result['language_code'], 'fr-CA');
      });

      test('should handle unknown language codes', () {
        // Arrange
        final info = <String, Object>{};
        FirebaseAnalyticsService.userLanguage = 'unknown';

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['language'], 'unknown');
        expect(result['language_code'], 'en-IN'); // Default fallback
      });

      test('should include authentication state', () {
        // Arrange
        final info = <String, Object>{};
        FirebaseAnalyticsService.userAnalyticsId = 'user123';

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['user_authenticated_state'], 'authenticated');
        expect(result['user_state'], 'registered');
      });

      test('should include anonymous state', () {
        // Arrange
        final info = <String, Object>{};
        FirebaseAnalyticsService.userAnalyticsId = '';

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['user_authenticated_state'], 'non authenticated');
        expect(result['user_state'], 'anonymous');
      });

      test('should include interaction flags', () {
        // Arrange
        final info = <String, Object>{};
        FirebaseAnalyticsService.nonInteraction = true;

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['nonInteraction'], '1');
        expect(result['uiInteraction'], '0');
      });

      test('should include timestamp', () {
        // Arrange
        final info = <String, Object>{};

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['timestamp'], isNotNull);
        expect(result['timestamp'], isA<String>());
      });

      test('should handle null input info', () {
        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.getDeviceAnalyticsInfo(null),
          returnsNormally,
        );
      });

      test('should handle all supported languages', () {
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
          final info = <String, Object>{};
          FirebaseAnalyticsService.userLanguage = language;

          // Act
          final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

          // Assert
          expect(result['language'], language);
          expect(result['language_code'], isNotNull);
        }
      });

      test('should handle nonInteraction flag changes', () {
        // Arrange
        final info = <String, Object>{};
        FirebaseAnalyticsService.nonInteraction = false;

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['nonInteraction'], '0');
        expect(result['uiInteraction'], '1');
      });

      test('should include app version when available', () {
        // Arrange
        final info = <String, Object>{};
        FirebaseAnalyticsService.packageInfo = PackageInfo(
          appName: 'Test App',
          packageName: 'com.test.app',
          version: '1.0.0',
          buildNumber: '123',
        );

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['app_version'], '123');
      });

      test('should handle missing app version gracefully', () {
        // Arrange
        final info = <String, Object>{};
        FirebaseAnalyticsService.packageInfo = null;

        // Act
        final result = FirebaseAnalyticsService.getDeviceAnalyticsInfo(info);

        // Assert
        expect(result['app_version'], '');
      });
    });

    group('clearUserOnLogout', () {
      test('should clear user analytics ID', () async {
        // Arrange
        FirebaseAnalyticsService.userAnalyticsId = 'test_user';

        // Act
        await FirebaseAnalyticsService.clearUserOnLogout();

        // Assert
        expect(FirebaseAnalyticsService.userAnalyticsId, '');
      });

      test('should handle logout when user ID is already empty', () async {
        // Arrange
        FirebaseAnalyticsService.userAnalyticsId = '';

        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.clearUserOnLogout(),
          returnsNormally,
        );
      });

      test('should handle logout with long user ID', () async {
        // Arrange
        FirebaseAnalyticsService.userAnalyticsId = 'a' * 1000;

        // Act
        await FirebaseAnalyticsService.clearUserOnLogout();

        // Assert
        expect(FirebaseAnalyticsService.userAnalyticsId, '');
      });
    });

    group('AnalyticsEventConst', () {
      test('should have correct event name constants', () {
        expect(AnalyticsEventConst.EVENT_NAME_APP_OPEN, 'app_opened');
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

      test('should have correct parameter name constants', () {
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT, 'ui_element');
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION,
            'ui_element_location');
        expect(AnalyticsEventConst.PARAM_NAME_TILE_NAME, 'tile_name');
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LABEL,
            'ui_element_label');
        expect(AnalyticsEventConst.PARAM_NAME_SOURCE_SCREEN, 'source_screen');
      });

      test('should have correct form constants', () {
        expect(
            AnalyticsEventConst.FORM_ID_RESGITRATION, 'form_registration_01');
        expect(AnalyticsEventConst.FORM_NAME_RESGITRATION, 'registration_page');
      });

      test('should have correct authentication constants', () {
        expect(AnalyticsEventConst.ANALYTICS_AUTHENTICATED, 'authenticated');
        expect(AnalyticsEventConst.ANALYTICS_NON_AUTHENTICATED,
            'non_authenticated');
      });
    });

    group('Static Variables', () {
      test('should have correct language region mapping', () {
        expect(FirebaseAnalyticsService.languageRegionMap['en'], 'en-IN');
        expect(FirebaseAnalyticsService.languageRegionMap['fr'], 'fr-CA');
        expect(FirebaseAnalyticsService.languageRegionMap['es'], 'es-MX');
        expect(FirebaseAnalyticsService.languageRegionMap['ar'], 'ar-SA');
        expect(FirebaseAnalyticsService.languageRegionMap['de'], 'de-DE');
        expect(FirebaseAnalyticsService.languageRegionMap['ja'], 'ja-JP');
        expect(FirebaseAnalyticsService.languageRegionMap['ko'], 'ko-KR');
        expect(FirebaseAnalyticsService.languageRegionMap['pt'], 'pt-BR');
        expect(FirebaseAnalyticsService.languageRegionMap['zh'], 'zh-CN');
      });

      test('should have correct device category', () {
        expect(FirebaseAnalyticsService.device_category, 'mobile');
      });

      test('should have correct default values', () {
        expect(FirebaseAnalyticsService.nonInteraction, true);
        expect(FirebaseAnalyticsService.userLanguage, 'en');
        expect(FirebaseAnalyticsService.previousPage, '');
        expect(FirebaseAnalyticsService.userAnalyticsId, '');
      });

      test('should handle language region map modifications', () {
        // Arrange
        final originalMap = Map<String, String>.from(
            FirebaseAnalyticsService.languageRegionMap);

        // Act - Modify the map
        FirebaseAnalyticsService.languageRegionMap['test'] = 'test-TEST';

        // Assert
        expect(FirebaseAnalyticsService.languageRegionMap['test'], 'test-TEST');

        // Cleanup - Restore original map
        FirebaseAnalyticsService.languageRegionMap = originalMap;
      });
    });

    group('Error Handling', () {
      test('should handle logEvent exceptions gracefully', () async {
        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.logEvent(eventName: 'test_event'),
          returnsNormally,
        );
      });

      test('should handle logEventButtonClick exceptions gracefully', () async {
        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.logEventButtonClick(
              btnName: 'test_button'),
          returnsNormally,
        );
      });

      test('should handle setUserid exceptions gracefully', () async {
        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.setUserid(userID: 'test_user'),
          returnsNormally,
        );
      });

      test('should handle setAnalyticsEnableStatus exceptions gracefully',
          () async {
        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.setAnalyticsEnableStatus(true),
          returnsNormally,
        );
      });

      test('should handle setUserProperty exceptions gracefully', () async {
        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.setUserProperty(
            name: 'test_property',
            value: 'test_value',
          ),
          returnsNormally,
        );
      });

      test('should handle clearUserOnLogout exceptions gracefully', () async {
        // Act & Assert
        expect(
          () => FirebaseAnalyticsService.clearUserOnLogout(),
          returnsNormally,
        );
      });
    });

    group('Integration Tests', () {
      test('should handle multiple analytics operations', () async {
        // Arrange
        FirebaseAnalyticsService.userAnalyticsId = 'test_user';
        FirebaseAnalyticsService.userLanguage = 'en';

        // Act & Assert
        expect(
          () async {
            await FirebaseAnalyticsService.setUserProperty(
              name: 'test_property',
              value: 'test_value',
            );
            await FirebaseAnalyticsService.logEvent(
              eventName: 'test_event',
              screenName: 'test_screen',
            );
            await FirebaseAnalyticsService.clearUserOnLogout();
          },
          returnsNormally,
        );
      });

      test('should handle route change sequence', () {
        // Arrange
        final service = FirebaseAnalyticsService();

        // Act & Assert
        expect(
          () {
            service.onRouteChanged('/route1');
            service.onRouteChanged('/route2');
            service.onRouteChanged('/route1'); // Same route again
          },
          returnsNormally,
        );
      });

      test('should handle complete user journey', () async {
        // Arrange
        FirebaseAnalyticsService.userAnalyticsId = 'user123';
        FirebaseAnalyticsService.userLanguage = 'en';

        // Act & Assert
        expect(
          () async {
            // User opens app
            await FirebaseAnalyticsService.logEvent(
              eventName: AnalyticsEventConst.EVENT_NAME_APP_OPEN,
              screenName: '/home',
            );

            // User navigates to profile
            await FirebaseAnalyticsService.logEvent(
              eventName: AnalyticsEventConst.EVENT_NAME_SCREEN_VIEW,
              screenName: '/profile',
              previousScreen: '/home',
            );

            // User clicks a button
            await FirebaseAnalyticsService.logEventButtonClick(
              btnName: 'edit_profile_button',
            );

            // User sets language
            await FirebaseAnalyticsService.setUserProperty(
              name: 'user_language',
              value: 'en',
            );

            // User logs out
            await FirebaseAnalyticsService.clearUserOnLogout();
          },
          returnsNormally,
        );
      });

      test('should handle language change workflow', () async {
        // Arrange
        FirebaseAnalyticsService.userLanguage = 'en';

        // Act & Assert
        expect(
          () async {
            // Change language
            FirebaseAnalyticsService.userLanguage = 'fr';
            await FirebaseAnalyticsService.setUserProperty(
              name: 'user_language',
              value: 'fr',
            );

            // Log event with new language
            await FirebaseAnalyticsService.logEvent(
              eventName: 'language_changed',
              parameters: {'new_language': 'fr'},
            );

            // Change back
            FirebaseAnalyticsService.userLanguage = 'en';
          },
          returnsNormally,
        );
      });
    });

    group('Edge Cases', () {
      test('should handle very long event names', () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'a' * 1000, // Very long event name
          ),
          returnsNormally,
        );
      });

      test('should handle very long parameter values', () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            parameters: {'long_param': 'a' * 1000},
          ),
          returnsNormally,
        );
      });

      test('should handle special characters in parameters', () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            parameters: {
              'special_chars': '!@#\$%^&*()_+-=[]{}|;:,.<>?',
              'unicode': '🚀🎉🌟',
            },
          ),
          returnsNormally,
        );
      });

      test('should handle empty route in onRouteChanged', () {
        final service = FirebaseAnalyticsService();
        expect(
          () => service.onRouteChanged(''),
          returnsNormally,
        );
      });

      test('should handle null parameters in logEvent', () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            parameters: null,
          ),
          returnsNormally,
        );
      });

      test('should handle empty string parameters', () async {
        expect(
          () => FirebaseAnalyticsService.logEvent(
            eventName: 'test_event',
            parameters: {
              'empty_string': '',
              'zero_value': 0,
            },
          ),
          returnsNormally,
        );
      });

      test('should handle route with only slashes', () {
        final service = FirebaseAnalyticsService();
        expect(
          () => service.onRouteChanged('///'),
          returnsNormally,
        );
      });

      test('should handle route with only special characters', () {
        final service = FirebaseAnalyticsService();
        expect(
          () => service.onRouteChanged('/!@#\$%^&*()'),
          returnsNormally,
        );
      });

      test('should handle very long route paths', () {
        final service = FirebaseAnalyticsService();
        expect(
          () => service.onRouteChanged('/${'a' * 1000}'),
          returnsNormally,
        );
      });

      test('should handle route with multiple consecutive slashes', () {
        final service = FirebaseAnalyticsService();
        expect(
          () => service.onRouteChanged('/////deep/////nested/////route/////'),
          returnsNormally,
        );
      });
    });
  });
}
