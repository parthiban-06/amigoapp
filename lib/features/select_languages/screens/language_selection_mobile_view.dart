import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/shared_preferences.dart';

import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_button.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/l10n.dart';
import '../providers/language_selection_provider.dart';
import '../widgets/language_grid_view_widget.dart';

class LanguageSelectionMobile extends StatefulWidget {
  final SelectLanguageProvider? viewModel;
  final String? deeplinkEmail;
  final bool? showBack;
  final bool isDesktop;
  final bool isMobileWeb;

  const LanguageSelectionMobile(this.viewModel, this.deeplinkEmail,
      {super.key,
      this.showBack,
      required this.isDesktop,
      required this.isMobileWeb});

  @override
  State<LanguageSelectionMobile> createState() =>
      _LanguageSelectionMobileState();
}

class _LanguageSelectionMobileState extends State<LanguageSelectionMobile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: _getMainAxisAlignment(),
      children: [
        _buildTitle(),
        VisaSizeBox(height: 32.h),
        _buildLanguageGrid(),
        _buildBottomButton(context),
      ],
    );
  }

  MainAxisAlignment _getMainAxisAlignment() {
    return widget.isMobileWeb
        ? MainAxisAlignment.start
        : MainAxisAlignment.center;
  }

  Widget _buildTitle() {
    final semanticsIndex = _getSemanticsIndex();
    final titleText = _getTitleText();

    return VisaTextView(
      semanticsIndex: semanticsIndex,
      text: titleText,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.displayTitleMedium,
      fontFamily: VisaFontWeight.semibold,
      customColor: VisaColors.black,
      letterSpacing: -1,
      colorTheme: VisaTextTheme.customTextColor,
      lineHeight: 1.04,
    );
  }

  int? _getSemanticsIndex() {
    return widget.showBack == null || widget.showBack == false
        ? Sizes.threeInt
        : null;
  }

  String _getTitleText() {
    return widget.showBack == null || widget.showBack == false
        ? widget.viewModel?.selectedLanguageItem?.selectLangText ??
            /*S.of(context).first_time_pref*/ ""
        : widget.viewModel?.selectedLanguageItem?.changeLangText ??
            /*S.of(context).change_language*/ "";
  }

  Widget _buildLanguageGrid() {
    final languageGrid = LanguageGridViewWidget(
      viewModel: widget.viewModel,
      isDesktop: widget.isDesktop,
      isMobileWeb: widget.isMobileWeb,
    );

    if (widget.isDesktop || widget.isMobileWeb) {
      return Flexible(child: languageGrid);
    } else {
      return Expanded(child: languageGrid);
    }
  }

  Widget _buildBottomButton(BuildContext context) {
    final buttonText = _getButtonText();
    final isDisabled = _isButtonDisabled();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: VisaButton(
        text: buttonText,
        isDisable: isDisabled,
        onPressed: () => _handleButtonPressed(context),
        addDefaultAnalyticsEvent: false,
        variant: VisaButtonVariant.primary,
      ),
    );
  }

  String _getButtonText() {
    /*return widget.showBack != null && widget.showBack == true
        ? S.of(context).update_language
        : S.of(context).txt_continue;*/

    return widget.showBack == null || widget.showBack == false
        ? widget.viewModel?.selectedLanguageItem?.btnContinue ??
            /*S.of(context).first_time_pref*/ ""
        : widget.viewModel?.selectedLanguageItem?.btnUpdate ??
            /*S.of(context).change_language*/ "";
  }

  bool _isButtonDisabled() {
    return ((widget.viewModel?.selectedLanguage.isNullOrEmpty) == null) ||
        ((widget.showBack != null && widget.showBack == true)
            ? (widget.viewModel!.selectedLanguage ==
                widget.viewModel!.initialLanguage)
            : false);
  }

  Future<void> _handleButtonPressed(BuildContext context) async {
    if (((widget.viewModel?.selectedLanguage.isNullOrEmpty) == null) ||
        ((widget.showBack != null && widget.showBack == true)
            ? (widget.viewModel!.selectedLanguage ==
                widget.viewModel!.initialLanguage)
            : false)) {
      _showSuccessSnackBar(
          context, S.of(context).no_change_detected_message_in_language);
      return;
    }
    await _handleUpdateLanguage(
        context, (widget.showBack != null && widget.showBack == true));
  }

  Future<void> _handleUpdateLanguage(
      BuildContext context, bool showBack) async {
    if (!context.mounted) return;

    // Save language preference FIRST to ensure UI updates immediately
    await _saveLanguagePreference();

    final selectedLanguage = widget.viewModel!.selectedLanguage;
    final updateSuccess = await _performLanguageUpdate(showBack);

    if (showBack) {
      await _handleUpdateResult(context, updateSuccess, selectedLanguage);
    }

    _navigateAfterUpdate(context, showBack);
  }

  Future<void> _saveLanguagePreference() async {
    await Preferences.setString(
      Preferences.keyLanguageCode,
      widget.viewModel!.selectedLanguage,
    );

    // Update the language provider to reflect changes immediately
    if (mounted) {
      // Force UI rebuild to reflect language change immediately
      setState(() {});

      // Ensure the language provider is updated
      widget.viewModel?.languageGenericProvider?.setLanguage(
        widget.viewModel!.selectedLanguage,
      );
    }
  }

  Future<bool> _performLanguageUpdate(bool showBack) async {
    return await widget.viewModel!
        .updateLanguage(widget.viewModel!.selectedLanguage, showBack);
  }

  Future<void> _handleUpdateResult(
      BuildContext context, bool updateSuccess, String selectedLanguage) async {
    if (!context.mounted) return;

    if (updateSuccess) {
      await _handleSuccessfulUpdate(context, selectedLanguage);
    } else {
      _handleFailedUpdate(context);
    }
  }

  void _navigateAfterUpdate(BuildContext context, bool showBack) {
    if (context.mounted && showBack) {
      Navigator.of(context).pop();
    } else {
      _handleContinue();
    }
  }

  String _getSelectedLanguageTitle() {
    return widget.viewModel!.languageList!
        .toList()
        .where((e) => e.langCode == widget.viewModel!.selectedLanguage)
        .first
        .title;
  }

  Future<void> _handleSuccessfulUpdate(
      BuildContext context, String selectedLanguage) async {
    final successMessage = S.of(context).success;
    final successSubtitle = S.of(context).language_change_success;

    FirebaseAnalyticsService.logEvent(
      eventName: AnalyticsEventConst.EVENT_NAME_UI_INTERACTION,
      parameters: {
        "selected_language": _getSelectedLanguageTitle().toString(),
        "ui_element": "continue button",
      },
    );

    if (context.mounted) {
      visaSnackBar(
        context: context,
        title: "$successMessage!",
        type: SnackBarType.success,
        subtitle: successSubtitle,
      );
    }
  }

  void _handleFailedUpdate(BuildContext context) {
    if (context.mounted) {
      visaSnackBar(
        context: context,
        title: "${S.of(context).error}!",
        type: SnackBarType.failure,
        subtitle: S.of(context).try_again,
      );
    }
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

  String _getUiElementName() {
    return widget.showBack != null && widget.showBack == true
        ? "update_language"
        : "txt_continue_button";
  }

  void _handleContinue() {
    widget.viewModel?.navigateToLogin(widget.deeplinkEmail);
  }
}
