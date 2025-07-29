import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../router/app_router.dart';
import '../router/app_routes_const.dart';

class FirebaseAnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Map<String, String> languageRegionMap = {
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

  String? _currentRoute;
  static String previousPage = "";
  static String firstEvaSection = "";
  static String genericUiElement = "";
  static String userAnalyticsId = "";

  static String device_category = "mobile";
  static PackageInfo? packageInfo;
  static AndroidDeviceInfo? androidInfo;
  static IosDeviceInfo? iosInfo;
  static bool nonInteraction = true;
  static bool _isTrackingPermissionAllowed = false;
  static String userLanguage = "en";

  /// Logs a custom event
  static Future<void> logEvent({
    required String eventName,
    String? screenName,
    String? previousScreen,
    Map<String, Object>? parameters,
  }) async {
    try {
      // Get current screen name
      screenName ??=
          RouteNames.getAnalyticsName(AppRouter.router.state.path ?? "");

      // Get previous screen name
      previousScreen ??= previousPage;
      previousScreen = RouteNames.getAnalyticsName(previousScreen ?? '');

      // Build parameters
      final eventParams = {
        ...?parameters,
        'screen_name': RouteNames.getAnalyticsName(screenName ?? ''),
        'title': RouteNames.getAnalyticsName(screenName ?? ''),
        'previous_screen': previousScreen,
        ...getFilteredDeviceAnalyticsInfo(
            getDeviceAnalyticsInfo({}), parameters),
      };

      if (eventParams.containsKey(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT)) {
        eventParams[AnalyticsEventConst.PARAM_NAME_UI_ELEMENT] =
            RouteNames.getAnalyticsName(
                eventParams[AnalyticsEventConst.PARAM_NAME_UI_ELEMENT]
                        .toString() ??
                    "");
      }

      if (eventParams
          .containsKey(AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION)) {
        eventParams[AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION] =
            RouteNames.getAnalyticsName(
                eventParams[AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION]
                        .toString() ??
                    "");
      }
      _analytics.logEvent(
        name: eventName,
        parameters: eventParams,
      );

      // Update previous page for next call
      if (previousPage != screenName) {
        previousPage = screenName;
      }
// coverage:ignore-start
      Utils.logPrintAnalytics(
          "$_isTrackingPermissionAllowed = Event Name - $eventName"); // coverage:ignore-line

      final formattedParams =
          eventParams.entries.map((e) => '\n  ${e.key}: ${e.value}').join();

      Utils.logPrintAnalytics('$formattedParams');
    } catch (e) {
      Utils.logPrintAnalytics(
          'Failed to log event: $e'); // coverage:ignore-line
    }
  }

  static Future<void> logEventButtonClick({
    String name = AnalyticsEventConst.EVENT_NAME_UI_INTERACTION,
    String btnName = "",
    Map<String, Object>? parameters,
  }) async {
    try {
      parameters = parameters ?? {};

      parameters["ui_element"] =
          btnName.isNotEmpty ? btnName : "unknown_button";

      // coverage:ignore-start
      logEvent(
          eventName: name,
          screenName: !parameters.containsKey("screen_name") ? AppRouter.router.state.path ?? "" : parameters["screen_name"].toString(),
          parameters: parameters);
      // coverage:ignore-end
    } catch (e) {
      Utils.logPrintAnalytics(
          'Failed to log event: $e'); // coverage:ignore-line
    }
  }

