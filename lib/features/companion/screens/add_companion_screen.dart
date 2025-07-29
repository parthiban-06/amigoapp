import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/custom_visa_two_button.dart';
import 'package:visaamigo/custom_widgets/visa_checkbox.dart';
import 'package:visaamigo/custom_widgets/visa_custom_chip_column_widget.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_text_field.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/companion/model/list_companion.dart';
import 'package:visaamigo/features/companion/providers/add_companion_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/validation.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/visa_appbar.dart';
import '../../../utils/utils.dart';

class AddCompanionScreen extends StatefulWidget {
  final CompanionProfile? companionProfile;

  const AddCompanionScreen({
    super.key,
    this.companionProfile,
  });

  @override
  State<AddCompanionScreen> createState() => _AddCompanionScreenState();
}

class _AddCompanionScreenState extends State<AddCompanionScreen> {
  late AddCompanionProvider addCompanionProvider;
  late SizedBox vsSpacing;
  late double fontTwelve;
  late double fontfourteen;
  late double ten;
  late double fiveWidth;

  @override
  void initState() {
    super.initState();
    // Retrieve AddCompanionProvider using GetIt
    addCompanionProvider = GetIt.I<AddCompanionProvider>();
    addCompanionProvider.init(widget.companionProfile);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    addCompanionProvider.setContext(context);
    vsSpacing = AppSizes.xxsmallVS;
    fontTwelve = AppSizes.fontTwelve;
    fontfourteen = AppSizes.fontfourteen;
    ten = AppSizes.ten;
    fiveWidth = AppSizes.fiveWidth;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AddCompanionProvider>(
      viewModel: addCompanionProvider,
      setTopSafeArea: false,
      addDefaultPadding: false,
      buildAppBar: _buildAppBar(),
      onModelReady: (model) {
        Utils.announceMessage(S.of(context).companion_screen);
      },
      onPageBuilderMobileView: _buildMobileView,
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

  Widget _buildMobileView(
      BuildContext context, AddCompanionProvider viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.dimSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VisaSizeBox(height: ten),
                    _buildHeader(viewModel),
                    _buildOptionalText(viewModel),
                    _buildFormFields(viewModel),
                    _buildMatchSelectionSection(viewModel),
                    _buildCheckboxesSection(viewModel),
                    VSpacings.small,
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(AddCompanionProvider viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ten),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitle(viewModel),
          if (viewModel.isEdit) _buildDeleteButton(viewModel),
        ],
      ),
    );
  }

  Widget _buildTitle(AddCompanionProvider viewModel) {
    return InkWell(
      onTap: () {
        viewModel.deleteCompanion("");
      },
      child: VisaTextView(
        text: viewModel.isEdit
            ? S.of(context).edit_companion
            : S.of(context).add_travel_companion,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: VisaTextStyle.customLarge,
        fontFamily: VisaFontWeight.semibold,
        fontSize: AppSizes.fontXSmall,
        maxLines: 1,
        customColor: VisaColors.black,
        colorTheme: VisaTextTheme.customTextColor,
        letterSpacing: -1,
      ),
    );
  }

  Widget _buildDeleteButton(AddCompanionProvider viewModel) {
    return Semantics(
      enabled: true,
      button: true,
      label: S.of(context).delete.toUpperCase(),
      child: InkWell(
        onTap: () {
          viewModel.onDelete();
        },
        child: Row(
          children: [
            VisaSvgIcon(
              semantics: false,
              assetPath: Assets.iconsDeleteIcon,
              width: AppSizes.dimMedium,
              height: AppSizes.heightTweentyFour,
              setColorFilter: false,
            ),
            VisaSizeBox(width: 4.w),
            VisaTextView(
              semantics: false,
              text: S.of(context).delete.toUpperCase(),
              softWrap: true,
              overflow: TextOverflow.visible,
              style: VisaTextStyle.customLarge,
              fontFamily: VisaFontWeight.semibold,
              fontSize: fontTwelve,
              customColor: VisaColors.red,
              colorTheme: VisaTextTheme.customTextColor,
              letterSpacing: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalText(AddCompanionProvider viewModel) {
    if (viewModel.isEdit) {
      return VisaSizeBox(height: Sizes.six.h);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOptionalDescription(),
        VisaSizeBox(height: AppSizes.heightSmall),
        _buildRequiredFieldText(),
        VisaSizeBox(height: AppSizes.heightSmall),
      ],
    );
  }

  Widget _buildOptionalDescription() {
    return Semantics(
      container: true,
      enabled: true,
      excludeSemantics: true,
      label: S.of(context).adding_a_companion_is_optional_semantic_label,
      child: VisaTextView(
        semantics: false,
        text: S.of(context).adding_a_companion_is_optional,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: VisaTextStyle.customLarge,
        fontFamily: VisaFontWeight.regular,
        fontSize: fontTwelve,
        lineHeight: 16 / 12,
        customColor: VisaColors.textFieldBorder,
        colorTheme: VisaTextTheme.customTextColor,
        letterSpacing: 0,
      ),
    );
  }

  Widget _buildRequiredFieldText() {
    return VisaTextView(
      semantics: false,
      text: S.of(context).required_field,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.customLarge,
      fontSize: fontTwelve,
      fontFamily: VisaFontWeight.regular,
      customColor: VisaColors.dividerColor,
      colorTheme: VisaTextTheme.customTextColor,
      letterSpacing: 0,
      lineHeight: (16 / 12.sp).h,
    );
  }

  Widget _buildFormFields(AddCompanionProvider viewModel) {
    return Column(
      children: [
        _buildEmailField(viewModel),
        _buildEmailEditNote(viewModel),
        _buildFirstNameField(viewModel),
        _buildLastNameField(viewModel),
        VisaSizeBox(height: Sizes.four.h),
      ],
    );
  }

  Widget _buildEmailField(AddCompanionProvider viewModel) {
    final strings = S.of(context);
    final isEdit = viewModel.isEdit;
    final semanticsLabel = isEdit
        ? "${strings.registered_email}, ${strings.non_editable}, ${viewModel.email.text}"
        : "${strings.edit_box}, ${strings.login_username}, ${strings.double_tap_to_edit}";
    final loginUsername = strings.login_username;
    final companionEmail = strings.companion_email;

    return VisaTextField(
      semanticsLabel: semanticsLabel,
      controller: viewModel.email,
      isRequired: !isEdit,
      hint: loginUsername,
      label: companionEmail,
      isLowerCase: true,
      eventName: _getEventName(viewModel),
      analyticsParameters: viewModel.analyticsParameters,
      disableError: true,
      showSuccessIcon: isEdit,
      isEnable: !isEdit,
      maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
      textInputType: TextInputType.emailAddress,
      errorText: _getEmailErrorText(viewModel),
      onError: (_) {
        viewModel.addToFormError(_);
      },
      letterSpacing: 0,
      onTap: _getFieldOnTap(viewModel, loginUsername),
      onChanged: _getFieldOnChanged(viewModel, loginUsername),
      isValid: _getEmailIsValid(viewModel),
    );
  }

  String _getEventName(AddCompanionProvider viewModel) {
    return viewModel.isEdit
        ? AnalyticsEventConst.EVENT_NAME_EDIT_COMPANION_FORM_ERROR
        : AnalyticsEventConst.EVENT_NAME_COMPANION_FORM_ERROR;
  }

  String _getEmailErrorText(AddCompanionProvider viewModel) {
    return viewModel.errorText ??
        (viewModel.email.text.trim().isEmpty
            ? S.of(context).email_is_required
            : S.of(context).invalid_email);
  }

  Function(bool) _getFieldOnTap(
      AddCompanionProvider viewModel, String fieldName) {
    return (isValid) {
      if (!isValid) {
        viewModel.validate(fieldName);
      } else {
        viewModel.onShowError();
      }
    };
  }

  Function(String) _getFieldOnChanged(
      AddCompanionProvider viewModel, String fieldName) {
    return (_) {
      viewModel.validStateChanges(fieldName);
    };
  }

  bool _getEmailIsValid(AddCompanionProvider viewModel) {
    return viewModel.errorText == null &&
        (Validation.emailValid.hasMatch(viewModel.email.text) ||
            (!viewModel.formValid.contains(S.of(context).login_username) &&
                viewModel.formValid.isNotEmpty));
  }

  Widget _buildEmailEditNote(AddCompanionProvider viewModel) {
    if (!viewModel.isEdit) {
      return const SizedBox();
    }

    return Column(
      children: [
        VisaTextView(
          text: S.of(context).companion_email_cannot_be_edited,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.customLarge,
          fontFamily: VisaFontWeight.regular,
          fontSize: fontTwelve,
          lineHeight: 16 / 12,
          customColor: VisaColors.textFieldBorder,
          colorTheme: VisaTextTheme.customTextColor,
          letterSpacing: 0,
        ),
        VisaSizeBox(height: 6.h),
      ],
    );
  }

  Widget _buildFirstNameField(AddCompanionProvider viewModel) {
    final strings = S.of(context);
    final isEdit = viewModel.isEdit;
    final firstNameLabel = strings.first_name;
    final semanticsLabel = isEdit
        ? "${strings.edit_box}, , $firstNameLabel, ${viewModel.firstName.text}, ${strings.double_tap_to_edit}"
        : "${strings.edit_box}, $firstNameLabel, ${strings.double_tap_to_edit}";

    return VisaTextField(
      semanticsLabel: semanticsLabel,
      controller: viewModel.firstName,
      label: firstNameLabel,
      isRequired: !isEdit,
      eventName: _getEventName(viewModel),
      analyticsParameters: viewModel.analyticsParameters,
      disableError: true,
      errorText: _getFirstNameErrorText(viewModel),
      onError: (_) {
        viewModel.addToFormError(_);
      },
      letterSpacing: 0,
      hint: firstNameLabel,
      onTap: _getFieldOnTap(viewModel, firstNameLabel),
      onChanged: _getFieldOnChanged(viewModel, firstNameLabel),
      isValid: _getFirstNameIsValid(viewModel),
    );
  }

  String _getFirstNameErrorText(AddCompanionProvider viewModel) {
    return viewModel.firstName.text.trim().isEmpty
        ? S.of(context).first_name_is_required
        : S.of(context).invalid_first_name;
  }

  bool _getFirstNameIsValid(AddCompanionProvider viewModel) {
    return viewModel.firstName.text.trim().length > 1 ||
        (!viewModel.formValid.contains(S.of(context).first_name) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildLastNameField(AddCompanionProvider viewModel) {
    final strings = S.of(context);
    final isEdit = viewModel.isEdit;
    final lastNameLabel = strings.last_name;
    final semanticsLabel = isEdit
        ? "${strings.edit_box}, $lastNameLabel, ${viewModel.lastName.text}, ${strings.double_tap_to_edit}"
        : "${strings.edit_box}, $lastNameLabel, ${strings.double_tap_to_edit}";

    return VisaTextField(
      semanticsLabel: semanticsLabel,
      isRequired: !isEdit,
      controller: viewModel.lastName,
      errorText: _getLastNameErrorText(viewModel),
      onError: (_) {
        viewModel.addToFormError(_);
      },
      eventName: _getEventName(viewModel),
      analyticsParameters: viewModel.analyticsParameters,
      disableError: true,
      hint: lastNameLabel,
      letterSpacing: 0,
      label: lastNameLabel,
      onTap: _getFieldOnTap(viewModel, lastNameLabel),
      onChanged: _getFieldOnChanged(viewModel, lastNameLabel),
      isValid: _getLastNameIsValid(viewModel),
    );
  }

  String _getLastNameErrorText(AddCompanionProvider viewModel) {
    return viewModel.lastName.text.trim().isEmpty
        ? S.of(context).last_name_is_required
        : S.of(context).invalid_last_name;
  }

  bool _getLastNameIsValid(AddCompanionProvider viewModel) {
    return viewModel.lastName.text.trim().length > 1 ||
        (!viewModel.formValid.contains(S.of(context).last_name) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildMatchSelectionSection(AddCompanionProvider viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMatchTitle(),
        VisaSizeBox(height: Sizes.six.h),
        _buildMatchDescription(),
        VisaSizeBox(height: Sizes.six.toDouble()),
        _buildMatchChips(viewModel),
        _buildMatchError(viewModel),
        AppSizes.mediumVS,
      ],
    );
  }

  Widget _buildMatchTitle() {
    return VisaTextView(
      text: S.of(context).which_match_will.toUpperCase(),
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.customLarge,
      fontFamily: VisaFontWeight.medium,
      fontSize: fontTwelve,
      lineHeight: 16.8 / 12,
      customColor: VisaColors.black,
      colorTheme: VisaTextTheme.customTextColor,
      letterSpacing: 2,
    );
  }

  Widget _buildMatchDescription() {
    return VisaTextView(
      text: S.of(context).select_all_that,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.customLarge,
      fontFamily: VisaFontWeight.medium,
      fontSize: fontTwelve,
      lineHeight: 16 / 12,
      customColor: VisaColors.textFieldBorder,
      colorTheme: VisaTextTheme.customTextColor,
      letterSpacing: 0,
    );
  }

  Widget _buildMatchChips(AddCompanionProvider viewModel) {
    return VisaCustomChipColumnWidget(
      parentIndex: 0,
      isOpacity: true,
      chips: viewModel.editMatchList + viewModel.matchList,
      onChipTap: (parentIndex, chipIndex) {
        viewModel.setCompanionForEvent("companionDetails_matchSelection",options: {
          "match_selected": (viewModel.editMatchList + viewModel.matchList).elementAt(chipIndex).optionName ?? "",
          "selection_status": "select"
        });
        viewModel.changeMatchList(chipIndex);
      },
      spacing: Sizes.four.toDouble(),
      runSpacing: AppSizes.zeroInt.toDouble(),
      borderRadius: Sizes.fifty,
      borderWidth: Sizes.oneInt.toDouble(),
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.twelveInt.w,
        vertical: Sizes.eightInt.h,
      ),
      textStyle: VisaTextStyle.displayBodyS,
      selectedFontWeight: FontWeight.w700,
      unselectedFontWeight: FontWeight.w500,
      selectedTextColor: VisaColors.white,
      unselectedTextColor: VisaColors.black,
      borderColor: VisaColors.black,
      lineHeight: (18 / 14).toDouble(),
      selectedGradient: const LinearGradient(
        begin: Alignment(-0.98, 0.17),
        end: Alignment(0.98, -0.17),
        colors: [
          VisaColors.primary,
          VisaColors.blueTextLight,
        ],
      ),
    );
  }

  Widget _buildMatchError(AddCompanionProvider viewModel) {
    if (!viewModel.showMatchListError) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(top: 5.h, left: fiveWidth),
      child: VisaTextView(
        text: S.of(context).match_list_error,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: VisaTextStyle.customLarge,
        fontFamily: VisaFontWeight.semibold,
        fontSize: fontfourteen,
        customColor: VisaColors.error,
        colorTheme: VisaTextTheme.customTextColor,
        letterSpacing: 0,
      ),
    );
  }

  Widget _buildCheckboxesSection(AddCompanionProvider viewModel) {
    return Column(
      children: [
        _buildAcknowledgeCheckbox(viewModel),
        vsSpacing,
        _buildAgreeCheckbox(viewModel),
        _buildCheckboxError(viewModel),
      ],
    );
  }

  Widget _buildAcknowledgeCheckbox(AddCompanionProvider viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        VisaCheckbox(
          isPadding: false,
          semanticsLabel: S.of(context).i_acknowledge_label,
          variant: _getCheckboxVariant(viewModel),
          value: viewModel.iAcknowledge,
          onChanged: (_) {
            viewModel.onChangeAcknowledge();
          },
        ),
        SizedBox(width: 8.r),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: AppSizes.heightFour),
            child: Semantics(
              enabled: true,
              label: S.of(context).i_acknowledge_that,
              child: GestureDetector(
                onTap: () {
                  viewModel.onChangeAcknowledge();
                },
                child: VisaTextView(
                  text: S.of(context).i_acknowledge_that,
                  semantics: false,
                  overflow: TextOverflow.fade,
                  style: VisaTextStyle.displayBodyS,
                  customColor: VisaColors.black,
                  colorTheme: VisaTextTheme.customTextColor,
                  fontFamily: VisaFontWeight.regular,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreeCheckbox(AddCompanionProvider viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        VisaCheckbox(
          isPadding: false,
          semanticsLabel: S.of(context).give_permission_label,
          variant: _getCheckboxVariant(viewModel),
          value: viewModel.iAgree,
          onChanged: (_) {
            viewModel.onChangeAgree();
          },
        ),
        SizedBox(width: 8.r),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Semantics(
              enabled: true,
              label: S.of(context).my_companion_has_given,
              child: GestureDetector(
                onTap: () {
                  viewModel.onChangeAgree();
                },
                child: VisaTextView(
                  text: S.of(context).my_companion_has_given,
                  semantics: false,
                  overflow: TextOverflow.fade,
                  style: VisaTextStyle.displayBodyS,
                  customColor: VisaColors.black,
                  colorTheme: VisaTextTheme.customTextColor,
                  fontFamily: VisaFontWeight.regular,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  VisaCheckboxVariant _getCheckboxVariant(AddCompanionProvider viewModel) {
    return viewModel.isEdit
        ? VisaCheckboxVariant.grey
        : VisaCheckboxVariant.primary;
  }

  Widget _buildCheckboxError(AddCompanionProvider viewModel) {
    if (!viewModel.showIAcknowledgeIAgreeError) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(top: ten, left: fiveWidth),
      child: VisaTextView(
        text: S.of(context).iAcknowledge_and_iAgree_error,
        overflow: TextOverflow.fade,
        style: VisaTextStyle.displayBodyS,
        customColor: VisaColors.error,
        fontSize: fontfourteen,
        colorTheme: VisaTextTheme.customTextColor,
        fontFamily: VisaFontWeight.medium,
      ),
    );
  }

  Widget _buildActionButtons(AddCompanionProvider viewModel) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.sixteenRadius,
        right: AppSizes.sixteenRadius,
        bottom: AppSizes.sixteenRadius,
      ),
      child: Column(
        children: [
          CustomTwoButtons(
            leftButtonText: _getLeftButtonText(viewModel),
            rightButtonText: _getRightButtonText(viewModel),
            rightButtonDisable: !viewModel.isDisable,
            onLeftButtonPressed: () {
              viewModel.navPop();
            },
            onRightButtonPressed: () async {
              await viewModel.addCompanion();
            },
            isRightButtonLoading: false,
            isLeftButtonLoading: false,
          ),
        ],
      ),
    );
  }

  String _getLeftButtonText(AddCompanionProvider viewModel) {
    return viewModel.isEdit ? S.of(context).cancel : S.of(context).back;
  }

  String _getRightButtonText(AddCompanionProvider viewModel) {
    return viewModel.isEdit ? S.of(context).update : S.of(context).add;
  }
}
