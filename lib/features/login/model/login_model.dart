import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/generic_dialog.dart';
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/validation.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/visa_custom_native_dialog.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/app_const.dart';
import '../../../utils/utils.dart';
import '../../ai_assistant/providers/ai_assistant_main_provider.dart';
import '../../home/model/match_details.dart';
import '../../profile/provider/user_generic_detail_provider.dart';
import '../../rate_us/model/user_visit_model.dart';
import '../../signup/model/user_model.dart';
import '../../wallet/model/wallet_model.dart';

class LoginViewModel extends BaseProvider {
  final UserDetailRepo userDetailRepo;

  LoginViewModel({
    required this.userDetailRepo,
  });

  final formKey = GlobalKey<FormState>();

  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();

  UserModel? userModel;
  bool isEmailDisable = true;
  bool isLoginButtonDisable = true;
  List<String> formValid = [];
  List<Map<String, dynamic>> formError = [];

  bool? isBiometricEnable;
  String? errorText;
  bool isDisableField = false;
  bool showError = false;
  BiometricType? supportedBiometricsType;

  AiAssistantMainProvider? aiAssistantMainProvider;
  final int _maxAttempts = 5;
  final Duration _lockoutDuration = const Duration(hours: 24);

  Future<void> init(UserModel? userEmailModel, bool? showBiometrics) async {
    //this.aiAssistantMainProvider = aiAssistantMainProvider;
    FirebaseAnalyticsService.logEvent(
        eventName: "login_screenview",
        parameters: {});
    userModel = await Preferences.getModelData(
        Preferences.KeyUserModel, UserModel.fromJson);

    isBiometricEnable = await Preferences.getBool(Preferences.enableBiometric);
    aiAssistantMainProvider =
        Provider.of<AiAssistantMainProvider>(getContext(), listen: false);

    if (userModel != null || userEmailModel != null) {
      isEmailDisable = false;
      email.text =
          (userEmailModel != null) ? userEmailModel.email : userModel!.email;
    }

    Utils.logPrint("isBiometricEnable ${isBiometricEnable}");

    if ((isBiometricEnable ?? false) && showBiometrics == null ||
        showBiometrics == true) {
      supportedBiometricsType = await Utils.getSupportedBiometric();

      Utils.logPrint("supportedBiometricsType ${supportedBiometricsType}");

      checkBiometrics();
    }
    setState();
  }

  void addToFormError(Map<String, dynamic> error) {
    bool exists = formError.any((map) =>
        map.length == error.length &&
        map.entries.every((entry) => error[entry.key] == entry.value));
    if (!exists) {
      formError.add(error);
    }
  }

  /// Form error
  void _formError() {
    Future.delayed(const Duration(milliseconds: 350), () {
      String errorField = formError
          .map((map) => map['label'])
          .where((name) => name != null)
          .join(', ');
      String errorMessage = formError
          .map((map) => map['error'])
          .where((name) => name != null)
          .join(', ');
      FirebaseAnalyticsService.logEvent(
        eventName: "login.form.error",
        parameters: {
          AnalyticsEventConst.FORM_NAME: "form_login",
          AnalyticsEventConst.FORM_ID: "login_page",
          "error_field": errorField,
          "error_type": errorMessage,
          "error_message": errorMessage,
        },
      );
      Utils.logPrint("Errors: $formError");
    });
  }

