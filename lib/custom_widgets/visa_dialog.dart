import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_appbar_actions.dart'
    show VisaAppBarActions;
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/l10n.dart' show S;
import 'package:visaamigo/ui/provider/theme_provider.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes, Sizes;
import 'package:visaamigo/utils/utils.dart';

/// Configuration class for VisaDialog show method parameters
class VisaDialogShowConfig {
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final Widget? customContent;
  final bool barrierDismissible;
  final bool isLoading;
  final VisaButtonVariant primaryButtonVariant;
  final bool outlinedSecondaryButton;
  final CrossAxisAlignment crossAxisAlignment;
  final bool showCloseButton;
  final Color? customTitleColor;
  final double titleFontSize;
  final double subtitleFontSize;
  final EdgeInsets insetPadding;
  final EdgeInsets padding;

  const VisaDialogShowConfig({
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.customContent,
    this.barrierDismissible = true,
    this.isLoading = false,
    this.primaryButtonVariant = VisaButtonVariant.primary,
    this.outlinedSecondaryButton = true,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.showCloseButton = false,
    this.customTitleColor,
    this.titleFontSize = 20,
    this.subtitleFontSize = 16,
    this.insetPadding = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(10),
  });
}

class VisaDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final Widget? customContent;
  final bool barrierDismissible;
  final bool isLoading;
  final VisaButtonVariant primaryButtonVariant;
  final bool outlinedSecondaryButton;
  final CrossAxisAlignment crossAxisAlignment;
  final bool showCloseButton;
  final Color? customTitleColor;
  final double titleFontSize;
  final double subtitleFontSize;
  final EdgeInsets insetPadding;
  final EdgeInsets padding;

  const VisaDialog({
    super.key,
    required this.title,
    required this.message,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.customContent,
    this.barrierDismissible = true,
    this.isLoading = false,
    this.primaryButtonVariant = VisaButtonVariant.primary,
    this.outlinedSecondaryButton = true,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.showCloseButton = false,
    this.customTitleColor,
    this.titleFontSize = 20,
    this.subtitleFontSize = 16,
    this.insetPadding = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(10),
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    VisaDialogShowConfig config = const VisaDialogShowConfig(),
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: config.barrierDismissible,
      builder: (BuildContext context) => VisaDialog(
        title: title,
        message: message,
        primaryButtonText: config.primaryButtonText,
        secondaryButtonText: config.secondaryButtonText,
        onPrimaryPressed: config.onPrimaryPressed,
        onSecondaryPressed: config.onSecondaryPressed,
        customContent: config.customContent,
        barrierDismissible: config.barrierDismissible,
        isLoading: config.isLoading,
        primaryButtonVariant: config.primaryButtonVariant,
        outlinedSecondaryButton: config.outlinedSecondaryButton,
        crossAxisAlignment: config.crossAxisAlignment,
        showCloseButton: config.showCloseButton,
        customTitleColor: config.customTitleColor,
        titleFontSize: config.titleFontSize,
        subtitleFontSize: config.subtitleFontSize,
        insetPadding: config.insetPadding,
        padding: config.padding,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Dialog(
          insetPadding: insetPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.tenRadius),
          ),
          backgroundColor: _getDialogBackgroundColor(themeProvider),
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showCloseButton) _buildCloseButton(context),
                _buildDialogContent(context, themeProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getDialogBackgroundColor(ThemeProvider themeProvider) {
    return themeProvider.isDarkMode ? VisaColors.darkPrimary : Colors.white;
  }

  Widget _buildCloseButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        VisaAppBarActions(
          onPressed: () => Navigator.pop(context, true),
          visaTextStyle: VisaTextStyle.bodySmall,
          visaTextTheme: _getCloseButtonTextTheme(),
          isIconShow: true,
          isTextShow: true,
          text: S.of(context).close.toUpperCase(),
          icons: Icons.close,
          iconColor: VisaColors.black,
          iconSize: AppSizes.sixteenRadius,
          letterSpacing: Sizes.two,
          customColor: VisaColors.black,
          padding: _getCloseButtonPadding(),
          isComeFromAppBar: false,
        ),
      ],
    );
  }

  VisaTextTheme _getCloseButtonTextTheme() {
    return customTitleColor != null
        ? VisaTextTheme.textColorBlack
        : VisaTextTheme.primaryDark;
  }

  EdgeInsets _getCloseButtonPadding() {
    return EdgeInsets.only(
      right: customTitleColor != null ? 0 : Sizes.eight,
    );
  }

  Widget _buildDialogContent(
      BuildContext context, ThemeProvider themeProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        SizedBox(height: _getTitleTopSpacing()),
        _buildTitle(context),
        SizedBox(height: _getTitleBottomSpacing()),
        _buildMessage(context, themeProvider),
        if (customContent != null) _buildCustomContent(),
        SizedBox(height: AppSizes.heightTweentyFour),
        _buildButtons(context),
      ],
    );
  }

  double _getTitleTopSpacing() {
    return customTitleColor != null ? 8.h : 0;
  }

  double _getTitleBottomSpacing() {
    return customTitleColor != null ? 24.h : AppSizes.heightSmall;
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      textAlign: _getTitleTextAlign(),
      textScaler: TextScaler.linear(Utils.getCappedScale(
        context,
        titleFontSize.sp,
      )),
      style: _getTitleTextStyle(),
    );
  }

  TextAlign _getTitleTextAlign() {
    return customTitleColor != null ? TextAlign.center : TextAlign.start;
  }

  TextStyle _getTitleTextStyle() {
    return TextStyle(
      height: customTitleColor != null ? 0.94 : 1,
      fontSize: titleFontSize.sp,
      fontWeight: customTitleColor != null ? FontWeight.w500 : FontWeight.bold,
      fontFamily: "VisaDialectUI",
      letterSpacing: customTitleColor != null ? -0.72 : 0,
      color: _getTitleColor(),
    );
  }

  Color _getTitleColor() {
    return customTitleColor ?? VisaColors.primaryDark;
  }

  Widget _buildMessage(BuildContext context, ThemeProvider themeProvider) {
    return Padding(
      padding: _getMessagePadding(),
      child: Text(
        message,
        textAlign: TextAlign.center,
        textScaler: TextScaler.linear(Utils.getCappedScale(
          context,
          subtitleFontSize.sp,
        )),
        style: _getMessageTextStyle(themeProvider),
      ),
    );
  }

  EdgeInsets _getMessagePadding() {
    return EdgeInsets.symmetric(
      horizontal: customTitleColor != null && customContent != null ? 8.w : 0,
    );
  }

  TextStyle _getMessageTextStyle(ThemeProvider themeProvider) {
    return TextStyle(
      fontSize: subtitleFontSize.sp,
      fontFamily: "VisaDialectUI",
      fontWeight: FontWeight.w500,
      height: customTitleColor != null ? 1.33 : 1,
      color: _getMessageColor(themeProvider),
    );
  }

  Color _getMessageColor(ThemeProvider themeProvider) {
    if (customTitleColor != null) {
      return VisaColors.black;
    }
    return themeProvider.isDarkMode
        ? Colors.white.withValues(alpha: 0.87)
        : VisaColors.primaryDark.withValues(alpha: 0.87);
  }

  Widget _buildCustomContent() {
    return Column(
      children: [
        SizedBox(height: AppSizes.heightTweentyFour),
        customContent!,
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (secondaryButtonText != null) _buildSecondaryButton(context),
        if (primaryButtonText != null) _buildPrimaryButton(),
      ],
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return Row(
      children: [
        VisaButton(
          contentPadding: EdgeInsets.only(left: 12.r, right: 12.r),
          text: secondaryButtonText!,
          variant: VisaButtonVariant.secondary,
          isOutlined: outlinedSecondaryButton,
          onPressed: onSecondaryPressed ?? () => Navigator.pop(context),
          height: 40,
        ),
        SizedBox(width: AppSizes.dimSmall),
      ],
    );
  }

  Widget _buildPrimaryButton() {
    return VisaButton(
      padding: EdgeInsets.only(left: 16.r, right: 8.r),
      fontSize: AppSizes.fontMedium,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
      text: primaryButtonText!,
      variant: primaryButtonVariant,
      onPressed: isLoading ? null : onPrimaryPressed,
      isLoading: isLoading,
      height: 40,
    );
  }
}
