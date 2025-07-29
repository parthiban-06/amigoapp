import 'package:flutter/material.dart';
import 'package:visaamigo/custom_widgets/snackbar.dart';
import 'package:visaamigo/features/forgot_pass/model/send_otp_model.dart';
import 'package:visaamigo/features/forgot_pass/model/send_otp_response.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';
import 'package:visaamigo/utils/validation.dart';

import '../../../ui/base/base_provider.dart';

class ForgotPassModel extends BaseProvider {
  final UserDetailRepo? splashScreenRepo;
  ForgotPassModel({required this.splashScreenRepo});
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  bool isContinueButtonDisable = true;
  String? errorText;

  validStateChange() {
    errorText = null;
    setState();
    validEmail();
  }

  validEmail() {
    if (Validation.emailValid.hasMatch(email.text)) {
      isContinueButtonDisable = false;
      setState();
    } else {
      isContinueButtonDisable = true;
      setState();
    }
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

  validate() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (formKey.currentState != null) {
        formKey.currentState!.validate();
      }
    });
  }

  signIn() {
    navPush(AppRoutes.login);
  }

  forgotPassCodeButton() async {
    _initializeRequest();
    await Future.delayed(const Duration(milliseconds: 150));

    if (!_validateForm()) {
      return;
    }

    isLoading = true;

    if (!await _validateUser()) {
      return;
    }

    await _sendOtpAndHandleResponse();
  }

  void _initializeRequest() {
    errorText = null;
    setState();
  }

  bool _validateForm() {
    return formKey.currentState!.validate();
  }

  Future<bool> _validateUser() async {
    final apiResponse = await splashScreenRepo?.getIsValidUser(
        email.toTrimmedString(), UserModel.fromJson, AppConst.USER_VALIDATION);

    if (_isInvalidUser(apiResponse)) {
      _handleInvalidUser(apiResponse);
      return false;
    }

    if (_hasApiError(apiResponse)) {
      _handleApiError(apiResponse);
      return false;
    }

    return true;
  }

  bool _isInvalidUser(dynamic apiResponse) {
    return apiResponse != null &&
        apiResponse.isSuccess &&
        apiResponse.messageKey == AppConst.INVALID_USER;
  }

  void _handleInvalidUser(dynamic apiResponse) {
    Utils.logPrint("INVALID_USER ");
    isLoading = false;
    checkError(apiResponse.messageKey ?? "INVALID_USER");
  }

  bool _hasApiError(dynamic apiResponse) {
    return apiResponse != null && !apiResponse.isSuccess;
  }

  void _handleApiError(dynamic apiResponse) {
    isLoading = false;
    checkError(apiResponse.error ?? "Error");
  }

  Future<void> _sendOtpAndHandleResponse() async {
    try {
      final userData = await _createOtpModel();
      final sendOTP = await _sendOtpRequest(userData);

      if (_isOtpSuccess(sendOTP)) {
        await _handleOtpSuccess();
      } else {
        _handleOtpError(sendOTP);
      }
    } catch (e) {
      _handleException();
    }
  }

  Future<SendOtpModel> _createOtpModel() async {
    return SendOtpModel(
      email: email.text.trim(),
      preferredLanguage:
          await Preferences.getString(Preferences.keyLanguageCode),
    );
  }

  Future<dynamic> _sendOtpRequest(SendOtpModel userData) async {
    return await splashScreenRepo?.sendOTPForgotPassword(
      body: userData.toJson(),
      fromJson: SendOtpResponse.fromJson,
    );
  }

  bool _isOtpSuccess(dynamic sendOTP) {
    return sendOTP != null && sendOTP.isSuccess && sendOTP.data != null;
  }

  Future<void> _handleOtpSuccess() async {
    await Preferences.setString(Preferences.email, email.text);
    isLoading = false;
    setState();
    snackBar(
        getContext(), S.of(getContext()).verification_code_send_to(email.text));
    navPush(AppRoutes.confirmForgotPassword);
  }

  void _handleOtpError(dynamic sendOTP) {
    if (_isLimitExceeded(sendOTP)) {
      checkError(S.of(getContext()).limit_exceed);
    } else {
      checkError(S.of(getContext()).try_again);
    }
    isLoading = false;
    setState();
  }

  bool _isLimitExceeded(dynamic sendOTP) {
    return sendOTP != null &&
        sendOTP.messageKey != null &&
        sendOTP.messageKey!.contains("limit");
  }

  void _handleException() {
    final context = getContext();
    if (context.mounted) {
      checkError(S.of(context).try_again);
    }
    isLoading = false;
    setState();
  }
}