  validate(String valid) {
    if (!formValid.contains(valid)) {
      formValid.add(valid);
    }
    _formError();
    setState();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (showError == true && formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
  }

  validStateChange(String valid) {
    if (formValid.contains(valid)) {
      formValid.remove(valid);
    }
    errorText = null;
    showError = true;
    formError.clear();
    setState();

    if (Validation.emailValid.hasMatch(email.toTrimmedString()) &&
        Validation.password.hasMatch(pass.toTrimmedString())) {
      isLoginButtonDisable = false;
    } else {
      isLoginButtonDisable = true;
    }
    setState();
  }

  onShowError() {
    showError = true;
    setState();
  }

  checkError(String error) {
    formValid = [];
    showError = true;
    errorText = error;
    setState();

    Future.delayed(const Duration(milliseconds: 250), () {
      if (formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
  }

  // coverage:ignore-start
  checkBiometrics() async {
    // this is biometric code
    final rep = await Utils.enableBioMetrics();

    if (rep) {
      // Capture context before async operations to avoid BuildContext across async gaps
      final context = getContext();
      AuthSession? userAuthSession =
          await amplifyService.checkIfSignedIn(context);

      if (userAuthSession?.isSignedIn ?? false) {
        if (context.mounted) {
          Provider.of<UserGenericProvider>(context, listen: false)
              .setUserModel(userModel);
        }
        loadGreetingScreen();
      } else {
        // snackBar(getContext(), S.of(getContext()).login_fail); // your session has expired
        isBiometricEnable = false;
        await Preferences.setBool(Preferences.enableBiometric, false);
        await Preferences.setBool(Preferences.isBiometricsSetupProgress, false);
        setState();
        if (context.mounted) {
          visaSnackBar(
              context: context,
              type: SnackBarType.failure,
              title: "${S.of(context).error}!",
              subtitle: S.of(context).your_session_has,
              showAtBottom: true);
        }
        // checkError(S.of(getContext()).your_session_has);
      }
    } else {
      // snackBar(getContext(), S.of(getContext()).bioAuthFail);
      // checkError(S.of(getContext()).bioAuthFail);
    }
  }

  signUpButton() {
    navPush(AppRoutes.signup);
  }

  // coverage:ignore-end

  logoutUser() async {
    isLoading = true;
    await Utils.logoutUser();
    isLoading = false;
  }

  forgotPass() {
    FirebaseAnalyticsService.logEvent(
        eventName: AnalyticsEventConst.EVENT_NAME_UI_INTERACTION,
        parameters: {
          "ui_element": "forgot_password",
          "ui_element_location": "login"
        });
    formValid = [];
    if (formKey.currentState != null) {
      formKey.currentState!.reset();
    }

    showError = false;
    setState();
    navPush(AppRoutes.forgotPass);
  }

  signInButton() async {
    await _initializeSignIn();

    if (!formKey.currentState!.validate()) {
      _formError();
      return;
    }

    if (!await _canProceedWithLogin()) {
      return;
    }

    FirebaseAnalyticsService.logEvent(
        eventName: "login_click",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "txt_continue",
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: "login"
        });

    await _performSignIn();
  }

  Future<void> _initializeSignIn() async {
    formValid = [
      S.of(getContext()).login_username,
      S.of(getContext()).password,
    ];
    showError = true;
    errorText = null;
    setState();
    await Future.delayed(const Duration(milliseconds: 150));

    // Remove Key For App Config
    await Preferences.removeKey(Preferences.keyAppConfig);
  }

  Future<bool> _canProceedWithLogin() async {
    bool can = await canAttemptLogin();

    if (can == false) {
      checkError(Utils.getErrorMessageFromString("limit_exceed"));
      return false;
    }
    return true;
  }

  Future<void> _performSignIn() async {
    isLoading = true;
    await Amplify.Auth.signOut();

    try {
      final result = await _attemptSignIn();
      await _handleSignInResult(result);
    } catch (e) {
      Utils.logPrint("ilogin exception $e");
    } finally {
      isLoading = false;
    }
  }

  Future<dynamic> _attemptSignIn() async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = mContext;
    final userLanguage =
        await Preferences.getString(Preferences.keyLanguageCode);

    return await amplifyService.signInUser(
        context: context,
        username: email.toTrimmedString(),
        password: pass.toTrimmedString(),
        userLanguage: userLanguage);
  }

  Future<void> _handleSignInResult(dynamic result) async {
    if (result == null) return;

    if (result.isSuccess) {
      await _handleSuccessfulSignIn(result);
    } else {
      await _handleFailedSignIn(result);
    }
  }

  Future<void> _handleSuccessfulSignIn(dynamic result) async {
    final signinResult = result.data;
    UserModel userData = UserModel(
        email: email.toTrimmedString(), passowrd: pass.toTrimmedString());

    await Preferences.setString(Preferences.email, email.toTrimmedString());

    if (signinResult.isSignedIn) {
      await _handleFullySignedInUser();
    } else {
      await _handlePartialSignIn(signinResult, userData);
    }
  }

  Future<void> _handleFullySignedInUser() async {
    await Preferences.setBool(Preferences.keyIsUserLoggedInOnce, true);
    await resetLoginAttempts();
    await amplifyService?.getCurrentUser();

    await _updateUserModel();
    await _setupUserContext();
    await _loadUserData();

    isDisableField = true;
    loadHomePage();
  }

  Future<void> _updateUserModel() async {
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
  }

  Future<void> _setupUserContext() async {
    final context = getContext();
    if (context.mounted) {
      Provider.of<UserGenericProvider>(context, listen: false)
          .setUserModel(userModel);
    }
  }

  Future<void> _loadUserData() async {
    await getWalletApi();
    await getMatchApi();
    await aiAssistantMainProvider?.getAppConfiguration();
    await getUserPreference();
  }

  Future<void> _handlePartialSignIn(
      dynamic signinResult, UserModel userData) async {
    var isSingUpPending = false;

    if (signinResult.nextStep.signInStep == AuthSignInStep.confirmSignUp) {
      isSingUpPending = true;
      await _handleConfirmSignUp(userData);
    } else if (signinResult.nextStep.signInStep ==
        AuthSignInStep.resetPassword) {
      checkError(Utils.getErrorMessageFromString("user_resetPassword"));
    } else if (_isCodeDeliveryRequired(signinResult)) {
      navPush(AppRoutes.confirmCode, extra: userData);
    }

    await Preferences.setBool(Preferences.isSignUp, isSingUpPending);
  }

  Future<void> _handleConfirmSignUp(UserModel userData) async {
    final context = getContext();
    await amplifyService.resendSignUpCode(
        context: context, username: email.toTrimmedString());
    navPush(AppRoutes.confirmCode, extra: userData);
  }

  bool _isCodeDeliveryRequired(dynamic signinResult) {
    return signinResult.nextStep.codeDeliveryDetails!.deliveryMedium ==
            DeliveryMedium.sms ||
        signinResult.nextStep.codeDeliveryDetails!.deliveryMedium ==
            DeliveryMedium.email;
  }

  Future<void> _handleFailedSignIn(dynamic result) async {
    checkError(result.error.toString());
    incrementLoginAttempts();
  }

  // coverage:ignore-start
  incrementLoginAttempts() async {
    int attempts = await Preferences.getInt(Preferences.loginAttempts) ?? 0;
    attempts++;

    if (attempts >= _maxAttempts) {
      final now = DateTime.now().millisecondsSinceEpoch;
      await Preferences.setInt(Preferences.lockOutTime, now);
    }

    await Preferences.setInt(Preferences.loginAttempts, attempts);
  }

  Future<bool> canAttemptLogin() async {
    int attempts = await Preferences.getInt(Preferences.loginAttempts) ?? 0;

    if (attempts >= _maxAttempts) {
      final lockoutTimestamp =
          await Preferences.getInt(Preferences.lockOutTime);
      if (lockoutTimestamp != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final elapsed = now - lockoutTimestamp;
        if (elapsed < _lockoutDuration.inMilliseconds) {
          return false;
        } else {
          await resetLoginAttempts();
          return true;
        }
      }
      return false;
    }

    return true;
  }

  Future<void> resetLoginAttempts() async {
    await Preferences.removeKey(Preferences.lockOutTime);
    await Preferences.removeKey(Preferences.loginAttempts);
  }

  Future<void> loadGreetingScreen() async {
    final isGettingToKnowDone =
        await Preferences.getBool(Preferences.isGettingToKnowDone);

    final route = (!isGettingToKnowDone &&
            aiAssistantMainProvider?.isAllStepsNavEnabled == true)
        ? AppRoutes.aiAssistantWelcomeScreen
        : AppRoutes.homeNav;

    navGo(route);
  }

  Future<void> getUserPreference() async {
    final rep =
        await userDetailRepo.getUserPreference2(UserVisitModel.fromJson);

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

  void loadHomePage() async {
    isLoading = false;

    FirebaseAnalyticsService.logEvent(
        eventName: "login_success",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "txt_continue",
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: "login"
        });

    final isBiometricsSetupProgress = await _getBiometricsSetupProgress();

    if (isBiometricsSetupProgress) {
      loadGreetingScreen();
      return;
    }

    if (await Utils.isBioMetricsSupported()) {
      loadGreetingScreen();
      return;
    }

    await _handleBiometricsSetup();
  }

  Future<bool> _getBiometricsSetupProgress() async {
    if (kIsWeb) return true;
    return await Preferences.getBool(Preferences.isBiometricsSetupProgress);
  }

  Future<void> _handleBiometricsSetup() async {
    if (Platform.isIOS) {
      await _handleIOSBiometricsSetup();
    } else {
      await _handleAndroidBiometricsSetup();
    }
  }

  Future<void> _handleIOSBiometricsSetup() async {
    final rep = await Utils.enableBioMetrics();
    if (rep) {
      await _setBiometricsEnabled();
    }
    loadGreetingScreen();
  }

  Future<void> _handleAndroidBiometricsSetup() async {
    VisaNativeDialog.show(
      context: mContext,
      title: S.of(mContext).enable_biometric,
      message: S.of(mContext).get_faster_access,
      config: _getBiometricsDialogConfig(),
    );
  }

  VisaDialogConfig _getBiometricsDialogConfig() {
    return VisaDialogConfig(
      positiveButtonText: S.of(mContext).enable,
      negativeButtonText: S.of(mContext).skip,
      barrierDismissible: false,
      onPositivePressed: () => _handleBiometricsEnable(),
      onNegativePressed: () => _handleBiometricsSkip(),
    );
  }

  Future<void> _handleBiometricsEnable() async {
    final rep = await Utils.enableBioMetrics();
    if (rep) {
      await _setBiometricsEnabled();
      await _delayAndLoadGreeting();
    } else {
      isDisableField = false;
      loadGreetingScreen();
      setState();
    }
  }

  Future<void> _handleBiometricsSkip() async {
    await _setBiometricsDisabled();
    loadGreetingScreen();
  }

  Future<void> _setBiometricsEnabled() async {
    await Preferences.setBool(Preferences.enableBiometric, true);
    await Preferences.setBool(Preferences.isBiometricsSetupProgress, true);
  }

  Future<void> _setBiometricsDisabled() async {
    await Preferences.setBool(Preferences.enableBiometric, false);
    await Preferences.setBool(Preferences.isBiometricsSetupProgress, true);
  }

  Future<void> _delayAndLoadGreeting() async {
    await Future<void>.delayed(const Duration(microseconds: 500));
    loadGreetingScreen();
  }

  void dispose() {
    pass.dispose();
    email.dispose();
    super.dispose();
  }

  /// Shows an authentication dialog similar to the one in the example
  void showAuthenticationDialog(BuildContext context) {
    context.showAuthenticationDialog(title: S.of(context).authenticating);
  }

  Future<void> getWalletApi() async {
    try {
      final rep = await userDetailRepo.getWallet(
        WalletResponse.fromJson,
      );
      if (rep.data != null &&
          rep.data!.messageKey == AppConst.WALLET_DETAILS_RETREIVED) {
        await Preferences.setBool(Preferences.isWallet, true);
        // Capture context before async operations to avoid BuildContext across async gaps
        final context = getContext();
        if (context.mounted) {
          Provider.of<UserGenericProvider>(context, listen: false)
              .walletResponse = rep.data;
        }
      } else {
        await Preferences.setBool(Preferences.isWallet, false);
      }
    } catch (e) {
      Utils.logPrint("Error: $e");
    }
  }

  Future<void> getMatchApi() async {
    try {
      final match = await userDetailRepo.getMatches(
        MatchResponse.fromJson,
      );

      // Capture context before async operations to avoid BuildContext across async gaps
      final context = getContext();
      if (match.data != null && context.mounted) {
        Provider.of<UserGenericProvider>(context, listen: false)
            .userMatchDetail = match.data;
      }
    } catch (e) {
      Utils.logPrint("Error: $e");
    }
  }
// coverage:ignore-end
}
