import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart' hide AnalyticsEvent;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/features/profile/model/faq_model.dart';
import 'package:visaamigo/features/profile/model/send_email_response_model.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/utils/date_util.dart';
import 'package:visaamigo/utils/shared_preferences.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/visa_custom_native_dialog.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes_const.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/app_const.dart';
import '../../../utils/utils.dart';
import '../../home/providers/navigation_provider.dart';
import '../../itinerary/providers/itinerary_provider.dart';

class ProfileViewModel extends BaseProvider {
  UserModel? userModel;
  FaqResponse? faqResponse;
  MfaType? myMFA;
  bool mfa = false;
  bool dateTime24Hrs = false;
  bool analyticsConcern = false;
  bool biometrics = false;
  bool showBiometrics = true;
  bool notificationPermission = false;
  bool showWallet = true;
  bool listCompanion = true;
  bool isCompanion = false;
  UserDetailRepo? userDetailRepo;
  UserGenericProvider? genericUserProvider;

  bool showCompanion = true;

  Duration snackbarDuration = const Duration(seconds: 1);

  GlobalKey notificationSectionKey = GlobalKey();

  Future<void> init() async {
    genericUserProvider =
        Provider.of<UserGenericProvider>(mContext, listen: false);
    mfa = await Preferences.getBool(Preferences.enableMfa);
    showWallet = await Preferences.getBool(Preferences.isWallet);
    isCompanion = await Preferences.getBool(Preferences.isCompanion);
    listCompanion = await Preferences.getBool(Preferences.listCompanion);
    analyticsConcern =
        await Preferences.getBool(Preferences.keyAnalyticsTracking);
    userModel = await Preferences.getModelData(
        Preferences.KeyUserModel, UserModel.fromJson);
    userDetailRepo = UserDetailRepo(apiClient);
    final LocalAuthentication auth = LocalAuthentication();
    if (kIsWeb == false && await auth.isDeviceSupported()) {
      showBiometrics = true;
      biometrics = await Preferences.getBool(Preferences.enableBiometric);
    } else {
      showBiometrics = false;
    }

    // Show companion option if user has match details with data, or if no match details exist
    final hasMatchDetails = genericUserProvider?.userMatchDetail != null;
    final hasMatchData = hasMatchDetails &&
        genericUserProvider?.userMatchDetail!.data.isNotEmpty == true;

    showCompanion = !hasMatchDetails || hasMatchData;

    notificationPermission =
        await Preferences.getBool(Preferences.isNotificationPermissionEnable) ??
            false;

    dateTime24Hrs = DateUtil.is24Time;

    Utils.logPrint("showCompanion ${showCompanion}");
    setState();
  }

  getCompanionScreen() async {
    final userProvider =
        Provider.of<UserGenericProvider>(getContext(), listen: false);

    final bool hasListCompanion = userProvider.listCompanion;

    final String uiElement =
        hasListCompanion ? "companion_details" : "add_companion";
    const String uiElementLocation = "profile";

    if (!hasListCompanion) {
      FirebaseAnalyticsService.logEvent(
        eventName: "addYourCompanion_interaction",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: uiElement,
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: uiElementLocation,
        },
      );
    }

    final String route =
        hasListCompanion ? AppRoutes.listCompanion : AppRoutes.addCompanion;
    final dynamic rep = await navPush(route);

