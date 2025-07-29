// A generic class for displaying platform-adaptive dialogs in Flutter.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_rich_text.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/ui/provider/theme_provider.dart';
import 'package:visaamigo/utils/theme_extension.dart';
import 'package:visaamigo/utils/utils.dart';

import '../core/theme/theme.dart';
import '../features/select_languages/providers/language_selection_generic_provider.dart';
import '../utils/const_screen_size.dart';
import '../utils/test_style_util.dart';

/// Configuration class for dialog options
class VisaDialogConfig {
  final String positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? onPositivePressed;
  final VoidCallback? onNegativePressed;
  final VoidCallback? closeDialog;
  final bool barrierDismissible;
  final bool closeDialogPositiveClick;
  final String? dialogRouteName;

  const VisaDialogConfig({
    this.positiveButtonText = "OK",
    this.negativeButtonText,
    this.onPositivePressed,
    this.onNegativePressed,
    this.closeDialog,
    this.barrierDismissible = true,
    this.closeDialogPositiveClick = true,
    this.dialogRouteName,
  });
}

/// Configuration class for input dialog options
class VisaInputDialogConfig {
  final String hintText;
  final String initialValue;
  final String positiveButtonText;
  final String negativeButtonText;
  final InputDecoration? inputDecoration;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final bool obscureText;

  const VisaInputDialogConfig({
    this.hintText = '',
    this.initialValue = '',
    this.positiveButtonText = 'OK',
    this.negativeButtonText = 'Cancel',
    this.inputDecoration,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.obscureText = false,
  });
}

