import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visaamigo/custom_widgets/snackbar.dart';
import 'package:visaamigo/features/forgot_pass/model/send_otp_model.dart';
import 'package:visaamigo/features/forgot_pass/model/send_otp_response.dart';
import 'package:visaamigo/features/forgot_pass/model/verifyOUT.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/encryption_AES_GCM.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/validation.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/utils.dart';

class ConfirmForgotPassCodeModel extends BaseProvider {
  final formKey = GlobalKey<FormState>();
  final UserDetailRepo userDetails;

  ConfirmForgotPassCodeModel({required this.userDetails});

  TextEditingController code = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool atLeastOneOfEachChar = false;
  bool atLeast8Character = false;
  bool isDisable = true;
  bool codeSent = false;
  String? errorText;
  bool showError = false;
  List<String> formValid = [""];
  List<Map<String, dynamic>> formError = [];

  late Timer _timer;
  bool canSendOtp = true;
  int _resendCodeDuration = 30;
  int duration = 30;

  validStateChange(String valid) {
    if (formValid.contains(valid)) {
      formValid.remove(valid);
    }
    errorText = null;
    showError = true;
    formError.clear();
    setState();
    checkDisable();
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
        eventName: "forgot.password.form.error",
        parameters: {
          AnalyticsEventConst.FORM_NAME: "form_forgot_password",
          AnalyticsEventConst.FORM_ID: "forgot_password_page",
          "error_field": errorField,
          "error_type": errorMessage,
          "error_message": errorMessage,
        },
      );
      Utils.logPrint("Errors: $formError");
    });
  }

  validPassState(String valid) {
    if (formValid.contains(valid)) {
      formValid.remove(valid);
    }
    errorText = null;
    showError = true;
    formError.clear();
    setState();

    if (Validation.everyChar.hasMatch(password.text.trim())) {
      atLeastOneOfEachChar = true;
    } else {
      atLeastOneOfEachChar = false;
    }

    if (password.text.trim().length >= 8 && password.text.trim().length <= 20) {
      atLeast8Character = true;
    } else {
      atLeast8Character = false;
    }

    setState();

    checkDisable();
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
    showError = true;
    errorText = error;
    setState();

    Future.delayed(const Duration(milliseconds: 250), () {
      if (formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
  }

  onShowError() {
    showError = true;
    setState();
  }

  checkDisable() {
    isDisable = !(code.text.trim().length >= 6 &&
        atLeastOneOfEachChar &&
        atLeast8Character &&
        password.text.trim() == confirmPassword.text.trim());
    setState();
  }

  void startCountdown() async {
    formValid = [];
    if (formKey.currentState != null) {
      formKey.currentState!.reset();
    }
    code.text = "";
    showError = false;
    setState();
    duration = _resendCodeDuration;
    canSendOtp = false;
    setState();
    await resendCode();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (duration > 0) {
        duration = duration - 1;
      } else {
        canSendOtp = true;
        _timer.cancel();
      }
      setState();
    });

    setState();
  }

  confirmCodeButton() async {
    formValid = [
      S.of(getContext()).verification_code,
      S.of(getContext()).new_pass,
      S.of(getContext()).cnf_pass,
    ];
    showError = true;
    errorText = null;
    setState();
    await Future.delayed(const Duration(milliseconds: 150));

    if (!(formKey.currentState != null && formKey.currentState!.validate())) {
      _formError();
      return;
    }

    isLoading = true;
    setState();

    String? email = await Preferences.getString(Preferences.email);

    if (email != null) {
      final pasWod = await EncryptionHelperGCM.encrypt(password.text.trim());
      final verifyOTPRep = VerifyOtpRequest(
          email: email, otp: code.text.trim(), password: pasWod);

      final verifyOTP = await userDetails?.verifyOTPForgotPassword(
        body: verifyOTPRep.toJson(),
        fromJson: SendOtpResponse.fromJson,
      );

      if (verifyOTP != null && verifyOTP.isSuccess && verifyOTP.data != null) {
        isLoading = false;
        setState();
        snackBar(getContext(), S.of(getContext()).pass_change_succ);

        await Preferences.removeKey(Preferences.enableBiometric);
        await Preferences.removeKey(Preferences.isBiometricsSetupProgress);
        navPush(AppRoutes.login);
      } else {
        checkError(S.of(getContext()).invalid_auth_code);
        isLoading = false;
        setState();
      }
    } else {
      isLoading = false;
      setState();
    }
  }

  // AWS Cognito does not provide a direct API to resend the confirmation code
  resendCode() async {
    String? email = await Preferences.getString(Preferences.email);

    if (email != null) {
      try {
        final userData = SendOtpModel(
          email: email.trim(),
          preferredLanguage:
              await Preferences.getString(Preferences.keyLanguageCode),
        );

        final sendOTP = await userDetails?.sendOTPForgotPassword(
          body: userData.toJson(),
          fromJson: SendOtpResponse.fromJson,
        );

        if (sendOTP != null && sendOTP.isSuccess && sendOTP.data != null) {
          codeSent = true;
          setState();
          Future.delayed(const Duration(milliseconds: 5000), () {
            codeSent = false;
            setState();
          });
        } else {
          if (sendOTP != null &&
              sendOTP.messageKey != null &&
              sendOTP.messageKey!.contains("limit")) {
            checkError(S.of(getContext()).limit_exceed);
          } else {
            checkError(S.of(getContext()).something_went_wrong);
          }
        }
      } catch (e) {
        // Capture context before async operations to avoid BuildContext across async gaps
        final context = getContext();
        if (context.mounted) {
          checkError(S.of(context).something_went_wrong);
        }
      }
      // final rep = await amplifyService.initiateForgotPassword(
      //     context: getContext(), username: email);
      //
      // if (rep != null && rep is! String) {
      //   codeSent = true;
      //   setState();
      //   Future.delayed(const Duration(milliseconds: 5000), () {
      //     codeSent = false;
      //     setState();
      //   });
      // } else {
      //   checkError(rep);
      // }
    }
  }
}