  /// Helper method to clean route path for better screen names
  static String cleanRoutePath(String routePath) {
    // Remove leading slash
    String cleaned =
        routePath.startsWith('/') ? routePath.substring(1) : routePath;

    // Handle empty or root path
    if (cleaned.isEmpty || cleaned == '/') {
      return 'home';
    }

    // Replace slashes with underscores for nested routes
    cleaned = cleaned.replaceAll('/', '_');
    cleaned = cleaned.replaceAll('-', '_');

    // Convert camelCase to snake_case for consistency
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)}_${match.group(2)?.toLowerCase()}',
    );

    return cleaned.toLowerCase();
  }

  /// Sets user property (e.g., user_role, language)
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    if (name.isEmpty || value.isEmpty) {
      return;
    }

    // EncryptDecryptService.encryptAES(value)
    try {
      await _analytics.setUserProperty(name: name, value: value);

      Utils.logPrintAnalytics(
          '$_isTrackingPermissionAllowed -- User Property Set: $name = $value');
    } catch (e) {
      Utils.logPrintAnalytics('Failed to set user property: $e');
    }
  }

  static Future<void> setUserid({
    required String userID,
  }) async {
    try {
      await _analytics.setUserId(id: userID);
    } catch (e) {
      Utils.logPrintAnalytics(
          '$_isTrackingPermissionAllowed -- Failed to set user property: $e');
    }
  }

  void onRouteChanged(String newRoute) {
    if (newRoute.isNullOrEmpty) {
      return;
    }
    // final newRoute = state.matchedLocation;
    // if (_currentRoute != newRoute) {
    //   _currentRoute = newRoute;

    logEvent(
        eventName: AnalyticsEventConst.EVENT_NAME_SCREEN_VIEW,
        screenName: newRoute);

    // logScreenViewEvent(screenName: newRoute);
    // } else {
    // Utils.logPrintAnalytics(
    //     '${_isTrackingPermissionAllowed} -- Route same ${_currentRoute} --- ${newRoute} --- ${previousPage}');
    // }
  }

  static Future<void> setAnalyticsEnableStatus(bool isEnable) async {
    _isTrackingPermissionAllowed = isEnable;
    await _analytics.setAnalyticsCollectionEnabled(isEnable);
    Utils.logPrintAnalytics(
        'setAnalyticsEnableStatus -- $isEnable '); // coverage:ignore-line
  }

  /// Fetches generic device/app information for analytics
  static Map<String, Object> getDeviceAnalyticsInfo(Map<String, Object>? info) {
    info = info ?? {};

    try {
      if (kIsWeb) {
        _addWebPlatformInfo(info);
      } else {
        _addMobilePlatformInfo(info);
        _addCommonDeviceInfo(info);
      }
    } catch (e) {
      Utils.logPrintAnalytics(
          'Failed to get device info: $e'); // coverage:ignore-line
    }

    return info;
  }

  /// Adds web platform specific information
  static void _addWebPlatformInfo(Map<String, Object> info) {
    info['platform'] = 'Web';
    info['os_version'] = 'N/A';
    info['device'] = 'N/A';
    info['device_model'] = 'N/A';
    info['device_category'] = 'Web';
    info['screen_resolution'] =
        '${window.physicalSize.width.toInt()}x${window.physicalSize.height.toInt()}';
  }

  /// Adds mobile platform specific information
  static void _addMobilePlatformInfo(Map<String, Object> info) {
    if (Platform.isAndroid) {
      _addAndroidPlatformInfo(info);
    } else if (Platform.isIOS) {
      _addIOSPlatformInfo(info);
    } else {
      info['platform'] = 'Unknown';
    }
  }

  /// Adds Android platform specific information
  static void _addAndroidPlatformInfo(Map<String, Object> info) {
    info['platform'] = 'Android';
    info['os_version'] = 'Android ${androidInfo?.version.release}';
    info['device'] = androidInfo?.brand ?? "";
    info['device_model'] = androidInfo?.model ?? "";
    info['device_category'] = device_category;
  }

  /// Adds iOS platform specific information
  static void _addIOSPlatformInfo(Map<String, Object> info) {
    info['platform'] = 'iOS';
    info['os_version'] = '${iosInfo?.systemVersion}';
    info['device'] = 'Apple';
    info['device_model'] = iosInfo?.utsname.machine ?? "";
    info['device_category'] = device_category;
  }

  /// Adds common device information for mobile platforms
  static void _addCommonDeviceInfo(Map<String, Object> info) {
    _addUserInfo(info);
    _addAppInfo(info);
    _addLanguageInfo(info);
    _addInteractionInfo(info);
    _addScreenResolutionInfo(info);
  }

  /// Adds user-related information
  static void _addUserInfo(Map<String, Object> info) {
    if (userAnalyticsId.isNotEmpty) {
      info['user_id'] = userAnalyticsId;
    }
    info['user_authenticated_state'] =
        userAnalyticsId.isNotEmpty ? "authenticated" : "non authenticated";
    info['user_state'] =
        userAnalyticsId.isNotEmpty ? "registered" : "anonymous";
  }

  /// Adds application-related information
  static void _addAppInfo(Map<String, Object> info) {
    info['build_version'] = packageInfo?.buildNumber ?? "";
    info['reffered_from'] = "direct";
  }

  /// Adds language-related information
  static void _addLanguageInfo(Map<String, Object> info) {
    info['language'] = userLanguage;
    info['language_code'] =
        languageRegionMap[userLanguage.toLowerCase()] ?? 'en-IN';
  }

  /// Adds interaction-related information
  static void _addInteractionInfo(Map<String, Object> info) {
    info['nonInteraction'] = nonInteraction ? "1" : "0";
    info['uiInteraction'] = nonInteraction ? "0" : "1";
    info['timestamp'] = DateTime.now().toUtc().toIso8601String();
  }

  /// Adds screen resolution information
  static void _addScreenResolutionInfo(Map<String, Object> info) {
    final window = WidgetsBinding.instance.platformDispatcher.views.first;
    info['screen_resolution'] =
        '${window.physicalSize.width.toInt()}x${window.physicalSize.height.toInt()}';
  }

  static Future<void> clearUserOnLogout() async {
    // Clear user ID
    await _analytics.setUserId(id: null);

    await _analytics.setUserProperty(name: 'aws_user_id', value: null);
    await _analytics.setUserProperty(name: 'aws_user_name', value: null);
    await _analytics.setUserProperty(name: 'aws_user_email', value: null);
    await _analytics.setUserProperty(name: 'user_role_companion', value: null);

    FirebaseAnalyticsService.userAnalyticsId = "";
  }

  static Map<String, Object> getFilteredDeviceAnalyticsInfo(
    Map<String, Object> deviceInfo,
    Map<String, Object>? parameters,
  ) {
    if (parameters == null) return deviceInfo;

    final filteredDeviceInfo = Map<String, Object>.from(deviceInfo)
      ..removeWhere((key, _) => parameters.containsKey(key));

    return filteredDeviceInfo;
  }
}

