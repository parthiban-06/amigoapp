import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:app_links/app_links.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/snackbar.dart';
import 'package:visaamigo/features/home/model/version_response.dart';
import 'package:visaamigo/router/deeplink_handler.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/visa_custom_native_dialog.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes_const.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/device_security_service.dart';
import '../../../utils/responsive_util.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utils.dart';
import '../../select_languages/providers/language_selection_generic_provider.dart';
import '../../signup/model/user_model.dart';
import '../repo/user_detail_repo.dart';

class SplashScreenViewModel extends BaseProvider {
  final UserDetailRepo splashScreenRepo;

  SplashScreenViewModel({required this.splashScreenRepo});

  String? languageCode;
  bool isForAnalyticsBuild = true;
  bool inAppConfig = false;

  Future<void> init(String deepLinkEmail) async {
    Utils.logPrint("deepLinkEmail on Splash ${deepLinkEmail}");

    getAppConfig();

    languageCode = await Preferences.getString(Preferences.keyLanguageCode);

    Provider.of<SelectLanguageGenericProvider>(mContext, listen: false)
        .loadArbFile(languageCode ?? "en");

    FirebaseAnalyticsService.userLanguage =
        (languageCode.isNullOrEmpty) ? "en" : languageCode!;

    FirebaseAnalyticsService.logEvent(
        eventName: AnalyticsEventConst.EVENT_NAME_APP_OPEN,
        parameters: {AnalyticsEventConst.PARAM_NAME_SOURCE_SCREEN: "null"});

    // runAppFunctionliaty(deepLinkEmail);
    // Jailbreak / Root Check / isDeveloperMode
    // if (!kDebugMode && !kIsWeb) {
    //   await _performDeviceSecurityCheck(deepLinkEmail);
    // } else {
    //   runAppFunctionliaty(deepLinkEmail);
    // }
    runAppFunctionliaty(deepLinkEmail);
  }

  getAppConfig() async {
    if (inAppConfig) return;
    inAppConfig = true;
    if (Platform.isAndroid || Platform.isIOS) {
      final data = await splashScreenRepo.getAppVersion(
          VersionResponse.fromJson,
          Platform.isIOS ? AppConst.ios : AppConst.android);
      if (data != null && data.isSuccess && data.data != null) {
        bool val = Utils.compareVersions(
            FirebaseAnalyticsService.packageInfo!.version,
            data.data!.data.currentVersion);
        if (val == true) {
          await Future.delayed(const Duration(seconds: 2));
          BuildContext context = AmplifyService.context ?? getContext();
          if (context.mounted) {
            VisaNativeDialog.show(
              title: data.data!.data.cancel
                  ? S.of(context).update_available
                  : S.of(context).update_required,
              context: context,
              message: data.data!.data.cancel
                  ? S.of(context).a_newer_version_of_app
                  : S.of(context).you_need_to_update,
              config: VisaDialogConfig(
                positiveButtonText: S.of(context).update_now,
                barrierDismissible: false,
                negativeButtonText: data.data!.data.cancel
                    ? S.of(context).remind_me_later
                    : null,
                closeDialogPositiveClick: true,
                // false: value to stop default pop back
                onPositivePressed: () {},
                onNegativePressed: () {},
              ),
            );
          }
        }
      }
    }
  }

  Future<void> _handleDeepLink(AppLinks _appLinks) async {
    _appLinks.getLatestLink().then((uri) {
      if (uri != null) {
        Utils.logPrint('getLatestLink: $uri');

        DeepLinkHandler(uri);
        // _handleDeepLink(uri);
      }
    });
  }

  Future<void> runAppFunctionliaty(String deepLinkEmail) async {
    await Future.delayed(const Duration(milliseconds: 2000), () async {});
    await Preferences.setBool(Preferences.isWelcomeScreenSet, false);
    Preferences.setBool(Preferences.isGettingToKnowNavigation, false);
    Preferences.setBool(Preferences.isPromptListLoaded, false);
    await Preferences.removeKey(Preferences.keyAppConfig);

    final AppLinks _appLinks = AppLinks();
    final initialLink = await _appLinks.getInitialLinkString();

    if (_shouldHandleDeepLink(initialLink, deepLinkEmail)) {
      await _handleDeepLinkEntry(_appLinks);
      return;
    }

    final bool isLoggedin =
        await Preferences.getBool(Preferences.keyIsUserLoggedInOnce) ?? false;
    // final bool isBiometric =
    //     await Preferences.getBool(Preferences.enableBiometric);
    final AuthSession? userAuthSession =
        await amplifyService.checkIfSignedIn(getContext());

    if (_shouldNavigateLoggedIn(isLoggedin, userAuthSession)) {
      _navigateLoggedIn(isLoggedin, userAuthSession);
      return;
    }

    if (!_isNullOrEmpty(deepLinkEmail)) {
      await _handleUserValidation(deepLinkEmail);
      return;
    }

    await _handleLanguageOrDefault(isLoggedin);
  }