    if (hasListCompanion) {
      if (rep == false) {
        isCompanion = false;
        userProvider.updateCompanion(false);
        setState();
      }
    } else {
      if (rep == true) {
        isCompanion = true;
        userProvider.updateCompanion(true);
        setState();
      }
    }
  }

  navFaq() {
    navPush(AppRoutes.faq);
  }

  Future<void> toggleNotificationPermission(bool newValue) async {
    final context = getContext();

    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    final isGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized;

    if (!isGranted && newValue) {
      // Permission not granted but user tried to enable it — open settings
      Utils.showCustomDialog(
        context: context,
        config: CustomDialogConfig(
          title: S.of(context).push_notifications,
          description: S.of(context).enable_push_notiifcation,
          cancelText: S.of(context).cancel,
          confirmText: S.of(context).open_setting,
          dialogRouteName: "push_notifications_dialog",
          onConfirm: () async => openAppSettings(),
          onCancel: () {},
        ),
      );
      return;
    }

    notificationPermission = newValue;
    await Preferences.setBool(
        Preferences.isNotificationPermissionEnable, notificationPermission);

    visaSnackBar(
      context: context,
      title: "${S.of(context).success}!",
      type: SnackBarType.success,
      duration: snackbarDuration,
      subtitle: notificationPermission
          ? S.of(context).notifications_enable_success
          : S.of(context).notifications_disable_success,
    );

    setState();
  }

  changeNotificationPermission() async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    bool isGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized;

    Utils.logPrint("isGranted $isGranted");

    if (isGranted) {
      notificationPermission = !notificationPermission;
    } else {
      await Permission.notification.request();
      isGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized;
      notificationPermission = isGranted;

      if (!isGranted) {
        Utils.showCustomDialog(
            context: context,
            config: CustomDialogConfig(
              title: S.of(context).push_notifications,
              description: S.of(context).enable_push_notiifcation,
              cancelText: S.of(context).cancel,
              confirmText: S.of(context).open_setting,
              dialogRouteName: "push_notifications_dialog",
              onConfirm: () async {
                // Handle confirmation
                openAppSettings();
              },
              onCancel: () {},
            ));
      }
    }

    // notificationPermission = !notificationPermission;
    await Preferences.setBool(
        Preferences.isNotificationPermissionEnable, notificationPermission);

    if (isGranted) {
      visaSnackBar(
          context: context,
          title: "${S.of(context).success}!",
          type: SnackBarType.success,
          duration: snackbarDuration,
          subtitle: notificationPermission
              ? S.of(context).notifications_enable_success
              : S.of(context).notifications_disable_success);
    }

    setState();
  }

  changeMFA() async {
    final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
    isLoading = true;
    if (mfa) {
      mfa = false;
      setState();
      await cognitoPlugin.updateMfaPreference(
        sms: MfaPreference.disabled,
        email: MfaPreference.disabled,
      );
      await Preferences.setBool(Preferences.enableMfa, false);
    } else {
      mfa = true;
      setState();
      await cognitoPlugin.updateMfaPreference(
        sms: MfaPreference.disabled,
        email: MfaPreference.enabled,
      );
      await Preferences.setBool(Preferences.enableMfa, true);
    }

    isLoading = false;

    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();
    if (context.mounted) {
      visaSnackBar(
          context: context,
          title: "${S.of(context).success}!",
          type: SnackBarType.success,
          duration: snackbarDuration,
          subtitle: mfa
              ? S.of(context).mfa_enable_success
              : S.of(context).mfa_disable_success);
    }
    updateMFA();
    setState();
  }

  Future<void> updateMFA() async {
    // ⚠️ API currently expects query parameters instead of body — to be fixed later
    final emptyBody = <String, dynamic>{};

    final langCode = await Preferences.getString(Preferences.keyLanguageCode);

    final response = await userDetailRepo?.sendEmail(
      emptyBody,
      SendEmailResponse.fromJson,
      AppConst.mfaUpdate,
      langCode,
    );

    if (response?.isSuccess == true && response?.data != null) {
      // TODO: Handle success case here (e.g., show toast, navigate, etc.)
    }
  }

  update24hoursDateTime() {
    dateTime24Hrs = !dateTime24Hrs;
    DateUtil.is24Time = dateTime24Hrs;
    Provider.of<UserGenericProvider>(getContext(), listen: false)
        .is24hrsClockEnable = dateTime24Hrs;
    Preferences.setBool(Preferences.KeyIs24Time, dateTime24Hrs);

    visaSnackBar(
        context: getContext(),
        title: "${S.of(getContext()).success}!",
        type: SnackBarType.success,
        duration: snackbarDuration,
        subtitle: dateTime24Hrs
            ? S.of(getContext()).success_24hrs_clock
            : S.of(getContext()).disable_24hrs_clock);

    setState();
  }

  updateAnalyticsConcern(bool value) async {
    analyticsConcern = value;
    Preferences.setBool(Preferences.keyAnalyticsTracking, analyticsConcern);

    FirebaseAnalyticsService.setAnalyticsEnableStatus(analyticsConcern);

    visaSnackBar(
        context: getContext(),
        title: "${S.of(getContext()).success}!",
        type: SnackBarType.success,
        duration: snackbarDuration,
        subtitle: S.of(getContext()).analytics_consent_success);

    setState();
  }

  changeBiometrics() async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    if (biometrics) {
      await _disableBiometrics(context);
    } else {
      await _enableBiometrics(context);
    }
  }

  Future<void> _disableBiometrics(BuildContext context) async {
    biometrics = false;
    setState();
    await Preferences.setBool(Preferences.enableBiometric, false);

    if (context.mounted) {
      _showBiometricSuccessSnackBar(
          context, S.of(context).biometric_disable_success);
    }
  }

  Future<void> _enableBiometrics(BuildContext context) async {
    final rep = await Utils.enableBioMetrics();
    Utils.logPrint("rep enableBioMetrics [33m$rep[0m");

    if (rep) {
      if (context.mounted) {
        await _handleSuccessfulBiometricEnable(context);
      }
    } else {
      if (context.mounted) {
        await _handleFailedBiometricEnable(context);
      }
    }
  }

  Future<void> _handleSuccessfulBiometricEnable(BuildContext context) async {
    biometrics = true;
    setState();
    await Preferences.setBool(Preferences.enableBiometric, true);

    if (context.mounted) {
      _showBiometricSuccessSnackBar(
          context, S.of(context).biometric_enable_success);
    }
  }

  Future<void> _handleFailedBiometricEnable(BuildContext context) async {
    if (kIsWeb) {
      return;
    }

    final supportedBiometricsType = await Utils.getSupportedBiometric();

    if (context.mounted) {
      _showBiometricSettingsDialog(context, supportedBiometricsType);
    }
  }

  void _showBiometricSuccessSnackBar(BuildContext context, String message) {
    visaSnackBar(
      context: context,
      duration: snackbarDuration,
      title: "${S.of(context).success}!",
      type: SnackBarType.success,
      subtitle: message,
    );
  }

  void _showBiometricSettingsDialog(
      BuildContext context, BiometricType? biometricType) {
    final description = _getBiometricDescription(context, biometricType);

    Utils.showCustomDialog(
      context: context,
      config: CustomDialogConfig(
        title: S.of(context).enable_bio,
        description: description,
        cancelText: S.of(context).cancel,
        confirmText: S.of(context).open_setting,
        dialogRouteName: "enable_biometirc_dialog",
        onConfirm: () async {
          openAppSettings();
        },
        onCancel: () {},
      ),
    );
  }

  String _getBiometricDescription(
      BuildContext context, BiometricType? biometricType) {
    if (biometricType == BiometricType.face) {
      return S.of(context).user_decline_biometrics;
    } else if (biometricType == BiometricType.fingerprint) {
      return S.of(context).user_decline_biometrics_android;
    }
    return "";
  }

  logout() async {
    VisaNativeDialog.show(
      title: S.of(mContext).logout,
      context: mContext,
      message: S.of(mContext).logout_confirmation,
      config: _getLogoutDialogConfig(),
    );
  }

  VisaDialogConfig _getLogoutDialogConfig() {
    return VisaDialogConfig(
      positiveButtonText: S.of(mContext).logout,
      negativeButtonText: S.of(mContext).cancel,
      barrierDismissible: false,
      closeDialogPositiveClick: false,
      onNegativePressed: () async {
        FirebaseAnalyticsService.logEventButtonClick(btnName: "cancel");
      },
      onPositivePressed: () async {
        FirebaseAnalyticsService.logEventButtonClick(btnName: "logout");
        isLoading = true;
        setState();
        Provider.of<ItineraryProvider>(mContext, listen: false)
            .resetCalendarState();

        Provider.of<UserGenericProvider>(mContext, listen: false)
            .resetPackageDetails();

        await Utils.logoutUser();
        FirebaseAnalyticsService.logEvent(eventName: "accountlogout_success");
        isLoading = false;
        setState();
      },
    );
  }

  void goToPrivacyPolicy() async {
    final langCode = await Preferences.getString(Preferences.keyLanguageCode);
    final url = AppConst.privacyPolicies[langCode] ?? AppConst.privacyPolicyEN;
    if (!kIsWeb) {
      navPush(AppRoutes.webView,
          extra: {"url": url, "openWeb": true, "showVisaIcon": false});
    } else {
      Utils.openExternalApplication(url, "");
    }
  }

  void goToTermAndCondition() {
    navPush(AppRoutes.webView,
        extra: {"url": AppConst.TERMS_AND_CONDITIONS, "openWeb": false});
  }

  ticketSupportRedirect() async {
    String ln = await Preferences.getString(Preferences.keyLanguageCode);
    navPush(AppRoutes.redirecting, extra: {
      "url": AppConst.ticketSupport(ln),
      "deeplink": "",
      "openInternalBrowser": true,
      "bottomMessage": S.of(getContext()).you_are_being_to_ticket,
    });
  }

  bookingSupportRedirect() async {
    String ln = await Preferences.getString(Preferences.keyLanguageCode);
    navPush(AppRoutes.redirecting, extra: {
      "url": AppConst.bookingSupport(ln),
      "deeplink": "",
      "openInternalBrowser": true,
      "bottomMessage": S.of(getContext()).you_are_being,
    });
  }

  prepaidSupportRedirect() async {
    String ln = await Preferences.getString(Preferences.keyLanguageCode);
    navPush(AppRoutes.redirecting, extra: {
      "url": AppConst.prepaidSupport(ln),
      "deeplink": "",
      "openInternalBrowser": true,
      "bottomMessage": S.of(getContext()).you_are_being_to_prepaid,
    });
  }

  Future<void> navigateToDeleteAccount() async {
    final result = await navPush(AppRoutes.deleteAccount);

    if (result != null) {
      // Handle the result returned from DeleteAccount page
      final currentContext = notificationSectionKey.currentContext;
      if (currentContext != null && (currentContext as Element).mounted) {
        Scrollable.ensureVisible(
          currentContext,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        debugPrint("notificationSectionKey context is null or not mounted!");
      }
    }
  }

  void reWatchIntro(NavigationProvider navigationBar) {
    Preferences.setBool(Preferences.isGettingToKnowNavigation, true);
    Preferences.removeKey(Preferences.isGettingToKnowDone);
    navPush(AppRoutes.aiAssistantWelcomeScreen);
  }

  void reWatchTutorial(NavigationProvider navigationBar) {
    Preferences.setBool(Preferences.tutorialStatus, false);
    Preferences.setBool(Preferences.tutorialEvaScreenStatus, false);
    Preferences.setBool(Preferences.isComeFromReWatchHomeTutorial, true);
    Preferences.setBool(Preferences.isComeFromReWatchEVATutorial, true);

    // String uiElementLocation = "registration"; //analytics key

    navigationBar.goBranch(0, loadInitial: true);
  }
}
