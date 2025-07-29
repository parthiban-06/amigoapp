import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/custom_widgets/visa_custom_native_dialog.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/shared_preferences.dart';

import '../../../custom_widgets/snackbar.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/app_const.dart';
import '../../../utils/utils.dart';
import '../../ai_assistant/providers/ai_assistant_main_provider.dart';
import '../../home/model/match_details.dart';
import '../../profile/model/send_email_response_model.dart';
import '../../profile/provider/user_generic_detail_provider.dart';
import '../../rate_us/model/user_visit_model.dart';
import '../../signup/model/user_model.dart';
import '../../splash_screen/repo/user_detail_repo.dart';
import '../../wallet/model/wallet_model.dart';

class ConfirmCodeModel extends BaseProvider {
  final formKey = GlobalKey<FormState>();
  Timer? _timer;
  bool canSendOtp = true;

  TextEditingController code = TextEditingController();

  bool pageLoad = false;
  bool isSignUp = false;
  bool checkBoxMFA = false;
  bool codeSent = false;
  bool isDisableField = false;
  UserModel? userModel;
  bool showError = false;

  int _resendCodeDuration = 30;
  int duration = 30;

  UserDetailRepo? userDetailRepo;
  String? errorText;

  AiAssistantMainProvider? aiAssistantMainProvider;

  validStateChange() {
    errorText = null;
    showError = true;
    setState();
  }

  onShowError() {
    showError = true;
    setState();
  }

  mfaCheckBoxChange() {
    checkBoxMFA = !checkBoxMFA;
    setState();
  }

  validate() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (showError == true && formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
  }

  void startCountdown() async {
    if (formKey.currentState != null) {
      formKey.currentState!.reset();
    }
    code.text = "";
    showError = false;
    setState();
    await resendCode();
    duration = _resendCodeDuration;
    canSendOtp = false;
    codeSent = true;
    setState();
    Future.delayed(const Duration(milliseconds: 5000), () {
      codeSent = false;
      setState();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (duration > 0) {
        duration = duration - 1;
      } else {
        canSendOtp = true;
        _timer?.cancel();
      }
      setState();
    });

    setState();
  }