  bool _shouldHandleDeepLink(String? initialLink, String deepLinkEmail) {
    return initialLink != null &&
        _isNullOrEmpty(deepLinkEmail) &&
        !ResponsiveUtil.isWeb;
  }

  Future<void> _handleDeepLinkEntry(AppLinks appLinks) async {
    Utils.logPrint("_handleDeepLink ==  ${appLinks}");
    await _handleDeepLink(appLinks);
  }

  bool _shouldNavigateLoggedIn(bool isLoggedin, AuthSession? userAuthSession) {
    return isLoggedin && userAuthSession != null && userAuthSession.isSignedIn;
  }

  void _navigateLoggedIn(bool isLoggedin, AuthSession? userAuthSession) {
    if (kDebugMode) {
      navGo(AppRoutes.homeNav);
    } else {
      navGo(AppRoutes.login);
    }
  }

  bool _isNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  Future<void> _handleUserValidation(String deepLinkEmail) async {
    isLoading = true;
    final apiResponse = await splashScreenRepo.getIsValidUser(
        deepLinkEmail, UserModel.fromJson, AppConst.USER_VALIDATION);

    if (apiResponse != null && apiResponse.isSuccess) {
      await _handleApiResponse(apiResponse, deepLinkEmail);
    } else {
      final context = getContext();
      if (context.mounted) {
        snackBar(context, apiResponse?.error ?? S.of(context).invalid_user);
      }
    }
    isLoading = true;
  }

  Future<void> _handleApiResponse(
      dynamic apiResponse, String deepLinkEmail) async {
    Utils.logPrint("piResponse.messageKey [33m");
    switch (apiResponse.messageKey) {
      case AppConst.VALID_USER:
      case AppConst.EXISTING_USER:
        await _navigateToLogin(apiResponse, deepLinkEmail);
        break;
      case AppConst.NEW_USER:
      case AppConst.CREATE_USER:
        await _navigateToSignup(apiResponse, deepLinkEmail);
        break;
      case AppConst.INVALID_USER:
        await _navigateToRegisteredEmail(apiResponse, deepLinkEmail);
        break;
    }
  }

  Future<void> _navigateToLogin(
      dynamic apiResponse, String deepLinkEmail) async {
    if (apiResponse.data != null) {
      navPush(AppRoutes.login, extra: {"userModel": apiResponse.data});
    } else {
      UserModel userModel = UserModel();
      userModel.email = deepLinkEmail;
      navGo(AppRoutes.login, extra: {"userModel": userModel});
    }
  }

  Future<void> _navigateToSignup(
      dynamic apiResponse, String deepLinkEmail) async {
    FirebaseAnalyticsService.logEvent(
        eventName: AnalyticsEventConst.EVENT_NAME_DYNAMIC_LINK_OPENED,
        parameters: {"is_first_time_user": true});
    if (apiResponse.data != null) {
      navPush(AppRoutes.signup, extra: apiResponse.data);
    } else {
      UserModel userModel = UserModel();
      userModel.email = deepLinkEmail;
      navGo(AppRoutes.signup, extra: userModel);
    }
  }

  Future<void> _navigateToRegisteredEmail(
      dynamic apiResponse, String deepLinkEmail) async {
    navGo(AppRoutes.registeredEmail, extra: deepLinkEmail);
    final context = getContext();
    if (context.mounted) {
      snackBar(context,
          Utils.getErrorMessageFromString(apiResponse.messageKey ?? ""));
    }
  }

  Future<void> _handleLanguageOrDefault(bool isLoggedin) async {
    if (languageCode.isNullOrEmpty) {
      Locale deviceLocal = Localizations.localeOf(getContext());
      if (S.delegate.supportedLocales.contains(deviceLocal)) {
        final context = getContext();
        if (context.mounted) {
          Provider.of<SelectLanguageGenericProvider>(context, listen: false)
              .setLanguage(deviceLocal.languageCode);
        }
        await Preferences.setString(
            Preferences.keyLanguageCode, deviceLocal.languageCode);
        navGo(AppRoutes.registeredEmail);
      } else {
        navGo(AppRoutes.languageselection);
      }
    } else if (isLoggedin) {
      navGo(AppRoutes.login);
    } else {
      navGo(AppRoutes.registeredEmail);
    }
  }

