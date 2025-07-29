import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/custom_visa_two_button.dart';
import 'package:visaamigo/custom_widgets/visa_custom_chip_column_widget.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_text_field.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/itinerary/providers/add_itinerary_provider.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/ui/provider/theme_provider.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../custom_widgets/visa_appbar.dart';
import '../../../custom_widgets/visa_appbar_actions.dart';
import '../../../utils/app_const.dart';
import '../../../utils/utils.dart';
import '../../itinerary/providers/itinerary_provider.dart';
import '../models/event_list_model.dart';

class AddItineraryScreen extends StatelessWidget {
  final EventList? eventModel;
  final String? location;
  final String? dateTime;

  AddItineraryScreen({
    super.key,
    this.eventModel,
    this.location,
    this.dateTime,
  });

  late SelectLanguageGenericProvider localLanguageProvider;

  @override
  Widget build(BuildContext context) {
    final itineraryProvider =
        Provider.of<ItineraryProvider>(context, listen: false);
    localLanguageProvider =
        Provider.of<SelectLanguageGenericProvider>(context, listen: false);

    return BaseView<AddItineraryProvider>(
      viewModel: AddItineraryProvider(),
      setTopSafeArea: false,
      addDefaultPadding: false,
      buildAppBar: _buildAppBar(context),
      onModelReady: (model) =>
          _initializeModel(model, itineraryProvider, context),
      onPageBuilderMobileView:
          (BuildContext context, AddItineraryProvider viewModel) {
        return Padding(
          padding: EdgeInsets.all(Sizes.sixteenInt.w),
          child: Column(
            children: [
              _buildHeader(context, viewModel),
              Expanded(
                child: SingleChildScrollView(
                  controller: viewModel.addItineraryController,
                  child: _buildForm(context, viewModel),
                ),
              ),
              _buildActionButtons(context, viewModel),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return VisaAppBar(
      isActionButtonShow: true,
      isCancelWithTextButtonShow: true,
      onCancelPress: () => context.pop(),
    );
  }

  void _initializeModel(AddItineraryProvider model,
      ItineraryProvider itineraryProvider, BuildContext context) {
    model.init(eventModel, itineraryProvider, location, dateTime);
    final message = eventModel != null
        ? S.of(context).edit_event
        : S.of(context).add_itinerary_screen;
    Utils.announceMessage(message);
  }

  Widget _buildHeader(BuildContext context, AddItineraryProvider viewModel) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTitle(context),
        const Spacer(),
        if (_shouldShowDeleteButton()) _buildDeleteButton(context, viewModel),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    final title = eventModel == null
        ? S.of(context).add_new_event
        : S.of(context).edit_event;
    return VisaTextView(
      text: title,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.customLarge,
      fontFamily: VisaFontWeight.semibold,
      fontSize: Sizes.twentyFourInt.h,
      lineHeight: Sizes.twentyFiveInt.h / Sizes.twentyFourInt.sp,
      customColor: VisaColors.black,
      colorTheme: VisaTextTheme.customTextColor,
      letterSpacing: -1,
    );
  }

  bool _shouldShowDeleteButton() {
    return eventModel != null &&
        eventModel?.type == AppConst.ITINERARY_TYPE_EVENT;
  }

  Widget _buildDeleteButton(
      BuildContext context, AddItineraryProvider viewModel) {
    return VisaAppBarActions(
      onPressed: () => viewModel.deleteEvent(context),
      visaTextStyle: VisaTextStyle.bodyMedium,
      visaTextTheme: VisaTextTheme.customTextColor,
      isIconShow: true,
      isTextShow: true,
      text: S.of(context).delete.toUpperCase(),
      svgIconPath: Assets.iconsDeleteIcon,
      iconColor: VisaColors.red,
      iconSize: Sizes.twentyFour,
      letterSpacing: Sizes.two,
      customColor: VisaColors.red,
      padding: EdgeInsets.only(right: Sizes.zero),
      isComeFromAppBar: false,
    );
  }

  Widget _buildForm(BuildContext context, AddItineraryProvider viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRequiredFieldText(context),
          _buildEventNameField(context, viewModel),
          _buildDateField(context, viewModel),
          _buildTimeFields(context, viewModel),
          _buildTimeInstructions(context),
          _buildLocationField(context, viewModel),
          _buildDescriptionSection(context, viewModel),
          _buildCategorySection(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildRequiredFieldText(BuildContext context) {
    return Column(
      children: [
        VisaSizeBox(height: Sizes.sixteenInt.h),
        VisaTextView(
          semantics: false,
          text: S.of(context).required_field,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.customLarge,
          fontSize: Sizes.twelveInt.h,
          fontFamily: VisaFontWeight.regular,
          customColor: VisaColors.dividerColor,
          colorTheme: VisaTextTheme.customTextColor,
          letterSpacing: 0,
          lineHeight: (Sizes.sixteenInt / Sizes.twelveInt.sp).h,
        ),
        const VisaSizeBox(height: 16),
      ],
    );
  }

  Widget _buildEventNameField(
      BuildContext context, AddItineraryProvider viewModel) {
    return VisaTextField(
      controller: viewModel.eventName,
      disableError: true,
      onError: (_) {
        viewModel.addToFormError(_);
      },
      maxLength: AppConst.TEXTFIELD_GENERIC_LENGTH,
      label: S.of(context).event_name,
      hint: S.of(context).event_name,
      semanticsLabel: _buildEventNameSemanticsLabel(context, viewModel),
      errorText: _getEventNameErrorText(context, viewModel),
      textInputType: TextInputType.name,
      isCapitalFirstLetter: true,
      letterSpacing: 0,
      onTap: (isReadOnly) =>
          _handleEventNameTap(isReadOnly, context, viewModel),
      onChanged: (_) => viewModel.validStateChanges(S.of(context).event_name),
      isValid: _isEventNameValid(context, viewModel),
    );
  }

  String _buildEventNameSemanticsLabel(
      BuildContext context, AddItineraryProvider viewModel) {
    final text = viewModel.eventName.text.trim().isNotEmpty
        ? viewModel.eventName.text
        : S.of(context).event_name;
    return "$text, ${S.of(context).text_field}, ${S.of(context).double_tap_to_edit}";
  }

  String? _getEventNameErrorText(
      BuildContext context, AddItineraryProvider viewModel) {
    return viewModel.errorText ??
        (viewModel.eventName.text.trim().isEmpty
            ? S.of(context).event_name_is_required
            : S.of(context).event_name_is_invalid);
  }

  void _handleEventNameTap(
      bool isReadOnly, BuildContext context, AddItineraryProvider viewModel) {
    if (!isReadOnly) {
      viewModel.validate(S.of(context).event_name, eventModel == null);
    } else {
      viewModel.onShowError();
    }
  }

  bool _isEventNameValid(BuildContext context, AddItineraryProvider viewModel) {
    return viewModel.eventName.text.trim().isNotEmpty ||
        (!viewModel.formValid.contains(S.of(context).event_name) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildDateField(BuildContext context, AddItineraryProvider viewModel) {
    return VisaTextField(
      controller: viewModel.date,
      disableError: true,
      readOnly: true,
      label: S.of(context).date,
      hint: S.of(context).date_format,
      semanticsLabel: _buildDateSemanticsLabel(context, viewModel),
      suffixIcon: _buildDateSuffixIcon(context, viewModel),
      textInputType: TextInputType.number,
      letterSpacing: 0,
      errorText: _getDateErrorText(context, viewModel),
      onError: (_) {
        viewModel.addToFormError(_);
      },
      onTap: (isReadOnly) => _handleDateTap(isReadOnly, context, viewModel),
      onChanged: (_) => viewModel.validStateChanges(S.of(context).date),
      isValid: _isDateValid(context, viewModel),
    );
  }

  String _buildDateSemanticsLabel(
      BuildContext context, AddItineraryProvider viewModel) {
    final text = viewModel.date.text.trim().isNotEmpty
        ? viewModel.date.text
        : S.of(context).date_format;
    return "$text, ${S.of(context).date_field}, ${S.of(context).double_tap_to_edit}";
  }

  Widget _buildDateSuffixIcon(
      BuildContext context, AddItineraryProvider viewModel) {
    return Padding(
      padding: EdgeInsets.only(
          right: _getDateSuffixPadding(context, viewModel),
          left: localLanguageProvider.isRTL
              ? _getDateSuffixPadding(context, viewModel)
              : 0),
      child: InkWell(
        onTap: () => viewModel.pickDate(),
        child: VisaSvgIcon(
          assetPath: Assets.iconsIcCalendar,
          width: Sizes.twentyFourInt.w,
          height: Sizes.twentyFourInt.h,
          color: VisaColors.primary,
        ),
      ),
    );
  }

  double _getDateSuffixPadding(
      BuildContext context, AddItineraryProvider viewModel) {
    return !(viewModel.date.text.length > 1 ||
            (!viewModel.formValid.contains(S.of(context).date) &&
                viewModel.formValid.isNotEmpty))
        ? Sizes.tenInt.w
        : Sizes.tenInt.w;
  }

  String _getDateErrorText(
      BuildContext context, AddItineraryProvider viewModel) {
    return viewModel.date.text.isEmpty
        ? S.of(context).date_is_required
        : S.of(context).date_is_invalid;
  }

  void _handleDateTap(
      bool isReadOnly, BuildContext context, AddItineraryProvider viewModel) {
    if (!isReadOnly) {
      viewModel.validate(S.of(context).date, eventModel == null);
    } else {
      viewModel.pickDate();
    }
  }

  bool _isDateValid(BuildContext context, AddItineraryProvider viewModel) {
    return viewModel.date.text.length > 1 ||
        (!viewModel.formValid.contains(S.of(context).date) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildTimeFields(
      BuildContext context, AddItineraryProvider viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child: _buildStartTimeField(context, viewModel)),
        _buildTimeSeparator(),
        Expanded(child: _buildEndTimeField(context, viewModel)),
      ],
    );
  }

  Widget _buildStartTimeField(
      BuildContext context, AddItineraryProvider viewModel) {
    return VisaTextField(
      labelSemanticsIndex: 1,
      semanticsIndex: 2,
      controller: viewModel.start,
      disableError: true,
      readOnly: true,
      label: S.of(context).start,
      hint: S.of(context).time_default,
      textInputType: TextInputType.datetime,
      letterSpacing: 0,
      semanticsLabel: _buildStartTimeSemanticsLabel(context, viewModel),
      errorText: _getStartTimeErrorText(context, viewModel),
      onError: (_) {
        viewModel.addToFormError(_);
      },
      onTap: (isReadOnly) =>
          _handleStartTimeTap(isReadOnly, context, viewModel),
      onChanged: (_) => viewModel.validStateChanges(S.of(context).start),
      isValid: _isStartTimeValid(context, viewModel),
    );
  }

  String _buildStartTimeSemanticsLabel(
      BuildContext context, AddItineraryProvider viewModel) {
    final text = viewModel.start.text.trim().isNotEmpty
        ? viewModel.start.text
        : S.of(context).zero_colon_format;
    return "${S.of(context).start_time_field}, $text, ${S.of(context).double_tap_to_edit}";
  }

  String? _getStartTimeErrorText(
      BuildContext context, AddItineraryProvider viewModel) {
    return viewModel.errorTextStart ??
        (viewModel.start.text.isEmpty
            ? S.of(context).start_time_is_required
            : S.of(context).start_time_is_invalid);
  }

  void _handleStartTimeTap(
      bool isReadOnly, BuildContext context, AddItineraryProvider viewModel) {
    if (!isReadOnly) {
      viewModel.validate(S.of(context).start, eventModel == null);
    } else {
      viewModel.pickTime(true);
      viewModel.onShowError();
    }
  }

  bool _isStartTimeValid(BuildContext context, AddItineraryProvider viewModel) {
    return (viewModel.errorTextStart == null &&
            viewModel.start.text.length > 1) ||
        (!viewModel.formValid.contains(S.of(context).start) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildTimeSeparator() {
    return Padding(
      padding: EdgeInsets.only(
        left: Sizes.tenInt.w,
        top: Sizes.sixtyInt.h,
        right: Sizes.tenInt.w,
      ),
      child: Container(
        width: Sizes.fourteen.w,
        height: Sizes.oneInt.h,
        color: VisaColors.black,
      ),
    );
  }

  Widget _buildEndTimeField(
      BuildContext context, AddItineraryProvider viewModel) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return VisaTextField(
      labelSemanticsIndex: 3,
      semanticsIndex: 4,
      maxLines: 1,
      labelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        fontFamily: "VisaDialectUI",
        letterSpacing: 1,
        height: 1.40,
        color: themeProvider.isDarkMode
            ? VisaColors.white
            : VisaColors.black, // <-- updated line
      ),
      controller: viewModel.end,
      disableError: true,
      isRequired: false,
      readOnly: true,
      label: S.of(context).end_optional,
      hint: S.of(context).time_default,
      textInputType: TextInputType.datetime,
      semanticsLabel: _buildEndTimeSemanticsLabel(context, viewModel),
      letterSpacing: 0,
      onTap: (isReadOnly) => _handleEndTimeTap(isReadOnly, viewModel),
      onChanged: (_) => viewModel.updateEditState(),
      isValid: true,
    );
  }

  String _buildEndTimeSemanticsLabel(
      BuildContext context, AddItineraryProvider viewModel) {
    final text = viewModel.end.text.trim().isNotEmpty
        ? viewModel.end.text
        : S.of(context).zero_colon_format;
    return "${S.of(context).end_time_field} ${S.of(context).optional}, $text, ${S.of(context).double_tap_to_edit}";
  }

  void _handleEndTimeTap(bool isReadOnly, AddItineraryProvider viewModel) {
    if (isReadOnly) {
      viewModel.pickTime(false);
    }
  }

  Widget _buildTimeInstructions(BuildContext context) {
    return Column(
      children: [
        VisaTextView(
          text: S.of(context).enter_time_using,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.customLarge,
          fontSize: Sizes.twelveInt.h,
          fontFamily: VisaFontWeight.regular,
          customColor: VisaColors.dividerColor,
          colorTheme: VisaTextTheme.customTextColor,
          letterSpacing: 0,
          lineHeight: (Sizes.sixteenInt / Sizes.twelveInt.sp).h,
        ),
        VSpacings.xsmall,
      ],
    );
  }

  Widget _buildLocationField(
      BuildContext context, AddItineraryProvider viewModel) {
    return VisaTextField(
      controller: viewModel.locationEdt,
      disableError: true,
      label: S.of(context).location,
      hint: S.of(context).location,
      textInputType: TextInputType.name,
      letterSpacing: 0,
      readOnly: true,
      semanticsLabel: _buildLocationSemanticsLabel(context, viewModel),
      maxLength: AppConst.TEXTFIELD_GENERIC_LENGTH,
      errorText: _getLocationErrorText(context, viewModel),
      onError: (_) {
        viewModel.addToFormError(_);
      },
      onTap: (isReadOnly) => _handleLocationTap(isReadOnly, context, viewModel),
      onChanged: (_) => viewModel.validStateChanges(S.of(context).location),
      isValid: _isLocationValid(context, viewModel),
    );
  }

  String _buildLocationSemanticsLabel(
      BuildContext context, AddItineraryProvider viewModel) {
    final text = viewModel.locationEdt.text.trim().isNotEmpty
        ? viewModel.locationEdt.text
        : S.of(context).location;
    return "$text, ${S.of(context).text_field}, ${S.of(context).double_tap_to_edit}";
  }

  String _getLocationErrorText(
      BuildContext context, AddItineraryProvider viewModel) {
    return viewModel.locationEdt.text.isEmpty
        ? S.of(context).location_is_required
        : S.of(context).location_is_invalid;
  }

  void _handleLocationTap(
      bool isReadOnly, BuildContext context, AddItineraryProvider viewModel) {
    if (!isReadOnly) {
      viewModel.validate(S.of(context).location, eventModel == null);
    } else {
      viewModel.onShowError();
      viewModel.goToLocationScreen();
    }
  }

  bool _isLocationValid(BuildContext context, AddItineraryProvider viewModel) {
    return viewModel.locationEdt.text.length > 1 ||
        (!viewModel.formValid.contains(S.of(context).location) &&
            viewModel.formValid.isNotEmpty);
  }

  Widget _buildDescriptionSection(
      BuildContext context, AddItineraryProvider viewModel) {
    return Column(
      children: [
        _buildDescriptionHeader(context),
        VSpacings.xsmall,
        _buildDescriptionField(context, viewModel),
      ],
    );
  }

  Widget _buildDescriptionHeader(BuildContext context) {
    return VisaTextView(
      text: S.of(context).adding_to_your_itinerary,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.customLarge,
      fontSize: Sizes.twelve,
      fontFamily: VisaFontWeight.regular,
      customColor: VisaColors.dividerColor,
      colorTheme: VisaTextTheme.customTextColor,
      letterSpacing: 0,
      lineHeight: 1.33,
    );
  }

  Widget _buildDescriptionField(
      BuildContext context, AddItineraryProvider viewModel) {
    return VisaTextField(
      controller: viewModel.description,
      disableError: true,
      isRequired: false,
      label: S.of(context).description_optional,
      hint: S.of(context).notes,
      textInputType: TextInputType.name,
      letterSpacing: 0,
      maxLength: AppConst.TEXTFIELD_GENERIC_LENGTH,
      semanticsLabel: _buildDescriptionSemanticsLabel(context, viewModel),
      onTap: (_) {},
      onChanged: (_) => viewModel.updateEditState(),
      isValid: true,
    );
  }

  String _buildDescriptionSemanticsLabel(
      BuildContext context, AddItineraryProvider viewModel) {
    final text = viewModel.description.text.trim().isNotEmpty
        ? viewModel.description.text
        : S.of(context).notes;
    return "$text, ${S.of(context).text_field}, ${S.of(context).double_tap_to_edit}";
  }

  Widget _buildCategorySection(
      BuildContext context, AddItineraryProvider viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const VisaSizeBox(height: 4),
        _buildCategoryHeader(context),
        VisaSizeBox(height: Sizes.fourInt.h),
        if (viewModel.showCategoryError)
          _buildCategoryError(context, viewModel),
        _buildCategoryChips(context, viewModel),
        VSpacings.small,
      ],
    );
  }

  Widget _buildCategoryHeader(BuildContext context) {
    return VisaTextView(
      semanticsLabel: S.of(context).category_required,
      text: S.of(context).category_optional.toUpperCase(),
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.custom,
      fontSize: Sizes.twelveInt.sp,
      fontFamily: VisaFontWeight.medium,
      customColor: VisaColors.black,
      colorTheme: VisaTextTheme.customTextColor,
      letterSpacing: 2,
      lineHeight: 1.40,
    );
  }

  Widget _buildCategoryError(
      BuildContext context, AddItineraryProvider viewModel) {
    return Padding(
      key: viewModel.categoryErrorSectionKey,
      padding: EdgeInsets.only(
        top: Sizes.fiveInt.h,
        left: Sizes.fiveInt.w,
        bottom: Sizes.six.r,
      ),
      child: VisaTextView(
        text: S.of(context).category_is_required,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: VisaTextStyle.customLarge,
        fontFamily: VisaFontWeight.semibold,
        customColor: VisaColors.error,
        fontSize: 12.sp,
        colorTheme: VisaTextTheme.customTextColor,
      ),
    );
  }

  Widget _buildCategoryChips(
      BuildContext context, AddItineraryProvider viewModel) {
    return VisaCustomChipColumnWidget(
      parentIndex: 0,
      isOpacity: true,
      chips: viewModel.categoryList,
      onChipTap: (parentIndex, chipIndex) =>
          _handleCategoryChipTap(chipIndex, viewModel),
      spacing: Sizes.eight.toDouble(),
      runSpacing: Sizes.zeroInt.toDouble(),
      borderRadius: Sizes.fifty,
      borderWidth: Sizes.oneInt.toDouble(),
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.twelveInt.w,
        vertical: Sizes.eightInt.h,
      ),
      textStyle: VisaTextStyle.displayBodyS,
      selectedFontWeight: FontWeight.w500,
      unselectedFontWeight: FontWeight.w500,
      selectedTextColor: VisaColors.white,
      unselectedTextColor: VisaColors.black,
      borderColor: VisaColors.black,
      lineHeight: (Sizes.eighteenInt / Sizes.fourteenInt).toDouble(),
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

  void _handleCategoryChipTap(int chipIndex, AddItineraryProvider viewModel) {
    viewModel.updateEditState();
    viewModel.changeCategoryList(chipIndex);
  }

  Widget _buildActionButtons(
      BuildContext context, AddItineraryProvider viewModel) {
    return Column(
      children: [
        CustomTwoButtons(
          leftButtonText: S.of(context).cancel,
          rightButtonText: _getRightButtonText(context),
          rightButtonDisable: _isRightButtonDisabled(viewModel),
          onLeftButtonPressed: () => viewModel.navPop(),
          onRightButtonPressed: () =>
              viewModel.addItineraryButton(_isRightButtonDisabled(viewModel)),
          isRightButtonLoading: false,
          isLeftButtonLoading: false,
        ),
      ],
    );
  }

  String _getRightButtonText(BuildContext context) {
    return eventModel == null
        ? S.of(context).add_to_itinerary
        : S.of(context).update;
  }

  bool _isRightButtonDisabled(AddItineraryProvider viewModel) {
    return eventModel == null ? false : !viewModel.isUpdate;
  }
}