  checkError(String? error) {
    showError = true;
    errorText = error;
    setState();

    Future.delayed(const Duration(milliseconds: 250), () {
      if (formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
  }

  void init(UserModel? userModel) async {
    setState();
    this.userModel = userModel;
    userDetailRepo = UserDetailRepo(apiClient);
    isSignUp = await Preferences.getBool(Preferences.isSignUp);
    aiAssistantMainProvider =
        Provider.of<AiAssistantMainProvider>(getContext(), listen: false);
    FirebaseAnalyticsService.logEvent(
        eventName: AnalyticsEventConst.EVENT_NAME_OTP_SCREENVIEW,
        parameters: {
          "ui_element_location": isSignUp ? "registration" : "login"
        });
    setState();
  }

  signInUser() async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    await amplifyService.signInUser(
        context: context,
        username: userModel?.email,
        userLanguage: await Preferences.getString(Preferences.keyLanguageCode),
        password: userModel?.passowrd);

    await amplifyService.getCurrentUser();

    await createUser();

    if (userModel != null) {
      await Preferences.setModelData(
          Preferences.KeyUserModel, userModel!.toJson());
      await Preferences.setBool(Preferences.keyIsUserLoggedInOnce, true);
      // Load App Configuration
      // await aiAssistantMainProvider.getAppConfiguration();
    }
    isDisableField = true;

    FirebaseAnalyticsService.logEvent(
        eventName: AnalyticsEventConst.EVENT_NAME_OTP_VERIFICATIONSUCCESS,
        parameters: {
          "ui_element": "txt_continue",
          "ui_element_location": "registration",
        });

    /* */
    if (!kIsWeb) {
      isLoading = false;
      if (context.mounted) {
        loadBiometricDialog();
      }
    } else {
      await amplifyService.setupMFA(checkBoxMFA);
      isLoading = false;
      if (context.mounted) {
        loadHomePage();
      }
    }
    // navGo(AppRoutes.mfa);
  }

  confirmCodeButton() async {
    showError = true;
    errorText = null;
    setState();
    await Future.delayed(const Duration(milliseconds: 150));
    if (!(formKey.currentState != null && formKey.currentState!.validate())) {
      return;
    }
    isSignUp = await Preferences.getBool(Preferences.isSignUp);

    Utils.logPrint("isSignUp ${isSignUp}");

    if (isSignUp) {
      isLoading = true;
      signUp();
    } else {
      isLoading = true;
      // Capture context before async operations to avoid BuildContext across async gaps
      final context = getContext();
      final rep =
          await amplifyService.confirmSignIn(context: context, code: code.text);

      if (rep != null && rep.isSuccess) {
        await amplifyService.getCurrentUser();
        await Preferences.setBool(Preferences.keyIsUserLoggedInOnce, true);

        var results = await Future.wait([
          amplifyService.getUserEmail(),
          amplifyService.getUserGivenName(),
          amplifyService.getUserFamilyName(),
        ]);

        userModel = UserModel();
        userModel?.email = results[0] ?? "";
        userModel?.firstName = results[1] ?? "";
        userModel?.lastName = results[2] ?? "";
        await Preferences.setModelData(
            Preferences.KeyUserModel, userModel!.toJson());
        // Load App Configuration
        // await aiAssistantMainProvider.getAppConfiguration();
        /*  if (await Utils.isBioMetricsSupported()) {
          navGo(AppRoutes.homeNav);
        } else {
          navGo(AppRoutes.biometric);
        }*/
        isLoading = false;
        FirebaseAnalyticsService.logEvent(
            eventName: AnalyticsEventConst.EVENT_NAME_OTP_VERIFICATIONSUCCESS,
            parameters: {
              "ui_element": "txt_continue",
              "ui_element_location": "login"
            });
        FirebaseAnalyticsService.logEvent(
            eventName: "login_success",
            parameters: {
              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "txt_continue",
              "ui_element_location": "login"
            });
        loadHomePage();
      } else {
        checkError(rep?.error ?? "");
        isLoading = false;
      }
    }
  }

  Future<void> createUser() async {
    isLoading = true;

    String languageCode =
        await Preferences.getString(Preferences.keyLanguageCode);

    userModel?.userId = amplifyService.currentUser?.userId ?? "";
    userModel?.id = amplifyService.currentUser?.userId ?? "";
    userModel?.termsAccepted = true;
    userModel?.preferredLanguage = (languageCode.isEmpty) ? "en" : languageCode;
    userModel?.settings = Settings();
    userModel?.userPreferences = UserPreferences();

    var results = await Future.wait([
      amplifyService.getUserEmail(),
      amplifyService.getUserGivenName(),
      amplifyService.getUserFamilyName(),
    ]);

    userModel?.email = results[0] ?? "";
    userModel?.firstName = results[1] ?? "";
    userModel?.lastName = results[2] ?? "";

    final response = await userDetailRepo?.saveUserDetail(
        userModel!.toAwsJson(), UserModel.fromJson);

    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();
    if (context.mounted) {
      Provider.of<UserGenericProvider>(context, listen: false)
          .setUserModel(userModel);
    }

    final apiResponse = await userDetailRepo?.getUserInfo(
        UserModel.fromJson, AppConst.USER_PROFILES);

    FirebaseAnalyticsService.userAnalyticsId =
        apiResponse?.data?.userAnalyticsId ?? "";

    isLoading = false;
  }

  signUp() async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();
    final rep = await amplifyService.confirmSignUpUser(
        context: context, username: userModel?.email, code: code.text);

    if (rep.data != null && rep.data.isSignUpComplete) {
      await signInUser();
    } else {
      checkError(rep.error ?? "");
      isLoading = false;
    }
  }

  resendCode() async {
    isLoading = true;
    isSignUp = await Preferences.getBool(Preferences.isSignUp);

    FirebaseAnalyticsService.logEvent(
        eventName: AnalyticsEventConst.EVENT_NAME_UI_INTERACTION,
        parameters: {
          "ui_element": "reSend_code",
          "ui_element_location": isSignUp ? "registration" : "login"
        });

    if (isSignUp) {
      // Capture context before async operations to avoid BuildContext across async gaps
      final context = getContext();
      final rep = await amplifyService.resendSignUpCode(
          context: context,
          username: await Preferences.getString(Preferences.email));

      if (rep.statusCode == AmplifyService.AMPLIFY_SUCCESS) {
        isLoading = false;
        // Capture context before async operations
        final context = getContext();
        if (context.mounted) {
          snackBar(context, S.of(context).code_send);
        }
      } else {
        checkError(rep.error ?? "");
        canSendOtp = true;
        _timer?.cancel();
        isLoading = false;
        setState();
      }
    } else {
      // checkError(null);
      await amplifyService.signOutUser();

      // Capture context before async operations to avoid BuildContext across async gaps
      final context = getContext();
      final rep = await amplifyService.signInUser(
          context: context,
          username: userModel?.email,
          userLanguage:
              await Preferences.getString(Preferences.keyLanguageCode),
          password: userModel?.passowrd);

      if (rep.isSuccess) {
        isLoading = false;
      } else {
        checkError(rep.error ?? "");
        canSendOtp = true;
        _timer?.cancel();
        isLoading = false;
      }
      setState();
    }
  }

  void loadHomePage() async {
    isLoading = true;
    setState();
    await amplifyService.getCurrentUser();
    await getWalletApi();
    await getMatchApi();
    await aiAssistantMainProvider?.getAppConfiguration();
    await getUserPreference();

    bool isGettingToKnowDone =
        await Preferences.getBool(Preferences.isGettingToKnowDone);
    isLoading = false;
    setState();

    final route = (!isGettingToKnowDone &&
            aiAssistantMainProvider?.isAllStepsNavEnabled == true)
        ? AppRoutes.aiAssistantWelcomeScreen
        : AppRoutes.homeNav;

    navGo(route);
  }

  Future<void> loadBiometricDialog() async {
    final context = getContext();

    if (Platform.isIOS) {
      await _handleIOSBiometric(context);
    } else {
      await _handleAndroidBiometric(context);
    }
  }

  Future<void> _handleIOSBiometric(BuildContext context) async {
    final rep = await Utils.enableBioMetrics();
    if (rep) {
      await _setBiometricPreferences(true);
    }

    if (context.mounted) {
      loadMFADialog();
    }
  }

  Future<void> _handleAndroidBiometric(BuildContext context) async {
    if (!context.mounted) return;

    VisaNativeDialog.show(
      context: context,
      title: S.of(context).enable_biometric,
      message: S.of(context).get_faster_access,
      config: VisaDialogConfig(
        positiveButtonText: S.of(context).enable,
        negativeButtonText: S.of(context).skip,
        barrierDismissible: false,
        onPositivePressed: () => _onBiometricEnable(context),
        onNegativePressed: () => _onBiometricSkip(context),
      ),
    );
  }

  Future<void> _onBiometricEnable(BuildContext context) async {
    final rep = await Utils.enableBioMetrics();
    if (rep) {
      await _setBiometricPreferences(true);
    }

    if (context.mounted) {
      loadMFADialog();
    }
  }

  Future<void> _onBiometricSkip(BuildContext context) async {
    await _setBiometricPreferences(false);

    if (context.mounted) {
      loadMFADialog();
    }
  }

  Future<void> _setBiometricPreferences(bool enabled) async {
    await Preferences.setBool(Preferences.enableBiometric, enabled);
    await Preferences.setBool(Preferences.isBiometricsSetupProgress, true);
  }

  void loadMFADialog() {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();
    if (!context.mounted) return;

    /* VisaNativeDialog.show(
      title: (Theme.of(context).platform == TargetPlatform.iOS)
          ? S.of(context).enable_biometric
          : S.of(context).enable_biometric,
      context: context,
      message: S.of(context).get_faster_access,
      positiveButtonText: S.of(context).enable,
      negativeButtonText: S.of(context).skip,
      barrierDismissible: false,
      onPositivePressed: () async {
        // Handle confirmation

        final rep = await Utils.enableBioMetrics();
        if (rep) {
          await Preferences.setBool(Preferences.enableBiometric, true);

          await Preferences.setBool(
              Preferences.isBiometricsSetupProgress, true);
        }

        loadHomePage();
      },
      onNegativePressed: () async {
        await Preferences.setBool(Preferences.enableBiometric, false);

        await Preferences.setBool(Preferences.isBiometricsSetupProgress, true);

        loadHomePage();
      },
    );*/

    VisaNativeDialog.show(
      context: context,
      title: S.of(context).mfa_auth,
      message: S.of(context).help_protect_your_acc,
      config: VisaDialogConfig(
        positiveButtonText: S.of(context).enable,
        negativeButtonText: S.of(context).skip,
        barrierDismissible: false,
        onPositivePressed: () async {
          // Handle confirmation
          isLoading = true;
          setState();
          await amplifyService.setupMFA(true);
          updateMFA();
          setState();
          isLoading = false;
          // loadHomePage();
          if (context.mounted) {
            loadHomePage();
          }
        },
        onNegativePressed: () {
          if (context.mounted) {
            loadHomePage();
          }
          // loadHomePage();
        },
      ),
    );
  }

  Future<void> getWalletApi() async {
    try {
      final rep = await userDetailRepo?.getWallet(
        WalletResponse.fromJson,
      );

      // Capture context before async operations
      final context = getContext();
      if (!context.mounted) return;

      if (rep?.data != null &&
          rep?.data!.messageKey == AppConst.WALLET_DETAILS_RETREIVED) {
        await Preferences.setBool(Preferences.isWallet, true);
        Provider.of<UserGenericProvider>(context, listen: false)
            .walletResponse = rep?.data;
      } else {
        await Preferences.setBool(Preferences.isWallet, false);
      }
    } catch (e) {
      Utils.logPrint("Error: $e");
    }
  }

  Future<void> getMatchApi() async {
    try {
      final match = await userDetailRepo?.getMatches(
        MatchResponse.fromJson,
      );

      // Capture context before async operations
      final context = getContext();
      if (!context.mounted) return;

      if (match?.data != null) {
        Provider.of<UserGenericProvider>(context, listen: false)
            .userMatchDetail = match?.data;
      }
    } catch (e) {
      Utils.logPrint("Error: $e");
    }
  }

  Future<void> getUserPreference() async {
    final rep =
        await userDetailRepo?.getUserPreference2(UserVisitModel.fromJson);

    if (!_isValidResponse(rep)) {
      Utils.logPrint("is getting to know screen show>>: false");
      return;
    }

    if (_checkGettingToKnowStatus(rep)) {
      Preferences.setBool(Preferences.isGettingToKnowDone, true);
    }
  }

  bool _isValidResponse(dynamic rep) {
    return rep.isSuccess && rep.data != null && rep.data!.data != null;
  }

  bool _checkGettingToKnowStatus(dynamic rep) {
    return rep.data!.data!.gettingToKnow != null &&
        rep.data!.data!.gettingToKnow!.isNotEmpty &&
        rep.data!.data!.gettingToKnow!.contains("true");
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
  }
}
