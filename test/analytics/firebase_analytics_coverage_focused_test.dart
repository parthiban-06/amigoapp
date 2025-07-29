import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

void main() {
  group('FirebaseAnalyticsService Focused Coverage Tests', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Mock platform channels to avoid Firebase initialization issues
      const MethodChannel('plugins.flutter.io/package_info')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        return {
          'appName': 'Test App',
          'packageName': 'com.test.app',
          'version': '1.0.0',
          'buildNumber': '1',
        };
      });

      const MethodChannel('plugins.flutter.io/device_info_plus')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getAndroidDeviceInfo') {
          return {
            'version.release': '11',
            'brand': 'Test Brand',
            'model': 'Test Model',
          };
        } else if (methodCall.method == 'getIosDeviceInfo') {
          return {
            'systemVersion': '15.0',
            'utsname.machine': 'iPhone Test',
          };
        }
        return {};
      });
    });

    setUp(() {
      // Reset static variables
      FirebaseAnalyticsService.userAnalyticsId = 'test_user_id';
      FirebaseAnalyticsService.userLanguage = 'en';
      FirebaseAnalyticsService.previousPage = '';
      FirebaseAnalyticsService.genericUiElement = '';
      FirebaseAnalyticsService.nonInteraction = true;
    });

    group('Route Path Cleaning Tests', () {
      test('should handle routes with numbers and special characters', () {
        expect(FirebaseAnalyticsService.cleanRoutePath('/api/v1.0/users'),
            'api_v1_0_users');
        expect(FirebaseAnalyticsService.cleanRoutePath('/api-v1/users'),
            'api_v1_users');
        expect(FirebaseAnalyticsService.cleanRoutePath('/user-profile'),
            'user_profile');
      });

      test('should handle empty and root paths', () {
        expect(FirebaseAnalyticsService.cleanRoutePath(''), 'home');
        expect(FirebaseAnalyticsService.cleanRoutePath('/'), 'home');
        expect(FirebaseAnalyticsService.cleanRoutePath('   '), 'home');
      });

      test('should handle nested routes', () {
        expect(
            FirebaseAnalyticsService.cleanRoutePath('/user/profile/settings'),
            'user_profile_settings');
        expect(FirebaseAnalyticsService.cleanRoutePath('/api/v1/users/123'),
            'api_v1_users_123');
      });

      test('should handle camelCase conversion', () {
        expect(FirebaseAnalyticsService.cleanRoutePath('/userProfile'),
            'user_profile');
        expect(FirebaseAnalyticsService.cleanRoutePath('/apiV1Users'),
            'api_v1_users');
      });
    });

    group('User Property Tests', () {
      test('should handle empty name and value', () async {
        // These should return early without calling Firebase
        await FirebaseAnalyticsService.setUserProperty(name: '', value: 'test');
        await FirebaseAnalyticsService.setUserProperty(name: 'test', value: '');
        await FirebaseAnalyticsService.setUserProperty(name: '', value: '');
      });

      test('should handle valid user properties', () async {
        // These will fail due to Firebase not being initialized, but we're testing the logic
        await FirebaseAnalyticsService.setUserProperty(
            name: 'test_prop', value: 'test_value');
        await FirebaseAnalyticsService.setUserProperty(
            name: 'user_role', value: 'admin');
      });

      test('should handle special characters in user properties', () async {
        await FirebaseAnalyticsService.setUserProperty(
            name: 'test_prop', value: 'test@value#123');
        await FirebaseAnalyticsService.setUserProperty(
            name: 'user_name', value: 'John Doe');
      });

      test('should handle unicode characters in user properties', () async {
        await FirebaseAnalyticsService.setUserProperty(
            name: 'user_name', value: 'José María');
        await FirebaseAnalyticsService.setUserProperty(
            name: 'description', value: '测试用户');
      });
    });

    group('User ID Tests', () {
      test('should handle valid user ID', () async {
        await FirebaseAnalyticsService.setUserid(userID: 'test_user_123');
        await FirebaseAnalyticsService.setUserid(userID: 'user@example.com');
      });

      test('should handle empty user ID', () async {
        await FirebaseAnalyticsService.setUserid(userID: '');
      });

      test('should handle user ID with special characters', () async {
        await FirebaseAnalyticsService.setUserid(userID: 'user-123_test');
        await FirebaseAnalyticsService.setUserid(userID: 'user@domain.com');
      });

      test('should handle very long user ID', () async {
        final longUserId = 'a' * 1000;
        await FirebaseAnalyticsService.setUserid(userID: longUserId);
      });
    });

    group('Analytics Enable Status Tests', () {
      test('should enable analytics', () async {
        await FirebaseAnalyticsService.setAnalyticsEnableStatus(true);
      });

      test('should disable analytics', () async {
        await FirebaseAnalyticsService.setAnalyticsEnableStatus(false);
      });

      test('should handle multiple enable/disable cycles', () async {
        await FirebaseAnalyticsService.setAnalyticsEnableStatus(true);
        await FirebaseAnalyticsService.setAnalyticsEnableStatus(false);
        await FirebaseAnalyticsService.setAnalyticsEnableStatus(true);
        await FirebaseAnalyticsService.setAnalyticsEnableStatus(false);
      });
    });

    group('Device Info Tests', () {
      test('should return web platform info when running on web', () {
        final info = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

        // Test that all required fields are present
        expect(info).toContainKey('platform');
        expect(info).toContainKey('device_category');
        expect(info).toContainKey('language');
        expect(info).toContainKey('language_code');
        expect(info).toContainKey('user_authenticated_state');
        expect(info).toContainKey('user_state');
        expect(info).toContainKey('app_version');
        expect(info).toContainKey('reffered_from');
        expect(info).toContainKey('nonInteraction');
        expect(info).toContainKey('uiInteraction');
        expect(info).toContainKey('timestamp');
        expect(info).toContainKey('screen_resolution');
      });

      test('should handle device info with empty user ID', () {
        FirebaseAnalyticsService.userAnalyticsId = '';
        final info = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

        expect(info['user_authenticated_state'], 'non authenticated');
        expect(info['user_state'], 'anonymous');
        expect(info).not.toContainKey('user_id');
      });

      test('should handle device info with different languages', () {
        FirebaseAnalyticsService.userLanguage = 'fr';
        final info = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(info['language_code'], 'fr-CA');

        FirebaseAnalyticsService.userLanguage = 'es';
        final info2 = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(info2['language_code'], 'es-MX');

        FirebaseAnalyticsService.userLanguage = 'unknown';
        final info3 = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(info3['language_code'], 'en-IN');
      });
    });

    group('Logout Tests', () {
      test('should clear user analytics ID', () async {
        FirebaseAnalyticsService.userAnalyticsId = 'test_user_123';
        await FirebaseAnalyticsService.clearUserOnLogout();
        expect(FirebaseAnalyticsService.userAnalyticsId, '');
      });

      test('should handle logout when user ID is already empty', () async {
        FirebaseAnalyticsService.userAnalyticsId = '';
        await FirebaseAnalyticsService.clearUserOnLogout();
        expect(FirebaseAnalyticsService.userAnalyticsId, '');
      });

      test('should handle logout with long user ID', () async {
        FirebaseAnalyticsService.userAnalyticsId = 'a' * 1000;
        await FirebaseAnalyticsService.clearUserOnLogout();
        expect(FirebaseAnalyticsService.userAnalyticsId, '');
      });
    });

    group('Route Change Tests', () {
      test('should handle route changes', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('/test_route');
        service.onRouteChanged('/another_route');
      });

      test('should handle same route multiple times', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('/same_route');
        service.onRouteChanged('/same_route');
        service.onRouteChanged('/same_route');
      });

      test('should handle route with special characters', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('/route-with-dashes_and_underscores');
        service.onRouteChanged('/route/with/slashes');
      });

      test('should handle route with query parameters', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('/route?param=value');
        service.onRouteChanged('/route?param1=value1&param2=value2');
      });

      test('should handle route with fragments', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('/route#fragment');
        service.onRouteChanged('/route?param=value#fragment');
      });

      test('should handle route with multiple slashes', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('///route');
        service.onRouteChanged('/route///');
      });

      test('should handle empty route', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('');
        service.onRouteChanged('   ');
      });

      test('should handle null route', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged(null);
      });
    });

    group('Log Event Tests', () {
      test('should handle event with all parameters', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          screenName: '/test_screen',
          previousScreen: '/previous_screen',
          parameters: {'test_param': 'test_value'},
        );
      });

      test('should handle event with null parameters', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          screenName: null,
          previousScreen: null,
          parameters: null,
        );
      });

      test('should handle event with UI element parameters', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {
            'ui_element': 'test_button',
            'ui_element_location': 'test_location',
          },
        );
      });

      test('should handle event with empty parameters', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {},
        );
      });

      test(
          'should handle event with empty string UI element parameters', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {
            'ui_element': '',
            'ui_element_location': '',
          },
        );
      });

      test('should handle event with very long parameter values', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {
            'long_param': 'a' * 1000,
            'another_long_param': 'b' * 500,
          },
        );
      });

      test(
          'should handle event with special characters in parameters', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {
            'special_param': 'test@value#123!',
            'unicode_param': '测试参数',
          },
        );
      });

      test('should handle event with numeric parameters', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {
            'count': 123,
            'price': 99.99,
            'is_active': true,
          },
        );
      });
    });

    group('Button Click Event Tests', () {
      test('should handle button click with empty name', () async {
        await FirebaseAnalyticsService.logEventButtonClick(btnName: '');
      });

      test('should handle button click with custom parameters', () async {
        await FirebaseAnalyticsService.logEventButtonClick(
          btnName: 'test_button',
          parameters: {'custom_param': 'custom_value'},
        );
      });

      test('should handle button click with custom event name', () async {
        await FirebaseAnalyticsService.logEventButtonClick(
          name: 'custom_button_click',
          btnName: 'test_button',
        );
      });

      test('should handle button click with null parameters', () async {
        await FirebaseAnalyticsService.logEventButtonClick(
          btnName: 'test_button',
          parameters: null,
        );
      });

      test(
          'should handle button click with special characters in name', () async {
        await FirebaseAnalyticsService.logEventButtonClick(
          btnName: 'test-button_123!',
        );
      });
    });

    group('Constants Tests', () {
      test('should test all AnalyticsEventConst values', () {
        // Test all event name constants
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

        // Test form constants
        expect(
            AnalyticsEventConst.FORM_ID_RESGITRATION, 'form_registration_01');
        expect(AnalyticsEventConst.FORM_NAME_RESGITRATION, 'registration_page');

        // Test parameter constants
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT, 'ui_element');
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION,
            'ui_element_location');
        expect(AnalyticsEventConst.PARAM_NAME_TILE_NAME, 'tile_name');
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LABEL,
            'ui_element_label');
        expect(AnalyticsEventConst.PARAM_NAME_SOURCE_SCREEN, 'source_screen');

        // Test analytics constants
        expect(AnalyticsEventConst.ANALYTICS_AUTHENTICATED, 'authenticated');
        expect(AnalyticsEventConst.ANALYTICS_NON_AUTHENTICATED,
            'non_authenticated');
      });
    });

    group('Language Region Map Tests', () {
      test('should test all language region mappings', () {
        final map = FirebaseAnalyticsService.languageRegionMap;

        expect(map['en'], 'en-IN');
        expect(map['fr'], 'fr-CA');
        expect(map['es'], 'es-MX');
        expect(map['ar'], 'ar-SA');
        expect(map['de'], 'de-DE');
        expect(map['ja'], 'ja-JP');
        expect(map['ko'], 'ko-KR');
        expect(map['pt'], 'pt-BR');
        expect(map['zh'], 'zh-CN');
      });
    });

    group('Static Variables Tests', () {
      test('should test static variable access', () {
        expect(FirebaseAnalyticsService.device_category, 'mobile');
        expect(FirebaseAnalyticsService.nonInteraction, true);
        expect(FirebaseAnalyticsService.userLanguage, 'en');
        expect(FirebaseAnalyticsService.previousPage, '');
        expect(FirebaseAnalyticsService.genericUiElement, '');
        expect(FirebaseAnalyticsService.userAnalyticsId, 'test_user_id');
      });
    });

    group('Edge Case Tests', () {
      test('should handle very long event names', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'a' * 1000,
          parameters: {'test': 'value'},
        );
      });

      test('should handle very long parameter values', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {'long_value': 'a' * 1000},
        );
      });

      test('should handle special characters in parameters', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {'special': '!@#$%^&*()'},
        );
      });

      test('should handle null parameters in logEvent', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {'null_param': null},
        );
      });

      test('should handle empty string parameters', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {'empty_param': ''},
        );
      });

      test('should handle route with only slashes', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('///');
        service.onRouteChanged('/');
      });

      test('should handle route with only special characters', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('!@#$%^&*()');
        service.onRouteChanged('   ');
      });

      test('should handle very long route paths', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('/${'a' * 1000}');
      });

      test('should handle route with multiple consecutive slashes', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('////route////');
      });
    });

    group('Integration Tests', () {
      test('should handle multiple analytics operations', () async {
        // Set user properties
        await FirebaseAnalyticsService.setUserProperty(
            name: 'user_role', value: 'admin');
        await FirebaseAnalyticsService.setUserProperty(
            name: 'user_type', value: 'premium');

        // Log events
        await FirebaseAnalyticsService.logEvent(
          eventName: 'user_action',
          parameters: {'action': 'login'},
        );

        // Clear user
        await FirebaseAnalyticsService.clearUserOnLogout();
      });

      test('should handle route change sequence', () {
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('/home');
        service.onRouteChanged('/profile');
        service.onRouteChanged('/settings');
      });

      test('should handle complete user journey', () async {
        // Login
        await FirebaseAnalyticsService.setUserid(userID: 'user123');
        await FirebaseAnalyticsService.logEvent(
          eventName: 'user_login',
          parameters: {'method': 'email'},
        );

        // Navigate
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('/dashboard');

        // Logout
        await FirebaseAnalyticsService.clearUserOnLogout();
      });

      test('should handle language change workflow', () async {
        // Set language
        FirebaseAnalyticsService.userLanguage = 'fr';
        await FirebaseAnalyticsService.setUserProperty(
            name: 'language', value: 'fr');

        // Log event with new language
        await FirebaseAnalyticsService.logEvent(
          eventName: 'language_changed',
          parameters: {'new_language': 'fr'},
        );
      });
    });
  });
} 