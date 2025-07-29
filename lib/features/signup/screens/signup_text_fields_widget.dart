import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';

import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_checkbox.dart';
import '../../../custom_widgets/visa_rich_text.dart';
import '../../../custom_widgets/visa_text_field.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/l10n.dart';
import '../../../utils/app_const.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/validation.dart';
import '../providers/signup_provider.dart';
import '../widgets/regex_widget.dart';

// ignore: must_be_immutable
class SignupTextFieldsWidget extends StatelessWidget {
  final SignUpViewProvider viewModel;

  SignupTextFieldsWidget({
    super.key,
    required this.viewModel,
  });

  late SizedBox vsSpacing;
  late SizedBox xVsSpacing;

  @override
  Widget build(BuildContext context) {
    vsSpacing = AppSizes.smallVS;
    xVsSpacing = AppSizes.xsmallVS;

    return SingleChildScrollView(
      controller: viewModel.scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildEmailField(context),
          _buildFirstNameField(context),
          _buildLastNameField(context),
          _buildPasswordField(context),
          _buildConfirmPasswordField(context),
          xVsSpacing,
          _buildPasswordValidationWidgets(context),
          AppSizes.mediumVS,
          _buildTermsAndConditionsRow(context),
          vsSpacing,
          _buildPrivacyNoticeRow(context),
          _buildTermsErrorWidget(context),
          AppSizes.mediumVS,
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VisaTextView(
          text: S.of(context).setup_account,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.displayTitleMedium,
          fontFamily: VisaFontWeight.semibold,
          customColor: VisaColors.black,
          colorTheme: VisaTextTheme.customTextColor,
          letterSpacing: -1,
          lineHeight: 1.04,
        ),
        vsSpacing,
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
        xVsSpacing,
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    final strings = S.of(context);
    final loginUsername = strings.login_username;
    final semanticsLabel =
        "${strings.edit_box}, $loginUsername, ${strings.double_tap_to_edit}";
    final isDeeplinkValid = viewModel.isValidDeeplinkEmail;

    return VisaTextField(
      fieldKey: const Key("Email"),
      semanticsLabel: semanticsLabel,
      controller: viewModel.email,
      isRequired: true,
      isLowerCase: true,
      hint: loginUsername,
      label: loginUsername,
      disableError: true,
      formName: AnalyticsEventConst.FORM_NAME_RESGITRATION,
      formId: AnalyticsEventConst.FORM_ID_RESGITRATION,
      eventName: AnalyticsEventConst.EVENT_NAME_RESGITRATION_FORM_START,
      maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
      textInputType: TextInputType.emailAddress,
      errorText: _getEmailErrorText(context),
      onError: (_){
        viewModel.addToFormError(_);
      },
      letterSpacing: 0,
      onTap: (isError) {
        isError ? viewModel.onShowError() : viewModel.validate(loginUsername);
      },
      showSuccessIcon: isDeeplinkValid,
      isEnable: !isDeeplinkValid,
      onChanged: (_) => viewModel.validStateChange(loginUsername),
      isValid: _isEmailValid(context),
    );
  }

  Widget _buildFirstNameField(BuildContext context) {
    final strings = S.of(context);
    final firstNameLabel = strings.first_name;
    final semanticsLabel =
        "${strings.edit_box}, $firstNameLabel, ${strings.double_tap_to_edit}";

    return VisaTextField(
      key: Key(firstNameLabel),
      semanticsLabel: semanticsLabel,
      controller: viewModel.firstName,
      label: firstNameLabel,
      formName: AnalyticsEventConst.FORM_NAME_RESGITRATION,
      formId: AnalyticsEventConst.FORM_ID_RESGITRATION,
      eventName: AnalyticsEventConst.EVENT_NAME_RESGITRATION_FORM_START,
      disableError: true,
      errorText: _getFirstNameErrorText(context),
      onError: (_){
        viewModel.addToFormError(_);
      },
      letterSpacing: 0,
      hint: firstNameLabel,
      onTap: (isError) {
        isError ? viewModel.onShowError() : viewModel.validate(firstNameLabel);
      },
      onChanged: (_) => viewModel.validStateChange(firstNameLabel),
      isValid: _isFirstNameValid(context),
    );
  }

  Widget _buildLastNameField(BuildContext context) {
    final strings = S.of(context);
    final lastNameLabel = strings.last_name;
    final semanticsLabel =
        "${strings.edit_box}, $lastNameLabel, ${strings.double_tap_to_edit}";

    return VisaTextField(
      key: Key(lastNameLabel),
      semanticsLabel: semanticsLabel,
      isRequired: true,
      controller: viewModel.lastName,
      errorText: _getLastNameErrorText(context),
      onError: (_){
        viewModel.addToFormError(_);
      },
      disableError: true,
      formName: AnalyticsEventConst.FORM_NAME_RESGITRATION,
      formId: AnalyticsEventConst.FORM_ID_RESGITRATION,
      eventName: AnalyticsEventConst.EVENT_NAME_RESGITRATION_FORM_START,
      hint: lastNameLabel,
      letterSpacing: 0,
      label: lastNameLabel,
      onTap: (isError) {
        isError ? viewModel.onShowError() : viewModel.validate(lastNameLabel);
      },
      onChanged: (_) => viewModel.validStateChange(lastNameLabel),
      isValid: _isLastNameValid(context),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return VisaTextField(
      key: Key(S.of(context).create_password),
      isRequired: true,
      controller: viewModel.password,
      formName: AnalyticsEventConst.FORM_NAME_RESGITRATION,
      formId: AnalyticsEventConst.FORM_ID_RESGITRATION,
      eventName: AnalyticsEventConst.EVENT_NAME_RESGITRATION_FORM_START,
      hint: S.of(context).create_password,
      disableError: true,
      label: S.of(context).create_password,
      letterSpacing: 0,
      errorText: _getPasswordErrorText(context),
      onError: (_){
        viewModel.addToFormError(_);
      },
      textInputType: TextInputType.text,
      isPassword: true,
      onTap: (isError) {
        if (!isError) {
          viewModel.validate(S.of(context).password);
        } else {
          viewModel.onShowError();
        }
      },
      onChanged: (_) {
        viewModel.validStateChange(S.of(context).password);
      },
      isValid: _isPasswordValid(context),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return VisaTextField(
      key: Key(S.of(context).confirm_password),
      isRequired: true,
      controller: viewModel.confirmPassword,
      formName: AnalyticsEventConst.FORM_NAME_RESGITRATION,
      formId: AnalyticsEventConst.FORM_ID_RESGITRATION,
      eventName: AnalyticsEventConst.EVENT_NAME_RESGITRATION_FORM_START,
      hint: S.of(context).confirm_password,
      letterSpacing: 0,
      disableError: !viewModel.isConformPasswordError,
      label: S.of(context).confirm_password,
      errorText: S.of(context).invalid_cnf_pass,
      onError: (_){
        viewModel.addToFormError(_);
      },
      textInputType: TextInputType.text,
      isPassword: true,
      onTap: (isError) {
        if (!isError) {
          viewModel.validate(S.of(context).cnf_pass);
        } else {
          viewModel.onShowError();
        }
      },
      onChanged: (_) {
        viewModel.validStateChange(S.of(context).cnf_pass);
      },
      isValid: _isConfirmPasswordValid(context),
    );
  }

  Widget _buildPasswordValidationWidgets(BuildContext context) {
    return Column(
      children: [
        regexWidget(
          isDisable: viewModel.password.text.trim().isEmpty,
          regex: viewModel.atLeast8Character,
          text: S.of(context).at_least_8_characters,
        ),
        xVsSpacing,
        regexWidget(
          isDisable: viewModel.password.text.trim().isEmpty,
          regex: viewModel.atLeastOneOfEachChar,
          text: S.of(context).include_special_character,
        ),
      ],
    );
  }

  Widget _buildTermsAndConditionsRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        VisaCheckbox(
          value: viewModel.termsAndCondition,
          onChanged: (_) => viewModel.termAndConditionChange(),
        ),
        SizedBox(width: 3.r),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: GestureDetector(
              onTap: () => viewModel.termAndConditionChange(),
              child: VisaRichText(
                overflow: TextOverflow.visible,
                textSpans: [
                  VisaTextSpan(
                    text: S.of(context).i_confirm_that,
                    style: VisaTextStyle.walletNormal,
                  ),
                  VisaTextSpan(
                    text: S.of(context).termConditions,
                    style: VisaTextStyle.walletHighlighted,
                    onTap: () async => viewModel.goToTermAndCondition(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyNoticeRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        VisaCheckbox(
          value: viewModel.privacyNotice,
          onChanged: (_) => viewModel.privacyNoticeChange(),
        ),
        SizedBox(width: 3.r),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: GestureDetector(
              onTap: () => viewModel.privacyNoticeChange(),
              child: VisaRichText(
                overflow: TextOverflow.visible,
                textSpans: [
                  VisaTextSpan(
                    text: S.of(context).i_acknowledge_that_i,
                    style: VisaTextStyle.walletNormal,
                  ),
                  VisaTextSpan(
                    text: S.of(context).privacy_notice,
                    style: VisaTextStyle.walletHighlighted,
                    onTap: () async => viewModel.goToPrivacyPolicy(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsErrorWidget(BuildContext context) {
    if (!viewModel.showTermsConditionError) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        top: 10.h,
        left: 10.w,
        bottom: 10.h,
        right: 10.w,
      ),
      child: VisaTextView(
        text: S.of(context).please_acknowledge_all,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: VisaTextStyle.customLarge,
        fontFamily: VisaFontWeight.semibold,
        customColor: VisaColors.error,
        fontSize: Sizes.fourteenInt.toDouble(),
        colorTheme: VisaTextTheme.customTextColor,
      ),
    );
  }

  // Helper methods for error text generation
  String _getEmailErrorText(BuildContext context) {
    if (viewModel.errorText != null) return viewModel.errorText!;
    if (viewModel.email.text.trim().isEmpty) {
      return S.of(context).email_is_required;
    }
    return S.of(context).invalid_email;
  }

  String _getFirstNameErrorText(BuildContext context) {
    if (viewModel.firstName.text.trim().isEmpty) {
      return S.of(context).first_name_is_required;
    }
    return S.of(context).invalid_first_name;
  }

  String _getLastNameErrorText(BuildContext context) {
    if (viewModel.lastName.text.isEmpty) {
      return S.of(context).last_name_is_required;
    }
    return S.of(context).invalid_last_name;
  }

  String _getPasswordErrorText(BuildContext context) {
    if (viewModel.password.text.isEmpty) {
      return S.of(context).password_is_required;
    }
    return S.of(context).invalid_pass;
  }

  // Helper methods for validation logic
  bool _isEmailValid(BuildContext context) {
    if (viewModel.errorText == null) {
      return true;
    }
    if (Validation.emailValid.hasMatch(viewModel.email.text.trim())) {
      return true;
    }
    return !viewModel.formValid.contains(S.of(context).login_username) &&
        viewModel.formValid.isNotEmpty;
  }

  bool _isFirstNameValid(BuildContext context) {
    if (viewModel.firstName.text.length > 1) return true;
    return !viewModel.formValid.contains(S.of(context).first_name) &&
        viewModel.formValid.isNotEmpty;
  }

  bool _isLastNameValid(BuildContext context) {
    if (viewModel.lastName.text.length > 1) return true;
    return !viewModel.formValid.contains(S.of(context).last_name) &&
        viewModel.formValid.isNotEmpty;
  }

  bool _isPasswordValid(BuildContext context) {
    if (Validation.password.hasMatch(viewModel.password.text)) return true;
    return !viewModel.formValid.contains(S.of(context).password) &&
        viewModel.formValid.isNotEmpty;
  }

  bool _isConfirmPasswordValid(BuildContext context) {
    if (viewModel.password.text.trim() ==
        viewModel.confirmPassword.text.trim()) {
      return true;
    }
    return !viewModel.formValid.contains(S.of(context).cnf_pass) &&
        viewModel.formValid.isNotEmpty;
  }
}
