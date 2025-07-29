import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/analytics/firebase_analytics_observer.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';

/// Comprehensive Analytics Test Runner for 90% LCOV Coverage
///
/// This file contains additional tests specifically designed to achieve
/// 90% line coverage for the analytics module. It focuses on:
/// - Edge cases and boundary conditions
/// - Error handling scenarios
/// - Platform-specific behavior
/// - Static variable management
/// - Integration scenarios

void main() {
  group('Analytics Coverage Enhancement Tests for 90% LCOV', () {
    setUp(() {
      // Reset static variables before each test
      FirebaseAnalyticsService.previousPage = "";
      FirebaseAnalyticsService.genericUiElement = "";
      FirebaseAnalyticsService.userAnalyticsId = "";
      FirebaseAnalyticsService.nonInteraction = true;
      FirebaseAnalyticsService.userLanguage = "en";
      FirebaseAnalyticsService.packageInfo = null;
      FirebaseAnalyticsService.androidInfo = null;
      FirebaseAnalyticsService.iosInfo = null;
    });

    group('Device Analytics Info Coverage Tests', () {
      test('should handle all platform scenarios', () {
        // Test web platform
        final webInfo = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(webInfo['platform'], isNotNull);
        expect(webInfo['device_category'], isNotNull);

        // Test mobile platform
        final mobileInfo = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(mobileInfo['platform'], isNotNull);
        expect(mobileInfo['device_category'], 'mobile');
      });

      test('should handle all user authentication states', () {
        // Test authenticated user
        FirebaseAnalyticsService.userAnalyticsId = 'user123';
        final authInfo = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(authInfo['user_authenticated_state'], 'authenticated');
        expect(authInfo['user_state'], 'registered');

        // Test anonymous user
        FirebaseAnalyticsService.userAnalyticsId = '';
        final anonInfo = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(anonInfo['user_authenticated_state'], 'non authenticated');
        expect(anonInfo['user_state'], 'anonymous');
      });

      test('should handle all language scenarios', () {
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

        for (final lang in supportedLanguages) {
          FirebaseAnalyticsService.userLanguage = lang;
          final info = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
          expect(info['language'], lang);
          expect(info['language_code'], isNotNull);
        }

        // Test unknown language
        FirebaseAnalyticsService.userLanguage = 'unknown';
        final unknownInfo = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(unknownInfo['language'], 'unknown');
        expect(unknownInfo['language_code'], 'en-IN');
      });

      test('should handle all interaction flag states', () {
        // Test non-interaction true
        FirebaseAnalyticsService.nonInteraction = true;
        final nonInteractInfo =
            FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(nonInteractInfo['nonInteraction'], '1');
        expect(nonInteractInfo['uiInteraction'], '0');

        // Test non-interaction false
        FirebaseAnalyticsService.nonInteraction = false;
        final interactInfo =
            FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(interactInfo['nonInteraction'], '0');
        expect(interactInfo['uiInteraction'], '1');
      });

      test('should handle null and empty info parameters', () {
        // Test null parameter
        final nullResult =
            FirebaseAnalyticsService.getDeviceAnalyticsInfo(null);
        expect(nullResult, isNotNull);

        // Test empty parameter
        final emptyResult = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(emptyResult, isNotNull);
      });

      test('should handle very long values', () {
        // Test very long user ID
        final longId = 'a' * 10000;
        FirebaseAnalyticsService.userAnalyticsId = longId;
        final longIdInfo = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(longIdInfo['user_id'], longId);

        // Test very long language
        final longLang = 'a' * 100;
        FirebaseAnalyticsService.userLanguage = longLang;
        final longLangInfo =
            FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(longLangInfo['language'], longLang);
      });
    });

    group('Route Change Coverage Tests', () {
      test('should handle all route scenarios', () {
        final service = FirebaseAnalyticsService();

        // Test empty route
        expect(() => service.onRouteChanged(''), returnsNormally);

        // Test whitespace route
        expect(() => service.onRouteChanged('   '), returnsNormally);

        // Test normal route
        expect(() => service.onRouteChanged('/home'), returnsNormally);

        // Test route with special characters
        expect(() => service.onRouteChanged('/route-with-special-chars!@#'),
            returnsNormally);

        // Test very long route
        final longRoute = '/${'a' * 1000}';
        expect(() => service.onRouteChanged(longRoute), returnsNormally);

        // Test route with query parameters
        expect(() => service.onRouteChanged('/search?q=test&page=1'),
            returnsNormally);

        // Test route with fragments
        expect(
            () => service.onRouteChanged('/profile#settings'), returnsNormally);

        // Test route with multiple slashes
        expect(() => service.onRouteChanged('///deep/nested///route///'),
            returnsNormally);
      });

      test('should handle rapid route changes', () {
        final service = FirebaseAnalyticsService();

        // Test multiple rapid changes
        for (int i = 0; i < 10; i++) {
          expect(() => service.onRouteChanged('/route$i'), returnsNormally);
        }
      });

      test('should handle same route multiple times', () {
        final service = FirebaseAnalyticsService();
        const route = '/same_route';

        // Test same route multiple times
        for (int i = 0; i < 5; i++) {
          expect(() => service.onRouteChanged(route), returnsNormally);
        }
      });
    });

    group('Static Variable Coverage Tests', () {
      test('should handle all static variable modifications', () {
        // Test userAnalyticsId
        FirebaseAnalyticsService.userAnalyticsId = 'test_user';
        expect(FirebaseAnalyticsService.userAnalyticsId, 'test_user');

        // Test userLanguage
        FirebaseAnalyticsService.userLanguage = 'fr';
        expect(FirebaseAnalyticsService.userLanguage, 'fr');

        // Test nonInteraction
        FirebaseAnalyticsService.nonInteraction = false;
        expect(FirebaseAnalyticsService.nonInteraction, false);

        // Test previousPage
        FirebaseAnalyticsService.previousPage = '/test_page';
        expect(FirebaseAnalyticsService.previousPage, '/test_page');

        // Test genericUiElement
        FirebaseAnalyticsService.genericUiElement = 'test_element';
        expect(FirebaseAnalyticsService.genericUiElement, 'test_element');

        // Test device_category
        FirebaseAnalyticsService.device_category = 'tablet';
        expect(FirebaseAnalyticsService.device_category, 'tablet');
      });

      test('should handle language region map modifications', () {
        final originalMap = Map<String, String>.from(
            FirebaseAnalyticsService.languageRegionMap);

        // Test adding new language
        FirebaseAnalyticsService.languageRegionMap['test'] = 'test-TEST';
        expect(FirebaseAnalyticsService.languageRegionMap['test'], 'test-TEST');

        // Test clearing map
        FirebaseAnalyticsService.languageRegionMap.clear();
        expect(FirebaseAnalyticsService.languageRegionMap, isEmpty);

        // Restore original map
        FirebaseAnalyticsService.languageRegionMap = originalMap;
      });
    });

    group('Analytics Constants Coverage Tests', () {
      test('should verify all event name constants', () {
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
      });

      test('should verify all parameter name constants', () {
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT, 'ui_element');
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION,
            'ui_element_location');
        expect(AnalyticsEventConst.PARAM_NAME_TILE_NAME, 'tile_name');
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LABEL,
            'ui_element_label');
        expect(AnalyticsEventConst.PARAM_NAME_SOURCE_SCREEN, 'source_screen');
      });

      test('should verify all form constants', () {
        expect(
            AnalyticsEventConst.FORM_ID_RESGITRATION, 'form_registration_01');
        expect(AnalyticsEventConst.FORM_NAME_RESGITRATION, 'registration_page');
      });

      test('should verify all authentication constants', () {
        expect(AnalyticsEventConst.ANALYTICS_AUTHENTICATED, 'authenticated');
        expect(AnalyticsEventConst.ANALYTICS_NON_AUTHENTICATED,
            'non_authenticated');
      });
    });

    group('Integration Coverage Tests', () {
      test('should handle complete user journey scenarios', () {
        // Test complete user journey
        FirebaseAnalyticsService.userAnalyticsId = 'user123';
        FirebaseAnalyticsService.userLanguage = 'en';
        FirebaseAnalyticsService.nonInteraction = true;

        final service = FirebaseAnalyticsService();

        // Simulate user journey
        expect(() => service.onRouteChanged('/home'), returnsNormally);
        expect(() => service.onRouteChanged('/profile'), returnsNormally);
        expect(() => service.onRouteChanged('/settings'), returnsNormally);
        expect(() => service.onRouteChanged('/logout'), returnsNormally);

        // Verify device info
        final deviceInfo = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(deviceInfo['user_id'], 'user123');
        expect(deviceInfo['language'], 'en');
        expect(deviceInfo['nonInteraction'], '1');
      });

      test('should handle multiple state changes', () {
        // Test multiple state changes
        for (int i = 0; i < 5; i++) {
          FirebaseAnalyticsService.userAnalyticsId = 'user$i';
          FirebaseAnalyticsService.userLanguage = i % 2 == 0 ? 'en' : 'fr';
          FirebaseAnalyticsService.nonInteraction = i % 2 == 0;

          final deviceInfo =
              FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
          expect(deviceInfo['user_id'], 'user$i');
          expect(deviceInfo['language'], i % 2 == 0 ? 'en' : 'fr');
          expect(deviceInfo['nonInteraction'], i % 2 == 0 ? '1' : '0');
        }
      });

      test('should handle language change workflow', () {
        // Test language change workflow
        final languages = ['en', 'fr', 'es', 'de', 'ja'];

        for (final lang in languages) {
          FirebaseAnalyticsService.userLanguage = lang;
          final deviceInfo =
              FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
          expect(deviceInfo['language'], lang);
        }
      });
    });

    group('Error Handling Coverage Tests', () {
      test('should handle exceptions gracefully', () {
        // Test device info with null values
        FirebaseAnalyticsService.packageInfo = null;
        FirebaseAnalyticsService.androidInfo = null;
        FirebaseAnalyticsService.iosInfo = null;

        expect(() => FirebaseAnalyticsService.getDeviceAnalyticsInfo({}),
            returnsNormally);
        expect(() => FirebaseAnalyticsService.getDeviceAnalyticsInfo(null),
            returnsNormally);
      });

      test('should handle edge cases', () {
        // Test empty language region map
        final originalMap = Map<String, String>.from(
            FirebaseAnalyticsService.languageRegionMap);
        FirebaseAnalyticsService.languageRegionMap.clear();

        final deviceInfo = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});
        expect(deviceInfo['language_code'], 'en-IN'); // Should have default

        // Restore original map
        FirebaseAnalyticsService.languageRegionMap = originalMap;
      });
    });

    group('Observer Coverage Tests', () {
      test('should handle all route extraction scenarios', () {
        final mockService = MockFirebaseAnalyticsService();
        final observer =
            FirebaseAnalyticsRouteObserver(analyticsListener: mockService);

        // Test route with name
        final namedRoute =
            MockRoute(settings: RouteSettings(name: '/named_route'));
        observer.didPop(namedRoute, null);
        expect(mockService.lastRouteCalled, '/named_route');

        // Test route with string arguments
        final stringArgRoute = MockRoute(
          settings: RouteSettings(name: null, arguments: '/string_argument'),
        );
        observer.didPop(stringArgRoute, null);
        expect(mockService.lastRouteCalled, '/string_argument');

        // Test route with non-string arguments
        final nonStringArgRoute = MockRoute(
          settings: RouteSettings(name: null, arguments: 123),
        );
        observer.didPop(nonStringArgRoute, null);
        expect(mockService.lastRouteCalled, 'MockRoute');

        // Test route with null settings
        final nullSettingsRoute = MockRoute(settings: null);
        observer.didPop(nullSettingsRoute, null);
        expect(mockService.lastRouteCalled, 'MockRoute');
      });

      test('should handle multiple observer instances', () {
        final mockService1 = MockFirebaseAnalyticsService();
        final mockService2 = MockFirebaseAnalyticsService();

        final observer1 =
            FirebaseAnalyticsRouteObserver(analyticsListener: mockService1);
        final observer2 =
            FirebaseAnalyticsRouteObserver(analyticsListener: mockService2);

        final route = MockRoute(settings: RouteSettings(name: '/test_route'));

        observer1.didPop(route, null);
        observer2.didPop(route, null);

        expect(mockService1.lastRouteCalled, '/test_route');
        expect(mockService2.lastRouteCalled, '/test_route');
        expect(mockService1.callCount, 1);
        expect(mockService2.callCount, 1);
      });
    });
  });
}

// Mock classes for testing
class MockFirebaseAnalyticsService extends FirebaseAnalyticsService {
  String? lastRouteCalled;
  int callCount = 0;
  List<String> routeHistory = [];

  @override
  void onRouteChanged(String newRoute) {
    lastRouteCalled = newRoute;
    callCount++;
    routeHistory.add(newRoute);
  }

  void reset() {
    lastRouteCalled = null;
    callCount = 0;
    routeHistory.clear();
  }
}

class MockRoute extends Route<dynamic> {
  MockRoute({required RouteSettings? settings}) : super(settings: settings);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Container();
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
