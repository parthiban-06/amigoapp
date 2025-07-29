import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_svg_icon.dart';
import '../../../custom_widgets/visa_text_field.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../utils/app_const.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/validation.dart';
import '../model/login_model.dart';

class LoginTextFieldsWidget extends StatelessWidget {
  final LoginViewModel viewModel;

  const LoginTextFieldsWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeaderSection(context),
          _buildEmailField(context),
          _buildChangeEmailLink(context),
          _buildPasswordField(context),
          _buildBiometricAndForgotPasswordRow(context),
          AppSizes.smallVS,
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VisaTextView(
          text: S.of(context).welcome_please_login,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.displayTitleMedium,
          fontFamily: VisaFontWeight.semibold,
          customColor: VisaColors.black,
          colorTheme: VisaTextTheme.customTextColor,
          letterSpacing: -1,
          lineHeight: 1.04,
        ),
        AppSizes.smallVS,
        VisaTextView(
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
        ),
        AppSizes.xsmallVS,
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    final strings = S.of(context);
    final isDisabled = viewModel.isEmailDisable;
    final loginUsername = strings.login_username;
    final semanticsLabel = !isDisabled
        ? "${strings.registered_email}, ${strings.non_editable}, ${viewModel.email.text}"
        : "${strings.edit_box}, $loginUsername, ${strings.double_tap_to_edit}";

    return VisaTextField(
      semanticsLabel: semanticsLabel,
      controller: viewModel.email,
      hint: loginUsername,
      isLowerCase: true,
      errorText: _getEmailErrorText(context),
      onError: (_) {
        viewModel.addToFormError(_);
      },
      onTap: (isFocused) => _handleEmailFieldTap(context, isFocused),
      semantics: true,
      maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
      textInputType: TextInputType.emailAddress,
      showSuccessIcon: !isDisabled,
      isEnable: isDisabled,
      label: loginUsername,
      letterSpacing: 0,
      onChanged: (_) => viewModel.validStateChange(loginUsername),
      isValid: _isEmailValid(context),
    );
  }

  String _getEmailErrorText(BuildContext context) {
    if (viewModel.errorText != null) {
      return viewModel.errorText!;
    }
    return viewModel.email.text.trim().isEmpty
        ? S.of(context).email_is_required
        : S.of(context).invalid_email;
  }

  void _handleEmailFieldTap(BuildContext context, bool isFocused) {
    if (!isFocused) {
      viewModel.validate(S.of(context).login_username);
    } else {
      viewModel.onShowError();
    }
  }

  bool _isEmailValid(BuildContext context) {
    if (viewModel.errorText != null) {
      return false;
    }

    final emailText = viewModel.email.text.trim();
    final isEmailValid = Validation.emailValid.hasMatch(emailText);

    if (isEmailValid) {
      return true;
    }

    return _shouldShowAsValid(context, S.of(context).login_username);
  }

  bool _isPasswordValid(BuildContext context) {
    final passwordText = viewModel.pass.text.trim();
    final isPasswordValid = Validation.password.hasMatch(passwordText);

    if (isPasswordValid) {
      return true;
    }

    return _shouldShowAsValid(context, S.of(context).password);
  }

  bool _shouldShowAsValid(BuildContext context, String fieldName) {
    final isNotInFormValid = !viewModel.formValid.contains(fieldName);
    final hasFormValidItems = viewModel.formValid.isNotEmpty;

    return isNotInFormValid && hasFormValidItems;
  }

  Widget _buildChangeEmailLink(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          viewModel.logoutUser();
        },
        child: Semantics(
          excludeSemantics: true,
          container: true,
          label:
              "${S.of(context).change_email_id}, ${S.of(context).double_tap_to_activate_link}",
          child: VisaTextView(
            semantics: false,
            text: S.of(context).change_email_id,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.link,
            fontFamily: VisaFontWeight.semibold,
            colorTheme: VisaTextTheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return VisaTextField(
      semantics: true,
      controller: viewModel.pass,
      hint: S.of(context).password,
      errorText: _getPasswordErrorText(context),
      onError: (_) {
        viewModel.addToFormError(_);
      },
      label: S.of(context).password,
      isEnable: !viewModel.isDisableField,
      letterSpacing: 0,
      isPassword: true,
      onTap: (isFocused) => _handlePasswordFieldTap(context, isFocused),
      onBiometricCall: () {
        viewModel.checkBiometrics();
      },
      onChanged: (_) {
        viewModel.validStateChange(S.of(context).password);
      },
      isValid: _isPasswordValid(context),
    );
  }

  String _getPasswordErrorText(BuildContext context) {
    return viewModel.pass.text.isEmpty
        ? S.of(context).password_is_required
        : S.of(context).invalid_pass;
  }

  void _handlePasswordFieldTap(BuildContext context, bool isFocused) {
    if (!isFocused) {
      viewModel.validate(S.of(context).password);
    } else {
      viewModel.onShowError();
    }
  }

  Widget _buildBiometricAndForgotPasswordRow(BuildContext context) {
    final isBiometricEnabled = viewModel.isBiometricEnable ?? false;

    return Row(
      crossAxisAlignment: isBiometricEnabled
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (isBiometricEnabled && viewModel.supportedBiometricsType != null)
          _buildBiometricButton(context),
        const Spacer(),
        _buildForgotPasswordLink(context),
      ],
    );
  }

  Widget _buildBiometricButton(BuildContext context) {
    final isFingerprint =
        viewModel.supportedBiometricsType == BiometricType.fingerprint;

    return InkWell(
      onTap: () {
        viewModel.checkBiometrics();
      },
      child: Row(
        children: [
          VisaSvgIcon(
            height: 25.h,
            width: 25.w,
            assetPath: isFingerprint
                ? Assets.iconsBiometricAndroid
                : Assets.iconsBiometricsIcon,
            color: context.theme.primaryColor,
          ),
          SizedBox(width: Sizes.four),
          VisaTextView(
            text: isFingerprint
                ? S.of(context).biometrics
                : S.of(context).face_id,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customMedium,
            fontFamily: VisaFontWeight.semibold,
            colorTheme: VisaTextTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          viewModel.forgotPass();
        },
        child: Semantics(
          excludeSemantics: true,
          container: true,
          label:
              "${S.of(context).forgot_password}, ${S.of(context).double_tap_to_activate_link}",
          child: VisaTextView(
            semantics: false,
            text: S.of(context).forgot_password,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.link,
            fontFamily: VisaFontWeight.semibold,
            colorTheme: VisaTextTheme.primary,
          ),
        ),
      ),
    );
  }
}
