import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/theme.dart';
import '../custom_widgets/visa_font_family.dart';
import '../custom_widgets/visa_textview.dart';
import 'const_screen_size.dart';

/// Utility class for handling Visa Text Styles
class VisaTextUtils {
  /// Returns the appropriate text style based on VisaTextStyle enum
  static TextStyle getVisaTextStyle(
    VisaTextStyle style, {
    required BuildContext context,
    required bool isDarkMode,
    VisaFontWeight fontFamily = VisaFontWeight.regular,
    double? letterSpacing,
    double? lineHeight,
    double? fontSize,
    bool isItalic = false,
    Color? fontColor,
  }) {
    final baseColor = fontColor ?? _getTextColor(isDarkMode);
    final testFontFamily = "VisaDialectUI";
    final materialFontWeight = VisaFontFamily.getMaterialFontWeight(fontFamily);

    switch (style) {
      // Display Styles
      case VisaTextStyle.displayLarge:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.bold,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing ?? -0.25,
            lineHeight ?? 1.12,
            fontSize);
      case VisaTextStyle.displayMedium:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.semibold,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing!,
            lineHeight ?? 1.16,
            fontSize);
      case VisaTextStyle.displaySmall:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.medium,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing!,
            lineHeight ?? 1.22,
            fontSize);

      // Headline Styles
      case VisaTextStyle.headlineLarge:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.bold,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing!,
            lineHeight ?? 1.25,
            fontSize);
      case VisaTextStyle.headlineMedium:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.semibold,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing!,
            lineHeight ?? 1.29,
            fontSize);
      case VisaTextStyle.headlineSmall:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.medium,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing!,
            lineHeight ?? 1.33,
            fontSize);

      // Title Styles
      case VisaTextStyle.titleLarge:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.bold,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing!,
            lineHeight ?? 1.27,
            fontSize);
      case VisaTextStyle.titleMedium:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.semibold,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing ?? 0.15,
            lineHeight ?? 1.5,
            fontSize);
      case VisaTextStyle.titleSmall:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.medium,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing ?? 0.1,
            lineHeight ?? 1.43,
            fontSize);

      // Body Styles
      case VisaTextStyle.bodyLarge:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.regular,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing ?? 0.5,
            lineHeight ?? 1.5,
            fontSize);
      case VisaTextStyle.bodyMedium:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.regular,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing ?? 0.25,
            lineHeight ?? 1.43,
            fontSize);
      case VisaTextStyle.bodySmall:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.light,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing ?? 0.4,
            lineHeight ?? 1.33,
            fontSize);

      // Special Styles
      case VisaTextStyle.button:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.semibold,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing ?? 1.25,
            lineHeight ?? 1.43,
            fontSize);
      case VisaTextStyle.link:
        return _baseTextStyle(
                context,
                style,
                VisaFontWeight.medium,
                baseColor,
                testFontFamily,
                materialFontWeight,
                isItalic,
                letterSpacing ?? 0.4,
                lineHeight ?? 1.43,
                fontSize)
            .copyWith(decoration: TextDecoration.underline);
      case VisaTextStyle.overLine:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.light,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing ?? 1.5,
            lineHeight ?? 1.6,
            fontSize);
      case VisaTextStyle.displayStyleH1:
      case VisaTextStyle.displayStyleH2:
      case VisaTextStyle.displayStyleH3:
      case VisaTextStyle.displayStyleH4:
      case VisaTextStyle.displayStyleH5:
      case VisaTextStyle.displayTitleLarge:
      case VisaTextStyle.displayTitleMedium:
      case VisaTextStyle.displayTitleSmall:
      case VisaTextStyle.displayBodyXl:
      case VisaTextStyle.displayBodyL:
      case VisaTextStyle.displayBodyS:
      case VisaTextStyle.displayBodyXs:
        return TextStyle(
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          fontWeight: materialFontWeight,
          fontSize: _getFontSize(context, style),
          color: baseColor,
          fontFamily: testFontFamily,
          letterSpacing: letterSpacing ?? -1.sp,
          height: _getLineHeight(style),
        );
      default:
        return _baseTextStyle(
            context,
            style,
            VisaFontWeight.regular,
            baseColor,
            testFontFamily,
            materialFontWeight,
            isItalic,
            letterSpacing ?? 0.5,
            lineHeight ?? 1.5,
            fontSize);
    }
  }

  /// Creates a TextStyle with calculated properties
  static TextStyle _baseTextStyle(
    BuildContext context,
    VisaTextStyle style,
    VisaFontWeight fontWeight,
    Color color,
    String fontFamily,
    FontWeight materialFontWeight,
    bool isItalic,
    double letterSpacing,
    double lineHeight,
    double? fontSize,
  ) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize.sp : _getFontSize(context, style),
      color: color,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
      height: lineHeight,
    );
  }

  static double _getFontSize(BuildContext context, VisaTextStyle style) {
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

      default:
        return FontSizes(context).medium;
    }
  }

  static double _getLineHeight(VisaTextStyle style) {
    switch (style) {
      case VisaTextStyle.displayStyleH1:
        return (49 / 48);
      case VisaTextStyle.displayStyleH2:
        return (45 / 44);
      case VisaTextStyle.displayStyleH3:
        return (41 / 40);
      case VisaTextStyle.displayStyleH4:
        return (37 / 36);
      case VisaTextStyle.displayStyleH5:
        return (31 / 30);
      case VisaTextStyle.displayTitleLarge:
        return (29 / 28);
      case VisaTextStyle.displayTitleMedium:
        return (25 / 24);
      case VisaTextStyle.displayTitleSmall:
        return (21 / 20);
      case VisaTextStyle.displayBodyXl:
        return (20 / 18);
      case VisaTextStyle.displayBodyL:
        return (20 / 16);
      case VisaTextStyle.displayBodyS:
        return (20 / 14);
      case VisaTextStyle.displayBodyXs:
        return (14 / 12);

      default:
        return 1;
    }
  }

  /// Retrieves the correct text color based on dark mode
  static Color _getTextColor(bool isDarkMode) {
    return isDarkMode ? VisaColors.white : VisaColors.black;
  }
}
