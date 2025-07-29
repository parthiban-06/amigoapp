import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/validation.dart';

import '../../../custom_widgets/visa_custom_native_dialog.dart';
import '../../../generated/l10n.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/firebase_background_handler.dart';
import '../../../utils/utils.dart';
import '../../signup/model/user_model.dart';
import '../../splash_screen/repo/user_detail_repo.dart';

class RegisteredEmailModel extends BaseProvider {
  final formKey = GlobalKey<FormState>();

  bool isContinueButtonDisable = true;
  bool isLocalLanguageSupport = true;

  String? errorText;
  Locale? deviceLocal;
  TextEditingController emailTextController = TextEditingController();

  final UserDetailRepo splashScreenRepo = GetIt.I<UserDetailRepo>();

  Future<void> init(String? deeplinkEmail) async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    // Show analytics consent dialog

    isLoading = false;
    bool firstTime =
        await Preferences.getBool(Preferences.registerEmailFirstTime) ?? false;
    if (firstTime == false) {
      // set event
      FirebaseAnalyticsService.logEvent(
          eventName: AnalyticsEventConst.EVENT_NAME_EMAIL_AUTH_SCREEN);
      await Preferences.setBool(Preferences.registerEmailFirstTime, true);
    }
    emailTextController.text = deeplinkEmail ?? "";
    // validStateChange();
    deviceLocal = Localizations.localeOf(context);
    isLocalLanguageSupport = S.delegate.supportedLocales.contains(deviceLocal);

    FirebaseNotificationHandler().initializeFirebaseMessaging(context);
  }

  void navigateToLanguageSelectionScreen() {
    navGo(AppRoutes.languageselection);
  }

  validStateChange() {
    errorText = null;
    setState();

    if (Validation.emailValid.hasMatch(emailTextController.toTrimmedString())) {
      isContinueButtonDisable = false;
    } else {
      isContinueButtonDisable = true;
    }
    setState();
  }

  validate() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });

    if (Validation.emailValid.hasMatch(emailTextController.toTrimmedString())) {
      isContinueButtonDisable = false;
    } else {
      isContinueButtonDisable = true;
    }
    setState();
  }

  checkError(String error) {
    errorText = error;
    setState();

    Future.delayed(const Duration(milliseconds: 250), () {
      if (formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
  }

  backButton() {
    navPush(AppRoutes.signup);
  }

  continueButton() async {
    errorText = null;
    setState();
    await Future.delayed(const Duration(milliseconds: 150));
    if (!(formKey.currentState != null && formKey.currentState!.validate())) {
      return;
    }

    isLoading = true;

    final apiResponse = await splashScreenRepo?.getIsValidUser(
        emailTextController.toTrimmedString(),
        UserModel.fromJson,
        AppConst.USER_VALIDATION);

    if (apiResponse != null && apiResponse.isSuccess) {
      switch (apiResponse.messageKey) {
        case AppConst.VALID_USER: // open Login PAGE
        case AppConst.EXISTING_USER: // open Login PAGE
          FirebaseAnalyticsService.logEvent(
              eventName: AnalyticsEventConst.EVENT_NAME_EMAIL_AUTH_SUCCESS,
              parameters: {"ui_element": "txt_continue"});
          await Preferences.setBool(
              Preferences.isCompanion, apiResponse.data!.companion);
          if (apiResponse.data != null) {
            navPush(AppRoutes.login, extra: {"userModel": apiResponse.data});
          } else {
            UserModel userModel = UserModel();
            userModel.email = emailTextController.toTrimmedString();
            navGo(AppRoutes.login, extra: {"userModel": userModel});
          }

          emailTextController.clear();

          break;

        case AppConst.NEW_USER: // open signup page
        case AppConst.CREATE_USER: // open signup page
          FirebaseAnalyticsService.logEvent(
              eventName: AnalyticsEventConst.EVENT_NAME_EMAIL_AUTH_SUCCESS,
              parameters: {"ui_element": "txt_continue"});
          await Preferences.setBool(
              Preferences.isCompanion, apiResponse.data!.companion);
          if (apiResponse.data != null) {
            navPush(AppRoutes.signup, extra: apiResponse.data);
          }
          emailTextController.clear();

          break;

        case AppConst.INVALID_USER:
          Utils.logPrint("INVALID_USER ");
          checkError(Utils.getErrorMessageFromString(
              apiResponse.messageKey ?? "INVALID_USER"));
          break;
      }
    } else if (apiResponse != null) {
      checkError(Utils.getErrorMessageFromString(
          apiResponse.messageKey ?? "try_again_only",
          returnTryagain: true));
    }

    isLoading = false;
  }

  /// Shows analytics consent dialog
  Future<void> showAnalyticsConsentDialog() async {
    bool? analyticsTracking =
        await Preferences.getBoolWithNull(Preferences.keyAnalyticsTracking);

    if (analyticsTracking != null) {
      return;
    }
    final context = getContext();
    if (!context.mounted) return;

    await VisaNativeDialog.show(
      title: S.of(context).help_us_improve,
      context: context,
      linkText: S.of(context).learn_more,
      isWidgetSpan: true,
      message: S.of(context).allow_anonymous_analytics,
      onLinkTap: () async {
        final langCode =
            await Preferences.getString(Preferences.keyLanguageCode);
        final url =
            AppConst.privacyPolicies[langCode] ?? AppConst.privacyPolicyEN;
        if (!kIsWeb) {
          navPush(AppRoutes.webView,
              extra: {"url": url, "openWeb": true, "showVisaIcon": false});
        } else {
          Utils.openExternalApplication(url, "");
        }

        // https://www.visa.co.in/legal/global-privacy-notice.html
      },
      config: VisaDialogConfig(
        dialogRouteName: "analytics_dialog",
        positiveButtonText: S.of(context).allow,
        negativeButtonText: S.of(context).decline,
        onPositivePressed: () {
          // Handle analytics consent - allow
          Utils.logPrint("Analytics consent: Allowed");
          Preferences.setBool(Preferences.keyAnalyticsTracking, true);
          FirebaseAnalyticsService.setAnalyticsEnableStatus(true);
          FirebaseAnalyticsService.logEvent(
            eventName: "consent_granted",
            parameters: {
              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "allow",
            },
          );
          // You can add logic here to save the user's consent preference
        },
        onNegativePressed: () {
          // Handle analytics consent - decline
          Utils.logPrint("Analytics consent: Declined");
          Preferences.setBool(Preferences.keyAnalyticsTracking, false);
          FirebaseAnalyticsService.setAnalyticsEnableStatus(false);

          FirebaseAnalyticsService.logEvent(
            eventName: "consent_granted",
            parameters: {
              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "decline",
            },
          );
          // You can add logic here to save the user's consent preference
        },
        closeDialogPositiveClick: true,
        barrierDismissible: false,
      ),
    );
  }
}
