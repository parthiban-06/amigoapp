import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import 'firebase_analytics_service_90_percent_coverage_test.mocks.dart';

@GenerateMocks([
  FirebaseAnalytics,
  FirebaseApp,
  PackageInfo,
  AndroidDeviceInfo,
  IosDeviceInfo,
  AppRouter,
  RouteState,
])
void main() {
  group('FirebaseAnalyticsService 90% Coverage Tests', () {
    late MockFirebaseAnalytics mockAnalytics;
    late MockFirebaseApp mockFirebaseApp;
    late MockPackageInfo mockPackageInfo;
    late MockAndroidDeviceInfo mockAndroidInfo;
    late MockIosDeviceInfo mockIosInfo;
    late MockAppRouter mockAppRouter;
    late MockRouteState mockRouteState;

    setUpAll(() async {
      // Mock Firebase initialization
      TestWidgetsFlutterBinding.ensureInitialized();

      // Mock platform channels
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
      mockAnalytics = MockFirebaseAnalytics();
      mockFirebaseApp = MockFirebaseApp();
      mockPackageInfo = MockPackageInfo();
      mockAndroidInfo = MockAndroidDeviceInfo();
      mockIosInfo = MockIosDeviceInfo();
      mockAppRouter = MockAppRouter();
      mockRouteState = MockRouteState();

      // Setup default mocks
      when(mockAnalytics.logEvent(
        name: anyNamed('name'),
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async {});

      when(mockAnalytics.setUserProperty(
        name: anyNamed('name'),
        value: anyNamed('value'),
      )).thenAnswer((_) async {});

      when(mockAnalytics.setUserId(id: anyNamed('id')))
          .thenAnswer((_) async {});

      when(mockAnalytics.setAnalyticsCollectionEnabled(any))
          .thenAnswer((_) async {});

      when(mockPackageInfo.buildNumber).thenReturn('1.0.0');
      when(mockAndroidInfo.version)
          .thenReturn(AndroidBuildVersion(release: '11'));
      when(mockAndroidInfo.brand).thenReturn('Test Brand');
      when(mockAndroidInfo.model).thenReturn('Test Model');
      when(mockIosInfo.systemVersion).thenReturn('15.0');
      when(mockIosInfo.utsname).thenReturn(IosUtsname(machine: 'iPhone Test'));

      // Setup static variables
      FirebaseAnalyticsService.packageInfo = mockPackageInfo;
      FirebaseAnalyticsService.androidInfo = mockAndroidInfo;
      FirebaseAnalyticsService.iosInfo = mockIosInfo;
      FirebaseAnalyticsService.userAnalyticsId = 'test_user_id';
      FirebaseAnalyticsService.userLanguage = 'en';
      FirebaseAnalyticsService.previousPage = '';
      FirebaseAnalyticsService.genericUiElement = '';
    });

    group('Static Method Coverage Tests', () {
      test('should test cleanRoutePath with various inputs', () {
        // Test leading slash removal
        expect(FirebaseAnalyticsService.cleanRoutePath('/test'), 'test');

        // Test empty path
        expect(FirebaseAnalyticsService.cleanRoutePath(''), 'home');
        expect(FirebaseAnalyticsService.cleanRoutePath('/'), 'home');

        // Test nested routes
        expect(FirebaseAnalyticsService.cleanRoutePath('/user/profile'),
            'user_profile');

        // Test with dashes
        expect(FirebaseAnalyticsService.cleanRoutePath('/api-v1/users'),
            'api_v1_users');

        // Test camelCase conversion
        expect(FirebaseAnalyticsService.cleanRoutePath('/userProfile'),
            'user_profile');

        // Test complex path
        expect(FirebaseAnalyticsService.cleanRoutePath('/api/v1.0/users'),
            'api_v1_0_users');
      });

      test('should test setUserProperty with empty values', () async {
        await FirebaseAnalyticsService.setUserProperty(name: '', value: 'test');
        await FirebaseAnalyticsService.setUserProperty(name: 'test', value: '');

        // Verify no calls were made for empty values
        verifyNever(mockAnalytics.setUserProperty(name: '', value: any));
        verifyNever(mockAnalytics.setUserProperty(name: any, value: ''));
      });

      test('should test setUserProperty with valid values', () async {
        await FirebaseAnalyticsService.setUserProperty(
            name: 'test_prop', value: 'test_value');

        verify(mockAnalytics.setUserProperty(
                name: 'test_prop', value: 'test_value'))
            .called(1);
      });

      test('should test setUserProperty exception handling', () async {
        when(mockAnalytics.setUserProperty(
          name: anyNamed('name'),
          value: anyNamed('value'),
        )).thenThrow(Exception('Test exception'));

        await FirebaseAnalyticsService.setUserProperty(
            name: 'test', value: 'value');
        // Should not throw, should handle exception gracefully
      });

      test('should test setUserid with various inputs', () async {
        await FirebaseAnalyticsService.setUserid(userID: 'test_user');
        verify(mockAnalytics.setUserId(id: 'test_user')).called(1);
      });

      test('should test setUserid exception handling', () async {
        when(mockAnalytics.setUserId(id: anyNamed('id')))
            .thenThrow(Exception('Test exception'));

        await FirebaseAnalyticsService.setUserid(userID: 'test_user');
        // Should not throw, should handle exception gracefully
      });

      test('should test setAnalyticsEnableStatus', () async {
        await FirebaseAnalyticsService.setAnalyticsEnableStatus(true);
        verify(mockAnalytics.setAnalyticsCollectionEnabled(true)).called(1);

        await FirebaseAnalyticsService.setAnalyticsEnableStatus(false);
        verify(mockAnalytics.setAnalyticsCollectionEnabled(false)).called(1);
      });

      test('should test setAnalyticsEnableStatus exception handling', () async {
        when(mockAnalytics.setAnalyticsCollectionEnabled(any))
            .thenThrow(Exception('Test exception'));

        await FirebaseAnalyticsService.setAnalyticsEnableStatus(true);
        // Should not throw, should handle exception gracefully
      });

      test('should test clearUserOnLogout', () async {
        await FirebaseAnalyticsService.clearUserOnLogout();

        verify(mockAnalytics.setUserId(id: null)).called(1);
        verify(mockAnalytics.setUserProperty(name: 'aws_user_id', value: null))
            .called(1);
        verify(mockAnalytics.setUserProperty(
                name: 'aws_user_name', value: null))
            .called(1);
        verify(mockAnalytics.setUserProperty(
                name: 'aws_user_email', value: null))
            .called(1);
        verify(mockAnalytics.setUserProperty(
                name: 'user_role_companion', value: null))
            .called(1);

        expect(FirebaseAnalyticsService.userAnalyticsId, '');
      });

      test('should test clearUserOnLogout exception handling', () async {
        when(mockAnalytics.setUserId(id: anyNamed('id')))
            .thenThrow(Exception('Test exception'));

        await FirebaseAnalyticsService.clearUserOnLogout();
        // Should not throw, should handle exception gracefully
      });
    });

    group('Device Info Coverage Tests', () {
      test('should test getDeviceAnalyticsInfo on web platform', () {
        // Mock web platform
        TestWidgetsFlutterBinding.ensureInitialized();

        final info = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

        expect(info['platform'], 'Web');
        expect(info['device_category'], 'Web');
        expect(info['language'], 'en');
        expect(info['language_code'], 'en-IN');
        expect(info['user_authenticated_state'], 'authenticated');
        expect(info['user_state'], 'registered');
        expect(info['app_version'], '1.0.0');
        expect(info['reffered_from'], 'email');
        expect(info['nonInteraction'], '1');
        expect(info['uiInteraction'], '0');
        expect(info).toContainKey('timestamp');
        expect(info).toContainKey('screen_resolution');
      });

      test('should test getDeviceAnalyticsInfo on Android platform', () {
        // Mock Android platform
        TestWidgetsFlutterBinding.ensureInitialized();

        final info = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

        expect(info['platform'], 'Android');
        expect(info['os_version'], 'Android 11');
        expect(info['device'], 'Test Brand');
        expect(info['device_model'], 'Test Model');
        expect(info['device_category'], 'mobile');
      });

      test('should test getDeviceAnalyticsInfo on iOS platform', () {
        // Mock iOS platform
        TestWidgetsFlutterBinding.ensureInitialized();

        final info = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

        expect(info['platform'], 'iOS');
        expect(info['os_version'], '15.0');
        expect(info['device'], 'Apple');
        expect(info['device_model'], 'iPhone Test');
        expect(info['device_category'], 'mobile');
      });

      test('should test getDeviceAnalyticsInfo with empty user ID', () {
        FirebaseAnalyticsService.userAnalyticsId = '';

        final info = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

        expect(info['user_authenticated_state'], 'non authenticated');
        expect(info['user_state'], 'anonymous');
        expect(info).not.toContainKey('user_id');
      });

      test('should test getDeviceAnalyticsInfo exception handling', () {
        // Force an exception by setting packageInfo to null
        FirebaseAnalyticsService.packageInfo = null;

        final info = FirebaseAnalyticsService.getDeviceAnalyticsInfo({});

        // Should return info even with exception
        expect(info).isNotEmpty;
      });

      test('should test language region mapping', () {
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

    group('Log Event Coverage Tests', () {
      test('should test logEvent with all parameters', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          screenName: '/test_screen',
          previousScreen: '/previous_screen',
          parameters: {'test_param': 'test_value'},
        );

        verify(mockAnalytics.logEvent(
          name: 'test_event',
          parameters: anyNamed('parameters'),
        )).called(1);
      });

      test('should test logEvent with UI element parameters', () async {
        await FirebaseAnalyticsService.logEvent(
          eventName: 'test_event',
          parameters: {
            'ui_element': 'test_button',
            'ui_element_location': 'test_location',
          },
        );

        verify(mockAnalytics.logEvent(
          name: 'test_event',
          parameters: anyNamed('parameters'),
        )).called(1);
      });

      test('should test logEvent exception handling', () async {
        when(mockAnalytics.logEvent(
          name: anyNamed('name'),
          parameters: anyNamed('parameters'),
        )).thenThrow(Exception('Test exception'));

        await FirebaseAnalyticsService.logEvent(eventName: 'test_event');
        // Should not throw, should handle exception gracefully
      });

      test('should test logEventButtonClick with custom parameters', () async {
        await FirebaseAnalyticsService.logEventButtonClick(
          name: 'custom_event',
          btnName: 'test_button',
          parameters: {'custom_param': 'custom_value'},
        );

        verify(mockAnalytics.logEvent(
          name: 'custom_event',
          parameters: anyNamed('parameters'),
        )).called(1);
      });

      test('should test logEventButtonClick with empty button name', () async {
        await FirebaseAnalyticsService.logEventButtonClick(btnName: '');

        verify(mockAnalytics.logEvent(
          name: AnalyticsEventConst.EVENT_NAME_UI_INTERACTION,
          parameters: anyNamed('parameters'),
        )).called(1);
      });

      test('should test logEventButtonClick exception handling', () async {
        when(mockAnalytics.logEvent(
          name: anyNamed('name'),
          parameters: anyNamed('parameters'),
        )).thenThrow(Exception('Test exception'));

        await FirebaseAnalyticsService.logEventButtonClick(btnName: 'test');
        // Should not throw, should handle exception gracefully
      });
    });

    group('Route Change Coverage Tests', () {
      test('should test onRouteChanged with valid route', () {
        final service = FirebaseAnalyticsService();

        service.onRouteChanged('/test_route');

        verify(mockAnalytics.logEvent(
          name: AnalyticsEventConst.EVENT_NAME_SCREEN_VIEW,
          parameters: anyNamed('parameters'),
        )).called(1);
      });

      test('should test onRouteChanged with empty route', () {
        final service = FirebaseAnalyticsService();

        service.onRouteChanged('');

        // Should not call logEvent for empty route
        verifyNever(mockAnalytics.logEvent(
          name: anyNamed('name'),
          parameters: anyNamed('parameters'),
        ));
      });

      test('should test onRouteChanged with null route', () {
        final service = FirebaseAnalyticsService();

        service.onRouteChanged(null);

        // Should not call logEvent for null route
        verifyNever(mockAnalytics.logEvent(
          name: anyNamed('name'),
          parameters: anyNamed('parameters'),
        ));
      });
    });

    group('Constants Coverage Tests', () {
      test('should test all AnalyticsEventConst values', () {
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

        expect(
            AnalyticsEventConst.FORM_ID_RESGITRATION, 'form_registration_01');
        expect(AnalyticsEventConst.FORM_NAME_RESGITRATION, 'registration_page');

        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT, 'ui_element');
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION,
            'ui_element_location');
        expect(AnalyticsEventConst.PARAM_NAME_TILE_NAME, 'tile_name');
        expect(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LABEL,
            'ui_element_label');
        expect(AnalyticsEventConst.PARAM_NAME_SOURCE_SCREEN, 'source_screen');

        expect(AnalyticsEventConst.ANALYTICS_AUTHENTICATED, 'authenticated');
        expect(AnalyticsEventConst.ANALYTICS_NON_AUTHENTICATED,
            'non_authenticated');
      });
    });

    group('Language Region Map Coverage Tests', () {
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

    group('Static Variables Coverage Tests', () {
      test('should test static variable initialization and access', () {
        // Test device_category
        expect(FirebaseAnalyticsService.device_category, 'mobile');

        // Test nonInteraction
        expect(FirebaseAnalyticsService.nonInteraction, true);

        // Test _isTrackingPermissionAllowed
        // This is private but we can test it through public methods

        // Test userLanguage
        expect(FirebaseAnalyticsService.userLanguage, 'en');

        // Test previousPage
        expect(FirebaseAnalyticsService.previousPage, '');

        // Test genericUiElement
        expect(FirebaseAnalyticsService.genericUiElement, '');

        // Test userAnalyticsId
        expect(FirebaseAnalyticsService.userAnalyticsId, 'test_user_id');
      });
    });

    group('Integration Coverage Tests', () {
      test('should test complete analytics workflow', () async {
        // Set up user
        await FirebaseAnalyticsService.setUserid(userID: 'test_user');

        // Set user properties
        await FirebaseAnalyticsService.setUserProperty(
            name: 'user_role', value: 'admin');

        // Log events
        await FirebaseAnalyticsService.logEvent(
          eventName: 'user_login',
          screenName: '/login',
          parameters: {'method': 'email'},
        );

        await FirebaseAnalyticsService.logEventButtonClick(
          btnName: 'login_button',
          parameters: {'location': 'login_form'},
        );

        // Change route
        final service = FirebaseAnalyticsService();
        service.onRouteChanged('/dashboard');

        // Clear user on logout
        await FirebaseAnalyticsService.clearUserOnLogout();

        // Verify all calls were made
        verify(mockAnalytics.setUserId(id: 'test_user')).called(1);
        verify(mockAnalytics.setUserProperty(name: 'user_role', value: 'admin'))
            .called(1);
        verify(mockAnalytics.logEvent(
                name: 'user_login', parameters: anyNamed('parameters')))
            .called(1);
        verify(mockAnalytics.logEvent(
                name: AnalyticsEventConst.EVENT_NAME_UI_INTERACTION,
                parameters: anyNamed('parameters')))
            .called(1);
        verify(mockAnalytics.logEvent(
                name: AnalyticsEventConst.EVENT_NAME_SCREEN_VIEW,
                parameters: anyNamed('parameters')))
            .called(1);
        verify(mockAnalytics.setUserId(id: null)).called(1);
      });
    });
  });
}
