import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_appbar_actions.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../core/theme/theme.dart';
import '../features/select_languages/providers/language_selection_generic_provider.dart';
import '../generated/assets.dart';
import '../generated/l10n.dart';
import '../utils/const_screen_size.dart';

/// Configuration class for GenericDialog styling and behavior
class GenericDialogConfig {
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry aroundPadding;
  final EdgeInsets insetPadding;
  final bool showCloseButton;
  final bool showCloseButtonWithText;
  final VoidCallback? onDismiss;

  const GenericDialogConfig({
    this.backgroundColor = Colors.white,
    this.borderRadius = 16.0,
    this.contentPadding = const EdgeInsets.all(24.0),
    this.aroundPadding = const EdgeInsets.all(8.0),
    this.insetPadding = const EdgeInsets.all(16.0),
    this.showCloseButton = false,
    this.showCloseButtonWithText = false,
    this.onDismiss,
  });

  /// Default configuration for delete dialogs
  factory GenericDialogConfig.deleteDialog({
    Color? backgroundColor,
    VoidCallback? onDismiss,
  }) {
    return GenericDialogConfig(
      backgroundColor: backgroundColor ?? Colors.white,
      borderRadius: Sizes.ten,
      contentPadding: EdgeInsets.symmetric(vertical: AppSizes.tweentyHeight),
      aroundPadding: EdgeInsets.only(
        left: AppSizes.tweentyWidth,
        right: AppSizes.tweentyWidth,
        bottom: AppSizes.tweentyHeight,
      ),
      insetPadding: EdgeInsets.all(AppSizes.dimSmall),
      showCloseButton: false,
      showCloseButtonWithText: true,
      onDismiss: onDismiss,
    );
  }
}

/// A generic dialog widget that can be customized for different use cases
/// such as authentication, confirmation, alerts, etc.
class GenericDialog extends StatelessWidget {
  /// The title of the dialog
  final String? title;

  /// The title of the dialog semantics
  final String? semanticLabel;

  /// The main content widget to display in the dialog
  final Widget content;

  /// Optional icon to display at the top of the dialog
  final Widget? icon;

  /// Configuration for dialog styling and behavior
  final GenericDialogConfig config;

  /// List of action buttons to display at the bottom
  final List<Widget>? actions;

