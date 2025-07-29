import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visaamigo/custom_widgets/snackbar.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';
import 'package:visaamigo/utils/validation.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../router/app_routes_const.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/app_const.dart';

class SignUpViewProvider extends BaseProvider {
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool isDisable = false;

  bool termsAndCondition = false;
  bool privacyNotice = false;
  bool showTermsConditionError = false;
  bool atLeastOneOfEachChar = false;
  bool showError = false;
  List<String> formValid = [];
  List<Map<String, dynamic>> formError = [];

  bool atLeast8Character = false;

  bool isValidDeeplinkEmail = false;
  bool isConformPasswordError = false;
  String? errorText;
  String? errorPassword;

  void init(UserModel? userModel) async {
    if (userModel != null && !userModel.email.isNullOrEmpty) {
      email.text = userModel.email;
      firstName.text = userModel.firstName;
      lastName.text = userModel.lastName;
      isValidDeeplinkEmail = true;
      // validStateChange();
    } else {}
    setState();

    // set event
    FirebaseAnalyticsService.logEvent(
        eventName: AnalyticsEventConst.EVENT_NAME_RESGITRATION_FORM_START,
        // screenName: AppRoutes.aiAssistantStepTwoScreen,
        parameters: {
          "form_name": AnalyticsEventConst.FORM_NAME_RESGITRATION,
          "form_id": AnalyticsEventConst.FORM_ID_RESGITRATION
        });
  }

  onShowError() {
    showError = true;
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
        eventName: "registration.form.error",
        parameters: {
          AnalyticsEventConst.FORM_NAME:
              AnalyticsEventConst.FORM_NAME_RESGITRATION,
          AnalyticsEventConst.FORM_ID: AnalyticsEventConst.FORM_ID_RESGITRATION,
          "error_field": errorField,
          "error_type": errorMessage,
          "error_message": errorMessage,
        },
      );
      Utils.logPrint("Errors: $formError");
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

    if (Validation.everyChar.hasMatch(password.text)) {
      atLeastOneOfEachChar = true;
    } else {
      atLeastOneOfEachChar = false;
    }

    if (password.text.trim().length >= 8 &&
        password.text.trim().length <= AppConst.TEXTFIELD_DEFAULT_LENGTH) {
      atLeast8Character = true;
    } else {
      atLeast8Character = false;
    }

    checkValid();

    setState();
  }

  termAndConditionChange() {
    showError = false;
    setState();
    termsAndCondition = !termsAndCondition;
    showTermsConditionError = false;
    errorText = null;
    setState();
    validate("");
    checkValid();
    setState();
  }

  privacyNoticeChange() {
    showError = false;
    setState();
    privacyNotice = !privacyNotice;
    showTermsConditionError = false;
    errorText = null;
    setState();
    validate("");
    checkValid();
    setState();
  }

  goToSignIn() {
    navPush(AppRoutes.login);
  }

  backButton() {
    navPop();
  }

  checkValid() {
    if (Validation.emailValid.hasMatch(email.text) && errorText == null) {
      if (firstName.text.trim().isNotEmpty && lastName.text.trim().isNotEmpty) {
        if (atLeast8Character &&
            atLeastOneOfEachChar &&
            termsAndCondition &&
            privacyNotice) {
          if (password.text.trim() == confirmPassword.text.trim()) {
            isDisable = true;
            setState();
            return;
          }
        }
      }
    }
    isDisable = false;
    setState();
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

  checkError(String error) {
    formValid = [];
    errorText = error;
    setState();
    FirebaseAnalyticsService.logEvent(
        eventName: AnalyticsEventConst.EVENT_NAME_RESGITRATION_FORM_START,
        parameters: {
          "form_name": AnalyticsEventConst.FORM_NAME_RESGITRATION,
          "form_id": AnalyticsEventConst.FORM_ID_RESGITRATION,
          "error_field": "login_email",
          "error_type": errorText ?? "",
          "error_message": errorText ?? "",
        });
    Future.delayed(const Duration(milliseconds: 250), () {
      if (formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
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

  signUpButton() async {
    formValid = [
      S.of(getContext()).login_username,
      S.of(getContext()).first_name,
      S.of(getContext()).last_name,
      S.of(getContext()).password,
      S.of(getContext()).cnf_pass
    ];
    showError = true;
    errorText = null;
    setState();
    await Future.delayed(const Duration(milliseconds: 150));

    if (!(formKey.currentState != null && formKey.currentState!.validate())) {
      _formError();
      return;
    }

    bool tc = termsAndCondition == true && privacyNotice == true;

    // set event
    FirebaseAnalyticsService.logEvent(
        eventName: AnalyticsEventConst.EVENT_NAME_RESGITRATION_FORM_SUBMIT,
        parameters: {
          "form_name": AnalyticsEventConst.FORM_NAME_RESGITRATION,
          "ui_element": "submit",
          "form_id": AnalyticsEventConst.FORM_ID_RESGITRATION,
          "optin_status": tc.toString(),
          "optin_label": tc ? "I agree to the T&C" : "I disagree with the T&C"
        });

    if (termsAndCondition == false || privacyNotice == false) {
      showTermsConditionError = true;
      setState();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      return;
    }

    if (isDisable == false) {
      return;
    }

    isLoading = true;
    setState();

    try {
      // Capture context before async operations to avoid BuildContext across async gaps
      final context = getContext();
      final rep = await amplifyService.signUpUser(
          context,
          email.text.trim(),
          password.text.trim(),
          firstName.text.trim(),
          lastName.text.trim(),
          await Preferences.getString(Preferences.keyLanguageCode));

      // coverage:ignore-start

      await Preferences.setString(Preferences.email, email.text.trim());
      await Preferences.setString(Preferences.firstName, firstName.text.trim());
      await Preferences.setString(Preferences.lastName, lastName.text.trim());
      await Preferences.setBool(Preferences.isSignUp, true);

      if (rep != null) {
        if (rep.statusCode == AmplifyService.AMPLIFY_SUCCESS) {
          // set event
          FirebaseAnalyticsService.logEvent(
              eventName: AnalyticsEventConst.EVENT_NAME_RESGITRATION_SUCCESS);
          snackBar(getContext(),
              S.of(getContext()).verification_code_send_to(email.text));
          UserModel userData = UserModel(
              email: email.text.trim(),
              firstName: firstName.text.trim(),
              lastName: lastName.text.trim(),
              passowrd: password.text.trim());

          navPush(AppRoutes.confirmCode, extra: userData);
        } else if (rep.statusCode ==
            AmplifyService.AMPLIFY_USER_SIGNUP_ALREADY_EXIST) {
          checkError(S.of(getContext()).user_already_exists);

          UserModel userModel = UserModel();
          userModel.email = email.text.trim();

          navGo(AppRoutes.registeredEmail, extra: userModel);

          navPush(AppRoutes.login);
        } else {
          dynamic er = jsonDecode(jsonEncode(rep.error));
          checkError(er["message"]);
        }
      } else {
        checkError(S.of(getContext()).try_again);
      }
      isLoading = false;
      setState();
      // coverage:ignore-end
    } catch (e) {
      isLoading = false;
      setState();
      Utils.logPrint("error ${e}");
      checkError(S.of(getContext()).try_again);
    }
  }
}