  /// Performs device security checks using native method channels
  /// Checks for rooted/jailbroken devices and developer mode
  Future<void> _performDeviceSecurityCheck(String deepLinkEmail) async {
    try {
      Utils.logPrint("Performing device security check...");

      final securityResult = await _getSecurityCheckResult();
      await _handleSecurityCheckResult(securityResult, deepLinkEmail);
    } catch (e) {
      Utils.logPrint("Error during device security check: $e");
      _handleSecurityCheckError(deepLinkEmail);
    }
  }

  /// Retrieves security check result from native service
  Future<Map<String, dynamic>> _getSecurityCheckResult() async {
    final securityResult = await DeviceSecurityService.performSecurityCheck();

    final bool isCompromised = securityResult['isCompromised'] ?? false;
    final bool isDeveloperMode = securityResult['isDeveloperMode'] ?? false;
    final bool isSecure = securityResult['isSecure'] ?? true;
    final String platform = securityResult['platform'] ?? 'unknown';

    Utils.logPrint(
        "Security check result - Compromised: $isCompromised, Developer Mode: $isDeveloperMode, Secure: $isSecure, Platform: $platform");

    return {
      'isCompromised': isCompromised,
      'isDeveloperMode': isDeveloperMode,
      'isSecure': isSecure,
      'platform': platform,
    };
  }

  /// Handles the security check result and takes appropriate action
  Future<void> _handleSecurityCheckResult(
      Map<String, dynamic> securityResult, String deepLinkEmail) async {
    final bool isCompromised = securityResult['isCompromised'] ?? false;
    final bool isDeveloperMode = securityResult['isDeveloperMode'] ?? false;
    final bool isSecure = securityResult['isSecure'] ?? true;

    if (isCompromised) {
      await _handleCompromisedDevice();
      return;
    }

    if (isDeveloperMode) {
      await _handleDeveloperModeEnabled();
      return;
    }

    if (isSecure) {
      _handleSecureDevice(deepLinkEmail);
    } else {
      _handleInsecureDevice();
    }
  }

  /// Handles compromised device (rooted/jailbroken)
  Future<void> _handleCompromisedDevice() async {
    Utils.logPrint(
        "Device is compromised (rooted/jailbroken) - blocking access");

    await VisaNativeDialog.show(
      title: S.of(mContext).unsupported_device_detected,
      context: mContext,
      message: S.of(mContext).unsupported_device_description,
      config: _getSecurityDialogConfig(),
    );
  }

  /// Handles developer mode enabled
  Future<void> _handleDeveloperModeEnabled() async {
    Utils.logPrint("Developer mode is enabled - blocking access");

    await VisaNativeDialog.show(
      title: S.of(mContext).unsupported_device_detected,
      context: mContext,
      message: S.of(mContext).developer_mode_description,
      config: _getSecurityDialogConfig(),
    );
  }

  /// Handles secure device - continues with app functionality
  void _handleSecureDevice(String deepLinkEmail) {
    Utils.logPrint(
        "Device security check passed - continuing with app functionality");
    runAppFunctionliaty(deepLinkEmail);
  }

  /// Handles insecure device - blocks access
  void _handleInsecureDevice() {
    Utils.logPrint("Device security check failed - blocking access");
    // Stop further execution
  }

  /// Handles security check errors - assumes device is secure
  void _handleSecurityCheckError(String deepLinkEmail) {
    Utils.logPrint(
        "Security check error - assuming device is secure and continuing");
    runAppFunctionliaty(deepLinkEmail);
  }

  /// Creates a standardized security dialog configuration
  VisaDialogConfig _getSecurityDialogConfig() {
    return VisaDialogConfig(
      positiveButtonText: S.of(mContext).ok,
      barrierDismissible: false,
      closeDialogPositiveClick: false,
      onPositivePressed: () async {
        SystemNavigator.pop(); // Exit the app
      },
    );
  }
}

Future<void> requestIosTrackingPermission() async {
  final result = await AppTrackingTransparency.requestTrackingAuthorization();
  Utils.logPrint('Tracking permission: $result');

  await Preferences.setBool(
      Preferences.keyAnalyticsTracking, (result == TrackingStatus.authorized));

  await FirebaseAnalyticsService.setAnalyticsEnableStatus(
      (result == TrackingStatus.authorized));
}
