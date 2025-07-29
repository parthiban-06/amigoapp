import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/custom_widgets/visa_text_field.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/profile/model/edit_profile_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;
import 'package:visaamigo/utils/validation.dart';

import '../../../custom_widgets/visa_appbar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late EditProfileModel editProfileModel;
  late S s;
  late double ten;

  @override
  void initState() {
    super.initState();
    editProfileModel = GetIt.I<EditProfileModel>();
    editProfileModel.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
    ten = AppSizes.ten;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EditProfileModel>(
      viewModel: editProfileModel,
      setTopSafeArea: false,
      addDefaultPadding: false,
      buildAppBar: _buildAppBar(),
      onPageBuilderMobileView:
          (BuildContext context, EditProfileModel viewModel) {
        return _buildMobileView(context, viewModel);
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return VisaAppBar(
      isActionButtonShow: true,
      isCancelWithTextButtonShow: true,
      onCancelPress: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildMobileView(BuildContext context, EditProfileModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.dimSmall),
      child: Form(
        key: viewModel.formKey,
        child: Column(
          children: [
            _buildFormContent(context, viewModel),
            _buildUpdateButton(context, viewModel),
            VisaSizeBox(
              height: AppSizes.heightSmall,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, EditProfileModel viewModel) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildEmailField(context, viewModel),
            _buildFirstNameField(context, viewModel),
            _buildLastNameField(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        VisaSizeBox(height: ten),
        Padding(
          padding: EdgeInsets.symmetric(vertical: ten),
          child: VisaTextView(
            text: S.of(context).edit_profile_details,
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

  Widget _buildEmailField(BuildContext context, EditProfileModel viewModel) {
    final strings = S.of(context);
    final semanticsLabel =
        "${strings.registered_email}, ${strings.non_editable}, ${viewModel.email.text}";
    final label = strings.your_registered_email;

    return VisaTextField(
      semanticsLabel: semanticsLabel,
      controller: viewModel.email,
      hint: label,
      maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
      textInputType: TextInputType.emailAddress,
      showSuccessIcon: true,
      isEnable: false,
      label: label,
      letterSpacing: 0,
      errorText: _getEmailErrorText(viewModel),
      onError: (_){
        viewModel.addToFormError(_);
      },
      onTap: (isValid) => _handleEmailTap(viewModel, isValid),
      onChanged: (_) => _handleEmailChange(viewModel),
      isValid: _isEmailValid(viewModel),
    );
  }

  String _getEmailErrorText(EditProfileModel viewModel) {
    return viewModel.errorText ??
        (viewModel.email.text.trim().isEmpty
            ? S.of(context).email_is_required
            : S.of(context).invalid_email);
  }

  void _handleEmailTap(EditProfileModel viewModel, bool isValid) {
    if (!isValid) {
      viewModel.validate(S.of(context).your_registered_email);
    } else {
      viewModel.onShowError();
    }
  }

  void _handleEmailChange(EditProfileModel viewModel) {
    viewModel.validStateChanges(S.of(context).your_registered_email);
  }

  bool _isEmailValid(EditProfileModel viewModel) {
    return viewModel.errorText == null &&
            Validation.emailValid.hasMatch(viewModel.email.text) ||
        (!viewModel.formValid.contains(S.of(context).your_registered_email) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildFirstNameField(
      BuildContext context, EditProfileModel viewModel) {
    final strings = S.of(context);
    final firstNameLabel = strings.first_name;
    final semanticsLabel = viewModel.firstName.text.isNotEmpty
        ? "${strings.edit_box}, $firstNameLabel, ${viewModel.firstName.text}, ${strings.double_tap_to_edit}"
        : "${strings.edit_box}, $firstNameLabel, ${strings.double_tap_to_edit}";

    return VisaTextField(
      semanticsLabel: semanticsLabel,
      controller: viewModel.firstName,
      label: firstNameLabel,
      disableError: true,
      letterSpacing: 0,
      hint: firstNameLabel,
      errorText: _getFirstNameErrorText(viewModel),
      onError: (_){
        viewModel.addToFormError(_);
      },
      onTap: (isValid) => _handleFirstNameTap(viewModel, isValid),
      onChanged: (_) => _handleFirstNameChange(viewModel),
      isValid: _isFirstNameValid(viewModel),
    );
  }

  String _getFirstNameErrorText(EditProfileModel viewModel) {
    return viewModel.firstName.text.trim().isEmpty
        ? S.of(context).first_name_is_required
        : S.of(context).invalid_first_name;
  }

  void _handleFirstNameTap(EditProfileModel viewModel, bool isValid) {
    if (!isValid) {
      viewModel.validate(S.of(context).first_name);
    } else {
      viewModel.onShowError();
    }
  }

  void _handleFirstNameChange(EditProfileModel viewModel) {
    viewModel.validStateChanges(S.of(context).first_name);
  }

  bool _isFirstNameValid(EditProfileModel viewModel) {
    return viewModel.firstName.text.trim().length > 1 ||
        (!viewModel.formValid.contains(S.of(context).first_name) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildLastNameField(BuildContext context, EditProfileModel viewModel) {
    final strings = S.of(context);
    final lastNameLabel = strings.last_name;
    final semanticsLabel = viewModel.lastName.text.isNotEmpty
        ? "${strings.edit_box}, $lastNameLabel, ${viewModel.lastName.text}, ${strings.double_tap_to_edit}"
        : "${strings.edit_box}, $lastNameLabel, ${strings.double_tap_to_edit}";

    return VisaTextField(
      semanticsLabel: semanticsLabel,
      controller: viewModel.lastName,
      disableError: true,
      hint: lastNameLabel,
      letterSpacing: 0,
      label: lastNameLabel,
      errorText: _getLastNameErrorText(viewModel),
      onError: (_){
        viewModel.addToFormError(_);
      },
      onTap: (isValid) => _handleLastNameTap(viewModel, isValid),
      onChanged: (_) => _handleLastNameChange(viewModel),
      isValid: _isLastNameValid(viewModel),
    );
  }

  String _getLastNameErrorText(EditProfileModel viewModel) {
    return viewModel.lastName.text.trim().isEmpty
        ? S.of(context).last_name_is_required
        : S.of(context).invalid_last_name;
  }

  void _handleLastNameTap(EditProfileModel viewModel, bool isValid) {
    if (!isValid) {
      viewModel.validate(S.of(context).last_name);
    } else {
      viewModel.onShowError();
    }
  }

  void _handleLastNameChange(EditProfileModel viewModel) {
    viewModel.validStateChanges(S.of(context).last_name);
  }

  bool _isLastNameValid(EditProfileModel viewModel) {
    return viewModel.lastName.text.trim().length > 1 ||
        (!viewModel.formValid.contains(S.of(context).last_name) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildUpdateButton(BuildContext context, EditProfileModel viewModel) {
    return VisaButton(
      text: S.of(context).update,
      height: 54,
      isDisable: _isUpdateButtonDisabled(viewModel),
      onPressed: () => _handleUpdatePressed(viewModel),
      variant: VisaButtonVariant.primary,
    );
  }

  bool _isUpdateButtonDisabled(EditProfileModel viewModel) {
    final hasValidNames = viewModel.lastName.text.length > 1 &&
        viewModel.firstName.text.length > 1;
    final hasChanges =
        viewModel.changeFirstName != viewModel.firstName.text.trim() ||
            viewModel.changeLastName != viewModel.lastName.text.trim();

    return !hasValidNames || !hasChanges;
  }

  void _handleUpdatePressed(EditProfileModel viewModel) {
    if (_isUpdateButtonDisabled(viewModel)) {
      _showSuccessSnackBar(
          context, S.of(context).no_change_detected_message_in_form);
      return;
    }
    viewModel.updateUserName(
      firstName: viewModel.firstName.text.trim(),
      lastName: viewModel.lastName.text.trim(),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      visaSnackBar(
        context: context,
        title: "${S.of(context).success}!",
        subtitle: message,
        showAtBottom: true,
        isNavBar: true,
      );
    }
  }
}
