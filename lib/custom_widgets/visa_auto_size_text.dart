import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/ui/provider/theme_provider.dart';
import 'package:visaamigo/utils/test_style_util.dart';

import '../utils/const_screen_size.dart';

/// A custom AutoSizeText widget that adapts to the Visa design system
class VisaAutoSizeText extends StatelessWidget {
  final String text;
  final VisaTextStyle style;
  final VisaTextTheme colorTheme;
  final TextAlign textAlign;
  final Color customColor;
  final int? maxLines;
  final TextOverflow overflow;
  final bool isItalic;
  final double? letterSpacing;
  final double? lineHeight;
  final double? fontSize;
  final VisaFontWeight fontFamily;
  final bool softWrap;
  final bool semantics;
  final double? minFontSize;
  final double? maxFontSize;
  final double stepGranularity;
  final List<double>? presetFontSizes;
  final AutoSizeGroup? group;
  final bool wrapWords;

  const VisaAutoSizeText({
    super.key,
    required this.text,
    this.customColor = Colors.black,
    this.style = VisaTextStyle.bodyMedium,
    this.colorTheme = VisaTextTheme.primary,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.isItalic = false,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.02,
    this.fontSize,
    this.softWrap = true,
    this.fontFamily = VisaFontWeight.regular,
    this.minFontSize = 12,
    this.maxFontSize,
    this.stepGranularity = 0.1,
    this.presetFontSizes,
    this.group,
    this.wrapWords = true,
    this.semantics = true,
  });

  Color _getTextColor(bool isDarkMode) {
    if (isDarkMode) {
      switch (colorTheme) {
        case VisaTextTheme.customTextColor:
          return customColor;
        case VisaTextTheme.primary:
          return VisaColors.darkPrimary;
        case VisaTextTheme.primaryLight:
          return VisaColors.darkPrimaryLight;
        case VisaTextTheme.primaryDark:
          return VisaColors.darkPrimaryDark;
        case VisaTextTheme.secondary:
          return VisaColors.darkSecondary;
        case VisaTextTheme.secondaryLight:
          return VisaColors.darkSecondaryLight;
        case VisaTextTheme.secondaryDark:
          return VisaColors.darkSecondaryDark;
        case VisaTextTheme.textColorBlack:
          return VisaColors.black;
      }
    } else {
      switch (colorTheme) {
        case VisaTextTheme.customTextColor:
          return customColor;
        case VisaTextTheme.primary:
          return VisaColors.primary;
        case VisaTextTheme.primaryLight:
          return VisaColors.primaryLight;
        case VisaTextTheme.primaryDark:
          return VisaColors.primaryDark;
        case VisaTextTheme.secondary:
          return VisaColors.secondary;
        case VisaTextTheme.secondaryLight:
          return VisaColors.secondaryLight;
        case VisaTextTheme.secondaryDark:
          return VisaColors.secondaryDark;
        case VisaTextTheme.textColorBlack:
          return VisaColors.black;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth,
              ),
              child: Focus(
                focusNode: FocusNode(),
                child: Semantics(
                  enabled: semantics,
                  excludeSemantics: semantics,
                  container: true,
                  label: text,
                  child: AutoSizeText(
                    text,
                    style: VisaTextUtils.getVisaTextStyle(
                      style,
                      context: context,
                      isDarkMode: themeProvider.isDarkMode,
                      fontFamily: fontFamily,
                      letterSpacing: letterSpacing,
                      lineHeight: lineHeight,
                      fontSize: fontSize,
                      isItalic: isItalic,
                      fontColor: _getTextColor(themeProvider.isDarkMode),
                    ),
                    textAlign: textAlign,
                    maxLines: maxLines,
                    overflow: overflow,
                    stepGranularity: stepGranularity,
                    softWrap: softWrap,
                    minFontSize: (minFontSize != null)
                        ? minFontSize!.roundToDouble()
                        : 12.0.sp.roundToDouble(),
                    maxFontSize: (maxFontSize != null)
                        ? maxFontSize!.roundToDouble()
                        : _getDefaultMaxFontSize(context).roundToDouble(),
                    presetFontSizes: presetFontSizes,
                    group: group,
                    wrapWords: wrapWords,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  double _getDefaultMaxFontSize(BuildContext context) {
    // If fontSize is explicitly provided, use that as the max
    if (fontSize != null) return fontSize!;

    // Otherwise use the default size for the given style
    switch (style) {
      case VisaTextStyle.displayStyleH1:
        return FontSizes(context).h1;
      case VisaTextStyle.displayStyleH2:
        return FontSizes(context).h2;
      case VisaTextStyle.displayStyleH3:
        return FontSizes(context).h3;
      case VisaTextStyle.displayStyleH4:
        return FontSizes(context).h4;
      case VisaTextStyle.displayStyleH5:
        return FontSizes(context).h5;
      case VisaTextStyle.displayTitleLarge:
        return FontSizes(context).displayTitleLarge;
      case VisaTextStyle.displayTitleMedium:
        return FontSizes(context).displayTitleMedium;
      case VisaTextStyle.displayTitleSmall:
        return FontSizes(context).displayTitleSmall;
      case VisaTextStyle.displayBodyXl:
        return FontSizes(context).displayBodyXL;
      case VisaTextStyle.displayBodyL:
        return FontSizes(context).displayBodyL;
      case VisaTextStyle.displayBodyS:
        return FontSizes(context).displayBodyS;
      case VisaTextStyle.displayBodyXs:
        return FontSizes(context).displayBodyXs;
      case VisaTextStyle.displayLarge:
        return 48.sp;
      case VisaTextStyle.displayMedium:
        return 30.sp;
      case VisaTextStyle.displaySmall:
        return 24.sp;
      case VisaTextStyle.headlineLarge:
        return 34.sp;
      case VisaTextStyle.headlineMedium:
        return 28.sp;
      case VisaTextStyle.headlineSmall:
        return 20.sp;
      case VisaTextStyle.titleLarge:
        return 30.sp;
      case VisaTextStyle.titleMedium:
        return 24.sp;
      case VisaTextStyle.titleSmall:
        return 18.sp;
      case VisaTextStyle.bodyLarge:
        return 16.sp;
      case VisaTextStyle.bodyMedium:
        return 14.sp;
      case VisaTextStyle.bodySmall:
        return 12.sp;
      case VisaTextStyle.labelLarge:
        return 14.sp;
      case VisaTextStyle.labelMedium:
        return 12.sp;
      case VisaTextStyle.labelSmall:
        return 11.sp;
      case VisaTextStyle.captionLarge:
        return 12.sp;
      case VisaTextStyle.captionMedium:
        return 11.sp;
      case VisaTextStyle.captionSmall:
        return 10.sp;
      case VisaTextStyle.button:
        return 14.sp;
      case VisaTextStyle.link:
        return 14.sp;
      case VisaTextStyle.overLine:
        return 10.sp;
      case VisaTextStyle.customLarge:
        return 54.sp;
      case VisaTextStyle.customMedium:
        return 14.sp;
      case VisaTextStyle.customSmall:
        return 14.sp;
      case VisaTextStyle.custom:
        return fontSize?.sp ?? 14.sp;
      default:
        return 14.sp;
    }
  }
}
