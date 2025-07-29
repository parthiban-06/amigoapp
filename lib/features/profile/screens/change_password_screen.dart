import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_text_field.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/profile/model/change_password_model.dart';
import 'package:visaamigo/features/signup/widgets/regex_widget.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/utils.dart';
import 'package:visaamigo/utils/validation.dart';

import '../../../custom_widgets/visa_appbar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late ChangePasswordModel changePasswordModel;
  late S s;
  late double ten;
  @override
  void initState() {
    super.initState();
    changePasswordModel = GetIt.I<ChangePasswordModel>();
    changePasswordModel.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
    ten = AppSizes.ten;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ChangePasswordModel>(
      viewModel: ChangePasswordModel(),
      setTopSafeArea: false,
      addDefaultPadding: false,
      buildAppBar: _buildAppBar() as PreferredSizeWidget,
      onModelReady: (model) {
        Utils.announceMessage(S.of(context).change_password_screen);
      },
      onPageBuilderMobileView:
          (BuildContext context, ChangePasswordModel viewModel) {
        return _buildMobileView(context, viewModel);
      },
    );
  }

  Widget _buildAppBar() {
    return VisaAppBar(
      isActionButtonShow: true,
      isCancelWithTextButtonShow: true,
      onCancelPress: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildMobileView(BuildContext context, ChangePasswordModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.dimSmall),
      child: Form(
        key: viewModel.formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    _buildRequiredFieldText(context),
                    AppSizes.xxsmallVS,
                    _buildCurrentPasswordField(context, viewModel),
                    _buildNewPasswordField(context, viewModel),
                    _buildConfirmPasswordField(context, viewModel),
                    _buildValidationRules(context, viewModel),
                    AppSizes.mediumVS,
                  ],
                ),
              ),
            ),
            _buildUpdateButton(context, viewModel),
            VisaSizeBox(
              height: AppSizes.heightSmall,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        VisaSizeBox(height: ten),
        Padding(
          padding: EdgeInsets.symmetric(vertical: ten),
          child: VisaTextView(
            text: S.of(context).change_password,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontFamily: VisaFontWeight.semibold,
            fontSize: AppSizes.fontXSmall,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: -1,
          ),
        ),
        VisaSizeBox(height: ten),
      ],
    );
  }

  Widget _buildRequiredFieldText(BuildContext context) {
    return VisaTextView(
      semantics: false,
      text: S.of(context).required_field,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.customLarge,
      fontSize: AppSizes.fontTwelve,
      fontFamily: VisaFontWeight.regular,
      customColor: VisaColors.dividerColor,
      colorTheme: VisaTextTheme.customTextColor,
      letterSpacing: 0,
      lineHeight: (16 / 12.sp).h,
    );
  }

  Widget _buildCurrentPasswordField(
      BuildContext context, ChangePasswordModel viewModel) {
    return VisaTextField(
      controller: viewModel.currentPassword,
      label: S.of(context).current_password,
      errorText: _getCurrentPasswordErrorText(context, viewModel),
      letterSpacing: 0,
      hPaddingInside: 12,
      isPassword: true,
      hint: S.of(context).password,
      onTap: (_) => _handleCurrentPasswordTap(_, viewModel, context),
      onChanged: (_) => _handleCurrentPasswordChange(viewModel, context),
      isValid: _isCurrentPasswordValid(viewModel),
    );
  }

  String _getCurrentPasswordErrorText(
      BuildContext context, ChangePasswordModel viewModel) {
    if (viewModel.errorText != null) {
      return viewModel.errorText!;
    }
    return viewModel.currentPassword.text.trim().isEmpty
        ? S.of(context).current_password_is_required
        : S.of(context).invalid_current_password;
  }

  void _handleCurrentPasswordTap(
      bool isFocused, ChangePasswordModel viewModel, BuildContext context) {
    if (!isFocused) {
      viewModel.validate(S.of(context).current_password);
    } else {
      viewModel.onShowError();
    }
  }

  void _handleCurrentPasswordChange(
      ChangePasswordModel viewModel, BuildContext context) {
    viewModel.validStateChanges(S.of(context).current_password);
  }

  bool _isCurrentPasswordValid(ChangePasswordModel viewModel) {
    return (viewModel.errorText == null &&
            Validation.password.hasMatch(viewModel.currentPassword.text)) ||
        (!viewModel.formValid.contains(S.of(context).current_password) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildNewPasswordField(
      BuildContext context, ChangePasswordModel viewModel) {
    return VisaTextField(
      controller: viewModel.newPassword,
      label: S.of(context).new_pass,
      errorText: _getNewPasswordErrorText(context, viewModel),
      letterSpacing: 0,
      hPaddingInside: 12,
      hint: S.of(context).new_pass,
      isPassword: true,
      onTap: (_) => _handleNewPasswordTap(_, viewModel, context),
      onChanged: (_) => _handleNewPasswordChange(viewModel, context),
      isValid: _isNewPasswordValid(viewModel),
    );
  }

  String _getNewPasswordErrorText(
      BuildContext context, ChangePasswordModel viewModel) {
    return viewModel.newPassword.text.isEmpty
        ? S.of(context).new_password_is_required
        : S.of(context).invalid_new_password;
  }

  void _handleNewPasswordTap(
      bool isFocused, ChangePasswordModel viewModel, BuildContext context) {
    if (!isFocused) {
      viewModel.validate(S.of(context).new_pass);
    } else {
      viewModel.onShowError();
    }
  }

  void _handleNewPasswordChange(
      ChangePasswordModel viewModel, BuildContext context) {
    viewModel.validStateChanges(S.of(context).new_pass);
  }

  bool _isNewPasswordValid(ChangePasswordModel viewModel) {
    return Validation.password.hasMatch(viewModel.newPassword.text) ||
        (!viewModel.formValid.contains(S.of(context).new_pass) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildConfirmPasswordField(
      BuildContext context, ChangePasswordModel viewModel) {
    return VisaTextField(
      controller: viewModel.confirmNewPassword,
      errorText: _getConfirmPasswordErrorText(context, viewModel),
      disableError: true,
      hPaddingInside: 12,
      hint: S.of(context).cnf_pass,
      isPassword: true,
      letterSpacing: 0,
      label: S.of(context).cnf_pass,
      onTap: (_) => _handleConfirmPasswordTap(_, viewModel, context),
      onChanged: (_) => _handleConfirmPasswordChange(viewModel, context),
      isValid: _isConfirmPasswordValid(viewModel),
    );
  }

  String _getConfirmPasswordErrorText(
      BuildContext context, ChangePasswordModel viewModel) {
    return viewModel.confirmNewPassword.text.trim().isEmpty
        ? S.of(context).confirm_password_is_required
        : S.of(context).invalid_cnf_new_pass;
  }

  void _handleConfirmPasswordTap(
      bool isFocused, ChangePasswordModel viewModel, BuildContext context) {
    if (!isFocused) {
      viewModel.validate(S.of(context).cnf_pass);
    } else {
      viewModel.onShowError();
    }
  }

  void _handleConfirmPasswordChange(
      ChangePasswordModel viewModel, BuildContext context) {
    viewModel.validStateChanges(S.of(context).cnf_pass);
  }

  bool _isConfirmPasswordValid(ChangePasswordModel viewModel) {
    return (Validation.password
                .hasMatch(viewModel.confirmNewPassword.text.trim()) &&
            (viewModel.newPassword.text.trim() ==
                viewModel.confirmNewPassword.text.trim())) ||
        (!viewModel.formValid.contains(S.of(context).cnf_pass) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildValidationRules(
      BuildContext context, ChangePasswordModel viewModel) {
    return Column(
      children: [
        AppSizes.xxsmallVS,
        regexWidget(
          regex: viewModel.atLeast8Character,
          text: S.of(context).at_least_8_characters,
          isDisable: viewModel.newPassword.text.trim().isEmpty,
        ),
        AppSizes.xxsmallVS,
        regexWidget(
          regex: viewModel.atLeastOneOfEachChar,
          text: S.of(context).include_special_character,
          isDisable: viewModel.newPassword.text.trim().isEmpty,
        ),
      ],
    );
  }

  Widget _buildUpdateButton(
      BuildContext context, ChangePasswordModel viewModel) {
    return VisaButton(
      text: S.of(context).update,
      height: 54,
      isDisable: !_isUpdateButtonEnabled(viewModel),
      onPressed: () => _handleUpdateButtonPress(viewModel),
      variant: VisaButtonVariant.primary,
    );
  }

  bool _isUpdateButtonEnabled(ChangePasswordModel viewModel) {
    return viewModel.atLeast8Character == true &&
        viewModel.atLeastOneOfEachChar == true;
  }

  void _handleUpdateButtonPress(ChangePasswordModel viewModel) {
    viewModel.changePassword(
      oldPassword: viewModel.currentPassword.text.trim(),
      newPassword: viewModel.newPassword.text.trim(),
    );
  }
}