///
/// This class automatically detects the platform and shows either a Material dialog (Android)
/// or a Cupertino dialog (iOS) based on the current platform.
class VisaNativeDialog {
  /// Shows a platform-adaptive alert dialog.
  ///
  /// Parameters:
  /// - [context]: The build context
  /// - [title]: The title of the dialog
  /// - [message]: The message/content of the dialog
  /// - [config]: Configuration object containing dialog options
  ///
  /// Returns a Future that resolves when the dialog is closed.
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    bool isWidgetSpan = false,
    String linkText = "",
    VoidCallback? onLinkTap,
    VisaDialogConfig config = const VisaDialogConfig(),
  }) async {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS ||
        theme.platform == TargetPlatform.macOS;

    if (isIOS) {
      return _showCupertinoDialog(
          context: context,
          title: title,
          message: message,
          config: config,
          linkText: linkText,
          onLinkTap: onLinkTap,
          isWidgetSpan: isWidgetSpan);
    } else {
      return _showMaterialDialog(
          context: context,
          title: title,
          message: message,
          config: config,
          linkText: linkText,
          onLinkTap: onLinkTap,
          isWidgetSpan: isWidgetSpan);
    }
  }

  static Future<String?> showInputDialog({
    required BuildContext context,
    required String title,
    VisaInputDialogConfig config = const VisaInputDialogConfig(),
  }) async {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS ||
        theme.platform == TargetPlatform.macOS;

    if (isIOS) {
      return _showCupertinoInputDialog(
        context: context,
        title: title,
        config: config,
      );
    } else {
      return _showMaterialInputDialog(
        context: context,
        title: title,
        config: config,
      );
    }
  }

  /// Shows a loading dialog that can't be dismissed by the user.
  ///
  /// Parameters:
  /// - [context]: The build context
  /// - [message]: Optional message to display with the loading indicator
  static Future<void> showLoading(BuildContext context,
      {String? message}) async {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS ||
        theme.platform == TargetPlatform.macOS;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return isIOS
            ? CupertinoAlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CupertinoActivityIndicator(),
                    if (message != null) ...[
                      const SizedBox(height: 16),
                      Text(message,
                          textScaler: TextScaler.linear(
                              Utils.getCappedScale(context, 14))),
                    ],
                  ],
                ),
              )
            : AlertDialog(
                content: Row(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(width: 16),
                    if (message != null)
                      Expanded(
                          child: Text(
                        message,
                        textScaler: TextScaler.linear(
                            Utils.getCappedScale(context, 14)),
                      )),
                  ],
                ),
              );
      },
    );
  }

  /// Hides any currently shown dialog.
  static void hideDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  // Private helper methods
  static Future<bool?> _showMaterialDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String linkText,
    required VisaDialogConfig config,
    required bool isWidgetSpan,
    VoidCallback? onLinkTap,
  }) {
    final dialogName = (config.dialogRouteName?.isNotEmpty ?? false)
        ? config.dialogRouteName
        : "${Provider.of<SelectLanguageGenericProvider>(context!, listen: false).getKeyFromValue(title ?? "")}_dialog";

    return showDialog<bool>(
      context: context,
      routeSettings: RouteSettings(name: dialogName),
      barrierDismissible: config.barrierDismissible,
      builder: (BuildContext context) {
        final semanticsLabel =
            "${S.of(context).dialog},${title},${message},${config.negativeButtonText ?? ""}${S.of(context).button}, ${config.positiveButtonText}${S.of(context).button}";

        return AlertDialog(
          semanticLabel: semanticsLabel,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: FontSizes(context).displayTitleMedium,
              fontFamily:
                  VisaFontFamily.getFontFamily(VisaFontWeight.bold, false),
              fontWeight: FontWeight.bold,
              // height: 1.40,
              // letterSpacing: 1,
            ),
          ),
          content: Padding(
            padding: EdgeInsets.only(bottom: Sizes.ten).r,
            child: (isWidgetSpan)
                ? SizedBox(
                    width: double.infinity,
                    child: Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return RichText(
                          text: TextSpan(
                            children: [
                              VisaTextSpan(
                                text: message,
                                style: VisaTextStyle.bodyMedium,
                                colorTheme: VisaTextTheme.textColorBlack,
                                fontFamily: VisaFontWeight.regular,
                                fontSize: FontSizes(context).displayBodyL,
                              ).getTextSpan(
                                  themeProvider.isDarkMode ?? false, context),
                              VisaTextSpan(
                                text: "\n",
                                style: VisaTextStyle.bodyMedium,
                                colorTheme: VisaTextTheme.primary,
                                fontFamily: VisaFontWeight.regular,
                              ).getTextSpan(
                                  themeProvider.isDarkMode ?? false, context),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (onLinkTap != null) {
                                        onLinkTap();
                                      }
                                    },
                                    child: Text(
                                      linkText,
                                      textAlign: TextAlign.right,
                                      style: VisaTextUtils.getVisaTextStyle(
                                        VisaTextStyle.link,
                                        fontColor: VisaColors.primary,
                                        context: context,
                                        isDarkMode: false,
                                        fontSize: AppSizes.fontTwelve,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Text(
                    message,
                    textScaler: TextScaler.linear(Utils.getCappedScale(
                        context, FontSizes(context).displayBodyL)),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: FontSizes(context).displayBodyL,
                      fontFamily: VisaFontFamily.getFontFamily(
                          VisaFontWeight.regular, false),
                      fontWeight: FontWeight.normal,
                      // height: 1.40,
                      // letterSpacing: 2,
                    ),
                  ),
          ),
          actions: <Widget>[
            if (config.negativeButtonText != null)
              Container(
                padding: EdgeInsets.all(AppSizes.ten),
                child: GestureDetector(
                  child: Text(
                    config.negativeButtonText!,
                    textScaler: TextScaler.linear(Utils.getCappedScale(
                        context, FontSizes(context).displayBodyL)),
                    style: TextStyle(
                      color: context.theme.primaryColor,
                      fontSize: FontSizes(context).displayBodyL,
                      fontFamily: VisaFontFamily.getFontFamily(
                          VisaFontWeight.regular, false),
                      fontWeight: FontWeight.normal,
                      // height: 1.40,
                      // letterSpacing: 2,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(false);
                    if (config.onNegativePressed != null) {
                      config.onNegativePressed!();
                    }
                  },
                ),
              ),
            // HSpacings.medium,
            Container(
              // margin: const EdgeInsets.only(left: 10, right: 10).r,
              padding: EdgeInsets.all(AppSizes.ten),
              child: GestureDetector(
                child: Text(config.positiveButtonText,
                    textScaler: TextScaler.linear(Utils.getCappedScale(
                        context, FontSizes(context).displayBodyL)),
                    style: TextStyle(
                      color: context.theme.primaryColor,
                      fontSize: FontSizes(context).displayBodyL,
                      fontFamily: VisaFontFamily.getFontFamily(
                          VisaFontWeight.regular, false),
                      fontWeight: FontWeight.normal,
                      // height: 1.40,
                      // letterSpacing: 2,
                    )),
                onTap: () {
                  if (config.onPositivePressed != null) {
                    config.onPositivePressed!();
                  }
                  if (config.closeDialogPositiveClick) {
                    Navigator.of(context).pop(false);
                  }
                },
              ),
            ),
            AppSizes.mediumVS,
          ],
        );
      },
    );
  }

  static Future<bool?> _showCupertinoDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String linkText,
    required VisaDialogConfig config,
    required bool isWidgetSpan,
    VoidCallback? onLinkTap,
  }) {
    final dialogName = (config.dialogRouteName?.isNotEmpty ?? false)
        ? config.dialogRouteName
        : "${Provider.of<SelectLanguageGenericProvider>(context!, listen: false).getKeyFromValue(title ?? "")}_dialog";
    return showCupertinoDialog<bool>(
      context: context,
      routeSettings: RouteSettings(name: dialogName),
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            textScaler: TextScaler.linear(Utils.getCappedScale(
                context, FontSizes(context).displayTitleMedium)),
            style: TextStyle(
              color: Colors.black,
              fontSize: FontSizes(context).displayTitleMedium,
              fontFamily:
                  VisaFontFamily.getFontFamily(VisaFontWeight.bold, false),
              fontWeight: FontWeight.bold,
              height: 1.40,
              // letterSpacing: 1,
            ),
          ),
          content: (isWidgetSpan)
              ? SizedBox(
                  width: double.infinity,
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return RichText(
                        text: TextSpan(
                          children: [
                            VisaTextSpan(
                              text: " \n" + message,
                              style: VisaTextStyle.bodyMedium,
                              colorTheme: VisaTextTheme.textColorBlack,
                              fontFamily: VisaFontWeight.regular,
                              fontSize: FontSizes(context).displayBodyL,
                            ).getTextSpan(
                                themeProvider.isDarkMode ?? false, context),
                            VisaTextSpan(
                              text: "\n",
                              style: VisaTextStyle.bodyMedium,
                              colorTheme: VisaTextTheme.primary,
                              fontFamily: VisaFontWeight.regular,
                            ).getTextSpan(
                                themeProvider.isDarkMode ?? false, context),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: SizedBox(
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: () {
                                    if (onLinkTap != null) {
                                      onLinkTap();
                                    }
                                  },
                                  child: Text(
                                    linkText,
                                    textAlign: TextAlign.right,
                                    style: VisaTextUtils.getVisaTextStyle(
                                      VisaTextStyle.link,
                                      fontColor: VisaColors.primary,
                                      context: context,
                                      isDarkMode: false,
                                      fontSize: AppSizes.fontTwelve,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Text(
                  message,
                  textScaler: TextScaler.linear(Utils.getCappedScale(
                      context, FontSizes(context).displayBodyL)),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: FontSizes(context).displayBodyL,
                    fontFamily: VisaFontFamily.getFontFamily(
                        VisaFontWeight.regular, false),
                    fontWeight: FontWeight.normal,
                    // height: 1.40,
                    // letterSpacing: 2,
                  ),
                ),
          actions: <Widget>[
            if (config.negativeButtonText != null)
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text(
                  config.negativeButtonText!,
                  textScaler: TextScaler.linear(Utils.getCappedScale(
                      context, FontSizes(context).displayBodyL)),
                  style: TextStyle(
                    color: context.theme.primaryColor,
                    fontSize: FontSizes(context).displayBodyL,
                    fontFamily: VisaFontFamily.getFontFamily(
                        VisaFontWeight.regular, false),
                    fontWeight: FontWeight.normal,
                    // height: 1.40,
                    // letterSpacing: 2,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  Utils.hideKeyboard(context);
                  if (config.onNegativePressed != null) {
                    config.onNegativePressed!();
                  }
                },
              ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                config.positiveButtonText,
                textScaler: TextScaler.linear(Utils.getCappedScale(
                    context, FontSizes(context).displayBodyL)),
                style: TextStyle(
                  color: context.theme.primaryColor,
                  fontSize: FontSizes(context).displayBodyL,
                  fontFamily: VisaFontFamily.getFontFamily(
                      VisaFontWeight.regular, false),
                  fontWeight: FontWeight.normal,
                  // height: 1.40,
                  // letterSpacing: 2,
                ),
              ),
              onPressed: () {
                if (config.onPositivePressed != null) {
                  config.onPositivePressed!();
                }
                Utils.hideKeyboard(context);

                // changed it to make Navigator.of(context).pop(true); come inside if code block
                if (config.closeDialogPositiveClick) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  static Future<String?> _showMaterialInputDialog({
    required BuildContext context,
    required String title,
    required VisaInputDialogConfig config,
  }) {
    final TextEditingController controller =
        TextEditingController(text: config.initialValue);
    final formKey = GlobalKey<FormState>();
    String? errorText;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                title,
                textScaler:
                    TextScaler.linear(Utils.getCappedScale(context, 14)),
              ),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  autofocus: true,
                  decoration: config.inputDecoration ??
                      InputDecoration(
                        hintText: config.hintText,
                        errorText: errorText,
                      ),
                  keyboardType: config.keyboardType,
                  textCapitalization: config.textCapitalization,
                  maxLength: config.maxLength,
                  obscureText: config.obscureText,
                  validator: config.validator,
                  onChanged: (_) {
                    if (errorText != null) {
                      setState(() {
                        errorText = null;
                      });
                    }
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    config.negativeButtonText,
                    textScaler:
                        TextScaler.linear(Utils.getCappedScale(context, 14)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Utils.hideKeyboard(context);
                  },
                ),
                TextButton(
                  child: Text(
                    config.positiveButtonText,
                    textScaler:
                        TextScaler.linear(Utils.getCappedScale(context, 14)),
                  ),
                  onPressed: () {
                    if (config.validator != null) {
                      final error = config.validator!(controller.text);
                      if (error != null) {
                        setState(() {
                          errorText = error;
                        });
                        return;
                      }
                    }
                    Navigator.of(context).pop(controller.text);
                    Utils.hideKeyboard(context);
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      controller.dispose();
      return value;
    });
  }

  static Future<String?> _showCupertinoInputDialog({
    required BuildContext context,
    required String title,
    required VisaInputDialogConfig config,
  }) {
    final TextEditingController controller =
        TextEditingController(text: config.initialValue);

    return showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            textScaler: TextScaler.linear(Utils.getCappedScale(context, 14)),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CupertinoTextField(
              controller: controller,
              placeholder: config.hintText,
              autofocus: true,
              keyboardType: config.keyboardType,
              textCapitalization: config.textCapitalization,
              maxLength: config.maxLength,
              obscureText: config.obscureText,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(
                config.negativeButtonText,
                textScaler:
                    TextScaler.linear(Utils.getCappedScale(context, 14)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Utils.hideKeyboard(context);
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                config.positiveButtonText,
                textScaler:
                    TextScaler.linear(Utils.getCappedScale(context, 14)),
              ),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
                Utils.hideKeyboard(context);
              },
            ),
          ],
        );
      },
    ).then((value) {
      controller.dispose();
      return value;
    });
  }
}
