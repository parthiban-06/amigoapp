import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_text_field.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/l10n.dart';
import '../../../utils/app_const.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/utils.dart';
import '../../../utils/validation.dart';
import '../../signup/widgets/regex_widget.dart';
import '../model/confirm_forgot_pass_code_model.dart';

class ConfirmForgotPassTextFieldsWidget extends StatelessWidget {
  final ConfirmForgotPassCodeModel viewModel;
  final bool isDesktop;
  final bool isMobileWeb;

  ConfirmForgotPassTextFieldsWidget({
    super.key,
    required this.viewModel,
    required this.isDesktop,
    required this.isMobileWeb,
  });

  late SizedBox smallVS;
  late SizedBox mediumVS;
  late SizedBox xsmallVS;

  @override
  Widget build(BuildContext context) {
    _initializeSpacings();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildVerificationCodeField(context),
          _buildCodeSentMessage(context),
          _buildResendSection(context),
          smallVS,
          _buildPasswordFields(context),
          _buildRegexWidgets(context),
          _buildBottomSpacing(),
        ],
      ),
    );
  }

  void _initializeSpacings() {
    smallVS = AppSizes.smallVS;
    mediumVS = AppSizes.mediumVS;
    xsmallVS = AppSizes.xsmallVS;
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        mediumVS,
        _buildRequiredFieldText(context),
        xsmallVS,
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return VisaTextView(
      text: S.of(context).please_enter_the_verification_code,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.displayTitleMedium,
      fontFamily: VisaFontWeight.semibold,
      customColor: VisaColors.black,
      colorTheme: VisaTextTheme.customTextColor,
      letterSpacing: -1,
      lineHeight: 1.04,
    );
  }

  Widget _buildRequiredFieldText(BuildContext context) {
    return VisaTextView(
      semantics: false,
      text: S.of(context).required_field,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.custom,
      fontSize: Sizes.twelveInt.toDouble(),
      fontFamily: VisaFontWeight.regular,
      customColor: VisaColors.dividerColor,
      colorTheme: VisaTextTheme.customTextColor,
      letterSpacing: 0,
      lineHeight: (16 / 12.sp).h,
    );
  }

  Widget _buildVerificationCodeField(BuildContext context) {
    final strings = S.of(context);
    final verificationHint = strings.enter_your_verification_code;
    final verificationLabel = strings.verification_code;
    final semanticsLabel =
        "${strings.edit_box}, $verificationHint, ${strings.double_tap_to_edit}";

    return VisaTextField(
      controller: viewModel.code,
      semanticsLabel: semanticsLabel,
      hint: verificationHint,
      label: verificationLabel,
      textInputType: TextInputType.number,
      maxLength: AppConst.TEXTFIELD_PASSWORD_LENGTH,
      errorText: _getVerificationCodeErrorText(context),
      onError: (_){
        viewModel.addToFormError(_);
      },
      onTap: _getFieldOnTap(verificationLabel),
      disableError: true,
      letterSpacing: 0,
      onChanged: _getFieldOnChanged(verificationLabel),
      isValid: _getVerificationCodeIsValid(context),
    );
  }

  String _getVerificationCodeErrorText(BuildContext context) {
    return viewModel.errorText ??
        (viewModel.code.text.trim().isEmpty
            ? S.of(context).verification_code_is_required
            : S.of(context).invalid_verification_code);
  }

  Function(bool) _getFieldOnTap(String fieldName) {
    return (isValid) {
      if (!isValid) {
        viewModel.validate(fieldName);
      } else {
        viewModel.onShowError();
      }
    };
  }

  Function(String) _getFieldOnChanged(String fieldName) {
    return (_) {
      viewModel.validStateChange(fieldName);
    };
  }

  bool _getVerificationCodeIsValid(BuildContext context) {
    return viewModel.errorText == null &&
        (viewModel.code.text.trim().length == 6 ||
            (!viewModel.formValid.contains(S.of(context).verification_code) &&
                viewModel.formValid.isNotEmpty));
  }

  Widget _buildCodeSentMessage(BuildContext context) {
    if (!viewModel.codeSent) {
      return const SizedBox();
    }

    return Column(
      children: [
        VisaTextView(
          text: S.of(context).your_code_was_resent,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.customMedium,
          fontFamily: VisaFontWeight.semibold,
          customColor: VisaColors.green,
          colorTheme: VisaTextTheme.customTextColor,
        ),
        xsmallVS,
      ],
    );
  }

  Widget _buildResendSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDidNotReceiveText(context),
        _buildResendButton(context),
      ],
    );
  }

  Widget _buildDidNotReceiveText(BuildContext context) {
    return VisaTextView(
      text: S.of(context).did_not_receive_a_code,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.customMedium,
      fontFamily: VisaFontWeight.regular,
      customColor: VisaColors.black,
      colorTheme: VisaTextTheme.customTextColor,
    );
  }

  Widget _buildResendButton(BuildContext context) {
    if (viewModel.canSendOtp) {
      return InkWell(
        onTap: () {
          viewModel.startCountdown();
          Utils.hideKeyboard(context);
        },
        child: Semantics(
          excludeSemantics: true,
          container: true,
          label:
              "${S.of(context).reSend_code}, ${S.of(context).double_tap_to_activate_link}",
          child: VisaTextView(
            semantics: false,
            text: S.of(context).reSend_code,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.link,
            fontFamily: VisaFontWeight.semibold,
            colorTheme: VisaTextTheme.primary,
          ),
        ),
      );
    }

    return _buildCountdownTimer();
  }

  Widget _buildCountdownTimer() {
    final minutes =
        (viewModel.duration / 60).floor().toString().padLeft(2, "0");
    final seconds =
        (viewModel.duration % 60).floor().toString().padLeft(2, "0");

    return VisaTextView(
      text: "$minutes:$seconds",
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.customMedium,
      fontFamily: VisaFontWeight.semibold,
      customColor: VisaColors.grey,
      colorTheme: VisaTextTheme.customTextColor,
    );
  }

  Widget _buildPasswordFields(BuildContext context) {
    return Column(
      children: [
        _buildPasswordField(context),
        _buildConfirmPasswordField(context),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return VisaTextField(
      controller: viewModel.password,
      hint: S.of(context).new_pass,
      label: S.of(context).new_pass,
      isPassword: true,
      errorText: _getPasswordErrorText(context),
      onError: (_){
        viewModel.addToFormError(_);
      },
      onTap: _getFieldOnTap(S.of(context).new_pass),
      disableError: true,
      onChanged: _getPasswordOnChanged(context),
      isValid: _getPasswordIsValid(context),
    );
  }

  String _getPasswordErrorText(BuildContext context) {
    return viewModel.password.text.trim().isEmpty
        ? S.of(context).password_is_required
        : S.of(context).invalid_new_pass;
  }

  Function(String) _getPasswordOnChanged(BuildContext context) {
    return (_) {
      viewModel.validPassState(S.of(context).new_pass);
    };
  }

  bool _getPasswordIsValid(BuildContext context) {
    return Validation.password.hasMatch(viewModel.password.text.trim()) ||
        (!viewModel.formValid.contains(S.of(context).new_pass) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return VisaTextField(
      controller: viewModel.confirmPassword,
      hint: S.of(context).cnf_pass,
      isPassword: true,
      label: S.of(context).cnf_pass,
      errorText: _getConfirmPasswordErrorText(context),
      onError: (_){
        viewModel.addToFormError(_);
      },
      disableError: true,
      onTap: _getFieldOnTap(S.of(context).cnf_pass),
      onChanged: _getFieldOnChanged(S.of(context).cnf_pass),
      isValid: _getConfirmPasswordIsValid(context),
    );
  }

  String _getConfirmPasswordErrorText(BuildContext context) {
    return viewModel.confirmPassword.text.trim().isEmpty
        ? S.of(context).confirm_password_is_required
        : S.of(context).invalid_cnf_pass;
  }

  bool _getConfirmPasswordIsValid(BuildContext context) {
    return (Validation.password.hasMatch(viewModel.confirmPassword.text) &&
            (viewModel.password.text.trim() ==
                viewModel.confirmPassword.text.trim())) ||
        (!viewModel.formValid.contains(S.of(context).cnf_pass) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildRegexWidgets(BuildContext context) {
    return Column(
      children: [
        xsmallVS,
        _buildRegexWidget(
          regex: viewModel.atLeast8Character,
          text: S.of(context).at_least_8_characters,
        ),
        smallVS,
        _buildRegexWidget(
          regex: viewModel.atLeastOneOfEachChar,
          text: S.of(context).include_special_character,
        ),
        mediumVS,
      ],
    );
  }

  Widget _buildRegexWidget({required bool regex, required String text}) {
    return regexWidget(
      isDisable: viewModel.password.text.trim().isEmpty,
      regex: regex,
      text: text,
    );
  }

  Widget _buildBottomSpacing() {
    if (!isDesktop || !isMobileWeb) {
      return AppSizes.largeVS;
    }
    return const SizedBox();
  }
}