class AnalyticsEventConst {
  static const String EVENT_NAME_APP_OPEN = "app_opened";
  static const String EVENT_NAME_EXIT_SCREENVIEWED = "exit_screenviewed";
  static const String EVENT_NAME_SCREEN_VIEW = "app_screen_view";
  static const String EVENT_NAME_UI_INTERACTION = "ui_interaction";
  static const String EVENT_NAME_HOME_ITINERARY = "home_Itinerary";
  static const String EVENT_NAME_WALLET_CLICKED = "wallet_clicked";
  static const String EVENT_NAME_EVAASSISTANT_OPENED = "evaassistant_opened";
  static const String EVENT_NAME_EVAASSISTANT_SEARCHINITIATE =
      "evaassistant_searchinitiate";
  static const String EVENT_NAME_EVAASSISTANT_SCREENVIEWED =
      "evaassistant_screenviewed";
  static const String EVENT_NAME_ADD_ITINERARY =
      "itineraryCreation_addNewEventButton";
  static const String EVENT_NAME_RESGITRATION_FORM_START =
      "registration_form_start";
  static const String EVENT_NAME_RESGITRATION_FORM_SUBMIT =
      "registration_form_submit";
  static const String EVENT_NAME_RESGITRATION_SUCCESS = "registration_success";
  static const String EVENT_NAME_EMAIL_AUTH_SCREEN = "email_auth_screen";
  static const String EVENT_NAME_DYNAMIC_LINK_OPENED = "dynamiclink_app_opened";
  static const String EVENT_NAME_EMAIL_AUTH_ERROR = "email_auth_error";
  static const String EVENT_NAME_EMAIL_AUTH_SUCCESS = "email_auth_success";
  static const String EVENT_NAME_OTP_SCREENVIEW = "otp_screenview";
  static const String EVENT_NAME_OTP_VERIFICATIONERROR =
      "otp_verificationerror";
  static const String EVENT_NAME_OTP_VERIFICATIONSUCCESS =
      "otp_verificationsuccess";
  static const String EVENT_NAME_COMPANION_FORM_ERROR =
      "companionDetails_formerror";
  static const String EVENT_NAME_EDIT_COMPANION_FORM_ERROR =
      "editCompanion_formError";

  static const String FORM_ID_RESGITRATION = "form_registration_01";
  static const String FORM_NAME_RESGITRATION = "registration_page";
  static const String FORM_NAME = "form_name";
  static const String FORM_ID = "form_id";

  static const String PARAM_NAME_UI_ELEMENT = "ui_element";
  static const String PARAM_NAME_UI_ELEMENT_LOCATION = "ui_element_location";
  static const String PARAM_NAME_TILE_NAME = "tile_name";
  static const String PARAM_NAME_UI_ELEMENT_LABEL = "ui_element_label";
  static const String PARAM_NAME_SOURCE_SCREEN = "source_screen";
  static const String PARAM_NAME_FORM_NAME = "form_name";
  static const String PARAM_NAME_FORM_ID = "form_id";

  static const String ANALYTICS_AUTHENTICATED = "authenticated";
  static const String ANALYTICS_NON_AUTHENTICATED = "non_authenticated";
}