  const GenericDialog({
    super.key,
    this.title,
    this.semanticLabel,
    required this.content,
    this.icon,
    this.config = const GenericDialogConfig(),
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(config.borderRadius),
      ),
      backgroundColor: config.backgroundColor,
      insetPadding: config.insetPadding,
      child: Semantics(
        enabled: true,
        container: true,
        focused: true,
        focusable: true,
        label: semanticLabel ?? S.of(context).dialog,
        child: Padding(
          padding: config.aroundPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              if (title != null) ...[
                const SizedBox(height: 16.0),
                Text(
                  title!,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ],
              Padding(
                padding: config.contentPadding,
                child: content,
              ),
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildActionButtons(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: EdgeInsets.only(top: 55.h),
              child: icon!,
            ),
          if (config.showCloseButtonWithText)
            Positioned(
              top: 8,
              right: 0,
              child: VisaAppBarActions(
                onPressed: () {
                  config.onDismiss?.call();
                },
                visaTextStyle: VisaTextStyle.bodySmall,
                visaTextTheme: VisaTextTheme.customTextColor,
                isIconShow: true,
                isTextShow: true,
                text: S.of(context).close.toUpperCase(),
                icons: Icons.close,
                iconColor: VisaColors.black,
                iconSize: AppSizes.sixteenRadius,
                letterSpacing: AppSizes.twoInt.toDouble(),
                customColor: VisaColors.black,
                padding: EdgeInsets.only(top: 0.h),
                isComeFromAppBar: false,
              ),
            ),
          if (config.showCloseButton)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  config.onDismiss?.call();
                  Navigator.of(context).pop();
                },
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    final result = <Widget>[];

    if (actions != null) {
      for (int i = 0; i < actions!.length; i++) {
        result.add(actions![i]);
        if (i < actions!.length - 1) {
          result.add(const SizedBox(width: 8.0));
        }
      }
    }

    return result;
  }
}

/// Extension methods for showing the GenericDialog
extension GenericDialogExtension on BuildContext {
  /// Shows a generic dialog and returns the result when the dialog is closed
  Future<T?> showGenericDialog<T>({
    String? title,
    String? semanticLabel,
    required Widget content,
    Widget? icon,
    GenericDialogConfig config = const GenericDialogConfig(),
    List<Widget>? actions,
    bool barrierDismissible = true,
    String? dialogRouteName,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => GenericDialog(
        title: title,
        semanticLabel: semanticLabel,
        content: content,
        icon: icon,
        config: config,
        actions: actions,
      ),
      routeSettings: RouteSettings(name: dialogRouteName),
    );
  }

  /// Shows an authentication dialog similar to the one in the example
  Future<bool?> showAuthenticationDialog({
    String? title,
    Color? iconBackgroundColor,
    bool barrierDismissible = false,
  }) {
    return showGenericDialog<bool>(
      title: title,
      icon: CircleAvatar(
        backgroundColor: iconBackgroundColor,
        radius: 30.r,
        child: SvgPicture.asset(
          Assets.iconsBiometricAndroid,
          width: 24,
        ),
      ),
      content: VisaTextView(
        text: title ?? "",
        customColor: Colors.black,
        colorTheme: VisaTextTheme.customTextColor,
        style: VisaTextStyle.displayTitleSmall,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows an authentication dialog similar to the one in the example
  Future<bool?> showDeleteAccountDialog({
    BuildContext? context,
    String? title,
    Color? backgroundColor,
    Color? buttonBgColor,
    bool barrierDismissible = false,
    String? buttonText,
    String? dialogRouteName,
  }) {
    final dialogName = (dialogRouteName?.isNotEmpty ?? false)
        ? dialogRouteName
        : "${Provider.of<SelectLanguageGenericProvider>(context!, listen: false).getKeyFromValue(title ?? "")}_dialog";

    return showGenericDialog<bool>(
      title: null,
      semanticLabel: "${title!},${S.of(context!).dialog}",
      config: GenericDialogConfig.deleteDialog(
        backgroundColor: backgroundColor,
        onDismiss: () {
          Navigator.of(context!).pop(false);
        },
      ),
      dialogRouteName: dialogName,
      icon: VisaSvgIcon(
        semantics: false,
        assetPath: Assets.iconsIcDeleteRed,
        width: 55.w,
        height: 55.h,
        setColorFilter: false,
        useWithoutColor: false,
      ),
      content: VisaTextView(
        text: title ?? "",
        customColor: VisaColors.black,
        colorTheme: VisaTextTheme.customTextColor,
        fontFamily: VisaFontWeight.medium,
        fontSize: AppSizes.fontSmall,
        letterSpacing: -2,
        lineHeight: (36 / 34).toDouble(),
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        softWrap: true,
      ),
      actions: [
        Expanded(
          child: Semantics(
            enabled: true,
            container: true,
            label: "${buttonText!}, ${S.of(context).double_tap_to_activate}",
            child: VisaButton(
              semantics: false,
              text: buttonText,
              width: screenWidth,
              variant: VisaButtonVariant.custom,
              buttonColor: VisaColors.red,
              buttonTextColor: VisaColors.white,
              lineHeight: (25 / 18).toDouble(),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ),
        )
      ],
      barrierDismissible: barrierDismissible,
    );
  }

  /// Shows an authentication dialog similar to the one in the example
  Future<bool?> showDeleteEventDialog({
    BuildContext? context,
    String? title,
    String? description,
    Color? backgroundColor,
    Color? buttonBgColor,
    bool barrierDismissible = false,
    String? buttonText,
  }) {
    return showGenericDialog<bool>(
      title: null,
      semanticLabel:
          "${S.of(context!).dialog},${title!},${description!},${S.of(context).close}${S.of(context).button},${buttonText!}${S.of(context).button}",
      config: GenericDialogConfig.deleteDialog(
        backgroundColor: backgroundColor,
        onDismiss: () {
          Navigator.of(context).pop(false);
        },
      ),
      icon: const SizedBox.shrink(),
      content: Column(
        children: [
          VisaTextView(
            text: title ?? "",
            customColor: VisaColors.red,
            colorTheme: VisaTextTheme.customTextColor,
            fontFamily: VisaFontWeight.medium,
            fontSize: AppSizes.fontSmall,
            letterSpacing: -2,
            lineHeight: (36 / 34).toDouble(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
          VisaSizeBox(
            height: AppSizes.tweentyHeight,
          ),
          VisaTextView(
            text: description ?? "",
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            fontFamily: VisaFontWeight.medium,
            fontSize: AppSizes.fontTwelve,
            letterSpacing: 0,
            lineHeight: (16 / 12).toDouble(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        ],
      ),
      actions: [
        Expanded(
          child: Semantics(
            enabled: true,
            container: true,
            label: "${buttonText!}, ${S.of(context).double_tap_to_activate}",
            child: VisaButton(
              text: buttonText,
              semantics: false,
              width: screenWidth,
              variant: VisaButtonVariant.custom,
              buttonColor: VisaColors.red,
              buttonTextColor: VisaColors.white,
              lineHeight: (25 / 18).toDouble(),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ),
        )
      ],
      barrierDismissible: barrierDismissible,
    );
  }
}
