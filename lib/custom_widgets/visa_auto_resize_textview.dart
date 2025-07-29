import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/ui/provider/theme_provider.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/responsive_util.dart';
import 'package:visaamigo/utils/utils.dart';

// Font weight enum to match available font files

class VisaAutoCompleteTextView extends StatelessWidget {
  final String text;
  final VisaTextStyle style;
  final VisaTextTheme colorTheme;
  final TextAlign textAlign;
  final Color customColor;
  final int? textLength;
  final int? maxLines;
  final TextOverflow overflow;
  final bool isItalic;
  final double? letterSpacing;
  final double? lineHeight;
  final double? maxFontSize;
  final double? minFontSize;
  final VisaFontWeight fontFamily;
  final bool softWrap;
  final TextWidthBasis textWidthBasis;
  final double? textLineHeight;
  final double? minLine;

  const VisaAutoCompleteTextView({
    super.key,
    required this.text,
    this.textLength,
    this.customColor = Colors.black,
    this.style = VisaTextStyle.bodyMedium,
    this.colorTheme = VisaTextTheme.primary,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.isItalic = false,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.02,
    this.minLine = 1,
    this.maxFontSize,
    this.minFontSize,
    this.textLineHeight,
    this.softWrap = true,
    this.textWidthBasis = TextWidthBasis.parent,
    this.fontFamily = VisaFontWeight.regular,
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

  TextStyle _getTextStyle(bool isDarkMode, BuildContext context) {
    final baseColor = _getTextColor(isDarkMode);
    final textFont = VisaFontFamily.getFontFamily(fontFamily, isItalic);
    final materialFontWeight = VisaFontFamily.getMaterialFontWeight(fontFamily);

    return _createTextStyleForStyle(
      style,
      baseColor,
      textFont,
      materialFontWeight,
      context,
    );
  }

  // Shared method to create base TextStyle
  TextStyle _createBaseTextStyle(
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight, {
    double? fontSize,
    double? letterSpacing,
    double? lineHeight,
    TextBaseline? textBaseline,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: fontSize ?? (maxFontSize != null ? maxFontSize!.sp : 14.sp),
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? this.letterSpacing ?? 0.25,
      height: lineHeight ?? this.lineHeight ?? 1.43,
      textBaseline: textBaseline,
      decoration: decoration,
    );
  }

  TextStyle _createTextStyleForStyle(
    VisaTextStyle style,
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight,
    BuildContext context,
  ) {
    // Display styles
    if (_isDisplayStyle(style)) {
      return _createDisplayTextStyle(
          style, baseColor, textFont, materialFontWeight);
    }

    // Wallet styles
    if (_isWalletStyle(style)) {
      return _createWalletTextStyle(style, baseColor, textFont);
    }

    // Headline styles
    if (_isHeadlineStyle(style)) {
      return _createHeadlineTextStyle(
          style, baseColor, textFont, materialFontWeight);
    }

    // Title styles
    if (_isTitleStyle(style)) {
      return _createTitleTextStyle(
          style, baseColor, textFont, materialFontWeight);
    }

    // Body styles
    if (_isBodyStyle(style)) {
      return _createBodyTextStyle(
          style, baseColor, textFont, materialFontWeight);
    }

    // Label styles
    if (_isLabelStyle(style)) {
      return _createLabelTextStyle(
          style, baseColor, textFont, materialFontWeight);
    }

    // Caption styles
    if (_isCaptionStyle(style)) {
      return _createCaptionTextStyle(
          style, baseColor, textFont, materialFontWeight);
    }

    // Special styles
    if (_isSpecialStyle(style)) {
      return _createSpecialTextStyle(
          style, baseColor, textFont, materialFontWeight, context);
    }

    // Custom display styles
    if (_isCustomDisplayStyle(style)) {
      return _createCustomDisplayTextStyle(
          style, baseColor, textFont, materialFontWeight, context);
    }

    // Default fallback
    return _createDefaultTextStyle(baseColor, textFont, materialFontWeight);
  }

  // Style category checkers
  bool _isDisplayStyle(VisaTextStyle style) {
    return style == VisaTextStyle.displayLarge ||
        style == VisaTextStyle.displayMedium ||
        style == VisaTextStyle.displaySmall;
  }

  bool _isWalletStyle(VisaTextStyle style) {
    return style == VisaTextStyle.walletNormal ||
        style == VisaTextStyle.walletHighlighted;
  }

  bool _isHeadlineStyle(VisaTextStyle style) {
    return style == VisaTextStyle.headlineLarge ||
        style == VisaTextStyle.headlineMedium ||
        style == VisaTextStyle.headlineSmall;
  }

  bool _isTitleStyle(VisaTextStyle style) {
    return style == VisaTextStyle.titleLarge ||
        style == VisaTextStyle.titleMedium ||
        style == VisaTextStyle.titleSmall;
  }

  bool _isBodyStyle(VisaTextStyle style) {
    return style == VisaTextStyle.bodyLarge ||
        style == VisaTextStyle.bodyMedium ||
        style == VisaTextStyle.bodySmall;
  }

  bool _isLabelStyle(VisaTextStyle style) {
    return style == VisaTextStyle.labelLarge ||
        style == VisaTextStyle.labelMedium ||
        style == VisaTextStyle.labelSmall;
  }

  bool _isCaptionStyle(VisaTextStyle style) {
    return style == VisaTextStyle.captionLarge ||
        style == VisaTextStyle.captionMedium ||
        style == VisaTextStyle.captionSmall;
  }

  bool _isSpecialStyle(VisaTextStyle style) {
    return style == VisaTextStyle.button ||
        style == VisaTextStyle.link ||
        style == VisaTextStyle.overLine ||
        style == VisaTextStyle.custom ||
        style == VisaTextStyle.customLarge ||
        style == VisaTextStyle.customMedium ||
        style == VisaTextStyle.customSmall;
  }

  bool _isCustomDisplayStyle(VisaTextStyle style) {
    return style == VisaTextStyle.displayStyleH1 ||
        style == VisaTextStyle.displayStyleH2 ||
        style == VisaTextStyle.displayStyleH3 ||
        style == VisaTextStyle.displayStyleH4 ||
        style == VisaTextStyle.displayStyleH5 ||
        style == VisaTextStyle.displayTitleLarge ||
        style == VisaTextStyle.displayTitleMedium ||
        style == VisaTextStyle.displayTitleSmall ||
        style == VisaTextStyle.displayBodyXl ||
        style == VisaTextStyle.displayBodyL ||
        style == VisaTextStyle.displayBodyS ||
        style == VisaTextStyle.displayBodyXs;
  }

  // Shared method for style-specific TextStyle creation
  TextStyle _createStyleSpecificTextStyle(
    VisaTextStyle style,
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight, {
    required double Function(VisaTextStyle) getFontSize,
    required double Function(VisaTextStyle) getLineHeight,
    double Function(VisaTextStyle)? getLetterSpacing,
  }) {
    final fontSize = getFontSize(style);
    final lineHeight = getLineHeight(style);
    final letterSpacing = getLetterSpacing?.call(style);

    return _createBaseTextStyle(
      baseColor,
      textFont,
      materialFontWeight,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      lineHeight: lineHeight,
    );
  }

  TextStyle _createDisplayTextStyle(
    VisaTextStyle style,
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight,
  ) {
    return _createStyleSpecificTextStyle(
      style,
      baseColor,
      textFont,
      materialFontWeight,
      getFontSize: _getDisplayFontSize,
      getLineHeight: _getDisplayLineHeight,
      getLetterSpacing: _getDisplayLetterSpacing,
    );
  }

  TextStyle _createWalletTextStyle(
    VisaTextStyle style,
    Color baseColor,
    String textFont,
  ) {
    final fontWeight = style == VisaTextStyle.walletHighlighted
        ? FontWeight.w600
        : FontWeight.w400;

    return _createBaseTextStyle(
      baseColor,
      textFont,
      fontWeight,
      fontSize: 14.sp,
      lineHeight: (18 / 14.sp).h,
    );
  }

  TextStyle _createHeadlineTextStyle(
    VisaTextStyle style,
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight,
  ) {
    return _createStyleSpecificTextStyle(
      style,
      baseColor,
      textFont,
      materialFontWeight,
      getFontSize: _getHeadlineFontSize,
      getLineHeight: _getHeadlineLineHeight,
    );
  }

  TextStyle _createTitleTextStyle(
    VisaTextStyle style,
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight,
  ) {
    return _createStyleSpecificTextStyle(
      style,
      baseColor,
      textFont,
      materialFontWeight,
      getFontSize: _getTitleFontSize,
      getLineHeight: _getTitleLineHeight,
      getLetterSpacing: _getTitleLetterSpacing,
    );
  }

  TextStyle _createBodyTextStyle(
    VisaTextStyle style,
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight,
  ) {
    return _createStyleSpecificTextStyle(
      style,
      baseColor,
      textFont,
      materialFontWeight,
      getFontSize: _getBodyFontSize,
      getLineHeight: _getBodyLineHeight,
      getLetterSpacing: _getBodyLetterSpacing,
    );
  }

  TextStyle _createLabelTextStyle(
    VisaTextStyle style,
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight,
  ) {
    return _createStyleSpecificTextStyle(
      style,
      baseColor,
      textFont,
      materialFontWeight,
      getFontSize: _getLabelFontSize,
      getLineHeight: _getLabelLineHeight,
      getLetterSpacing: _getLabelLetterSpacing,
    );
  }

  TextStyle _createCaptionTextStyle(
    VisaTextStyle style,
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight,
  ) {
    return _createStyleSpecificTextStyle(
      style,
      baseColor,
      textFont,
      materialFontWeight,
      getFontSize: _getCaptionFontSize,
      getLineHeight: _getCaptionLineHeight,
      getLetterSpacing: _getCaptionLetterSpacing,
    );
  }

  TextStyle _createSpecialTextStyle(
    VisaTextStyle style,
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight,
    BuildContext context,
  ) {
    switch (style) {
      case VisaTextStyle.button:
        return _specialButtonTextStyle(baseColor, textFont, materialFontWeight);
      case VisaTextStyle.link:
        return _specialLinkTextStyle(baseColor, textFont, materialFontWeight);
      case VisaTextStyle.overLine:
        return _specialOverLineTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.customLarge:
        return _specialCustomLargeTextStyle(
            baseColor, textFont, materialFontWeight, context);
      case VisaTextStyle.customMedium:
        return _specialCustomMediumTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.customSmall:
        return _specialCustomSmallTextStyle(baseColor);
      case VisaTextStyle.custom:
        return _specialCustomTextStyle(baseColor, textFont, materialFontWeight);
      default:
        return _createDefaultTextStyle(baseColor, textFont, materialFontWeight);
    }
  }

  TextStyle _specialButtonTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return _createBaseTextStyle(
      baseColor,
      textFont,
      materialFontWeight,
      fontSize: maxFontSize?.sp ?? 14.sp,
      letterSpacing: letterSpacing ?? 1.25,
      lineHeight: lineHeight ?? 1.43,
    );
  }

  TextStyle _specialLinkTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return _createBaseTextStyle(
      baseColor,
      textFont,
      materialFontWeight,
      fontSize: maxFontSize?.sp ?? 14.sp,
      letterSpacing: letterSpacing ?? 0.4,
      lineHeight: lineHeight ?? 1.43,
      decoration: TextDecoration.underline,
    );
  }

  TextStyle _specialOverLineTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return _createBaseTextStyle(
      baseColor,
      textFont,
      materialFontWeight,
      fontSize: maxFontSize?.sp ?? 10.sp,
      letterSpacing: letterSpacing ?? 1.5,
      lineHeight: lineHeight ?? 1.6,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  TextStyle _specialCustomLargeTextStyle(Color baseColor, String textFont,
      FontWeight materialFontWeight, BuildContext context) {
    final responsiveFontSize = maxFontSize?.sp ??
        (Provider.of<ResponsiveUtil>(context).isDesktop(context: context)
            ? 54.sp
            : Provider.of<ResponsiveUtil>(context).isTablet(context: context)
                ? 30.sp
                : AppSizes.fontXSmall);

    return _createBaseTextStyle(
      baseColor,
      textFont,
      materialFontWeight,
      fontSize: responsiveFontSize,
      letterSpacing: letterSpacing ?? -1,
      lineHeight: lineHeight ?? 1.2,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  TextStyle _specialCustomMediumTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return _createBaseTextStyle(
      baseColor,
      textFont,
      materialFontWeight,
      fontSize: maxFontSize?.sp ?? 14.sp,
      letterSpacing: letterSpacing ?? 1,
      lineHeight: lineHeight ?? 1.6,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  TextStyle _specialCustomSmallTextStyle(Color baseColor) {
    return _createBaseTextStyle(
      baseColor,
      '',
      FontWeight.normal,
      fontSize: maxFontSize?.sp ?? 14.sp,
      letterSpacing: letterSpacing ?? 1.5,
      lineHeight: lineHeight ?? 1.6,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  TextStyle _specialCustomTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return _createBaseTextStyle(
      baseColor,
      textFont,
      materialFontWeight,
      fontSize: maxFontSize?.sp ?? maxFontSize,
      letterSpacing: letterSpacing ?? 0.5,
      lineHeight: lineHeight ?? 1.5,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  TextStyle _createCustomDisplayTextStyle(
    VisaTextStyle style,
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight,
    BuildContext context,
  ) {
    return _createBaseTextStyle(
      baseColor,
      textFont,
      materialFontWeight,
      fontSize: getFontSize(context),
      letterSpacing: letterSpacing ?? -1.sp,
      lineHeight: textLineHeight ?? getLineHeight(),
    );
  }

  TextStyle _createDefaultTextStyle(
    Color baseColor,
    String textFont,
    FontWeight materialFontWeight,
  ) {
    return _createBaseTextStyle(
      baseColor,
      textFont,
      materialFontWeight,
      fontSize: maxFontSize?.sp ?? 14.sp,
      letterSpacing: letterSpacing ?? 0.25,
      lineHeight: lineHeight ?? 1.43,
    );
  }

  // Shared method for style value retrieval
  double _getStyleValue(
    VisaTextStyle style,
    Map<VisaTextStyle, double> valueMap,
    double defaultValue,
  ) {
    return valueMap[style] ?? defaultValue;
  }

  // Helper methods for display styles
  double _getDisplayFontSize(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.displayLarge: FontSizes.xsmall,
          VisaTextStyle.displayMedium: 30.sp,
          VisaTextStyle.displaySmall: 24.sp,
        },
        14.sp);
  }

  double _getDisplayLineHeight(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.displayLarge: 1.12,
          VisaTextStyle.displayMedium: 1.16,
          VisaTextStyle.displaySmall: 1.22,
        },
        1.43);
  }

  double _getDisplayLetterSpacing(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.displayLarge: -0.25,
        },
        0.0);
  }

  // Helper methods for headline styles
  double _getHeadlineFontSize(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.headlineLarge: 34.sp,
          VisaTextStyle.headlineMedium: 28.sp,
          VisaTextStyle.headlineSmall: 20.sp,
        },
        14.sp);
  }

  double _getHeadlineLineHeight(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.headlineLarge: 1.25,
          VisaTextStyle.headlineMedium: 1.29,
          VisaTextStyle.headlineSmall: 1.33,
        },
        1.43);
  }

  // Helper methods for title styles
  double _getTitleFontSize(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.titleLarge: 30.sp,
          VisaTextStyle.titleMedium: 24.sp,
          VisaTextStyle.titleSmall: 18.sp,
        },
        14.sp);
  }

  double _getTitleLineHeight(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.titleLarge: 1.27,
          VisaTextStyle.titleMedium: 1.5,
          VisaTextStyle.titleSmall: 1.43,
        },
        1.43);
  }

  double _getTitleLetterSpacing(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.titleMedium: 0.15,
          VisaTextStyle.titleSmall: 0.1,
        },
        0.0);
  }

  // Helper methods for body styles
  double _getBodyFontSize(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.bodyLarge: 16.sp,
          VisaTextStyle.bodyMedium: 14.sp,
          VisaTextStyle.bodySmall: 12.sp,
        },
        14.sp);
  }

  double _getBodyLineHeight(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.bodyLarge: 1.5,
          VisaTextStyle.bodyMedium: 1.43,
          VisaTextStyle.bodySmall: 1.33,
        },
        1.43);
  }

  double _getBodyLetterSpacing(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.bodyLarge: 0.5,
          VisaTextStyle.bodyMedium: 0.25,
          VisaTextStyle.bodySmall: 0.4,
        },
        0.25);
  }

  // Helper methods for label styles
  double _getLabelFontSize(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.labelLarge: 14.sp,
          VisaTextStyle.labelMedium: 12.sp,
          VisaTextStyle.labelSmall: 11.sp,
        },
        14.sp);
  }

  double _getLabelLineHeight(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.labelLarge: 1.43,
          VisaTextStyle.labelMedium: 1.33,
          VisaTextStyle.labelSmall: 1.45,
        },
        1.43);
  }

  double _getLabelLetterSpacing(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.labelLarge: 0.1,
          VisaTextStyle.labelMedium: 0.5,
          VisaTextStyle.labelSmall: 0.5,
        },
        0.1);
  }

  // Helper methods for caption styles
  double _getCaptionFontSize(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.captionLarge: 12.sp,
          VisaTextStyle.captionMedium: 11.sp,
          VisaTextStyle.captionSmall: 10.sp,
        },
        12.sp);
  }

  double _getCaptionLineHeight(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.captionLarge: 1.33,
          VisaTextStyle.captionMedium: 1.45,
          VisaTextStyle.captionSmall: 1.2,
        },
        1.33);
  }

  double _getCaptionLetterSpacing(VisaTextStyle style) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.captionLarge: 0.4,
          VisaTextStyle.captionMedium: 0.5,
          VisaTextStyle.captionSmall: 0.5,
        },
        0.4);
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
                  button: false,
                  enabled: true,
                  child: AutoSizeText(
                    // minFontSize.toString(),
                    textLength != null
                        ? text.substring(0, textLength!.clamp(0, text.length))
                        : text,
                    textScaleFactor: Utils.getCappedScale(
                        context, (minFontSize ?? 10.sp).ceilToDouble()),
                    style: _getTextStyle(themeProvider.isDarkMode, context),
                    textAlign: textAlign,
                    maxLines: maxLines,
                    overflow: overflow,
                    softWrap: softWrap,
                    minFontSize: (minFontSize ?? 10.sp).ceilToDouble(),
                    // maxFontSize: _getTextStyle(themeProvider.isDarkMode, context).fontSize,
                    stepGranularity: 1,
                    // stepGranularity:
                    //     (_getTextStyle(themeProvider.isDarkMode, context)
                    //             .fontSize)! /
                    //         (minFontSize ?? 10.sp),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  double getFontSize(BuildContext context) {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.displayStyleH1: FontSizes(context).h1,
          VisaTextStyle.displayStyleH2: FontSizes(context).h2,
          VisaTextStyle.displayStyleH3: FontSizes(context).h3,
          VisaTextStyle.displayStyleH4: FontSizes(context).h4,
          VisaTextStyle.displayStyleH5: FontSizes(context).h5,
          VisaTextStyle.displayTitleLarge: FontSizes(context).displayTitleLarge,
          VisaTextStyle.displayTitleMedium:
              FontSizes(context).displayTitleMedium,
          VisaTextStyle.displayTitleSmall: FontSizes(context).displayTitleSmall,
          VisaTextStyle.displayBodyXl: FontSizes(context).displayBodyXL,
          VisaTextStyle.displayBodyL: FontSizes(context).displayBodyL,
          VisaTextStyle.displayBodyS: FontSizes(context).displayBodyS,
          VisaTextStyle.displayBodyXs: FontSizes(context).displayBodyXs,
        },
        FontSizes(context).medium);
  }

  double getLineHeight() {
    return _getStyleValue(
        style,
        {
          VisaTextStyle.displayStyleH1: (49 / 48), //1.02
          VisaTextStyle.displayStyleH2: (45 / 44), //1.02
          VisaTextStyle.displayStyleH3: (41 / 40), //1.02
          VisaTextStyle.displayStyleH4: (37 / 36), //1.02
          VisaTextStyle.displayStyleH5: (31 / 30), //1.03
          VisaTextStyle.displayTitleLarge: (29 / 28), //1.03
          VisaTextStyle.displayTitleMedium: (25 / 24), // 1,04
          VisaTextStyle.displayTitleSmall: (21 / 20), //1.05
          VisaTextStyle.displayBodyXl: (20 / 18), // 1.1
          VisaTextStyle.displayBodyL: (20 / 16), //1.25
          VisaTextStyle.displayBodyS: (20 / 14), // 1.42
          VisaTextStyle.displayBodyXs: (14 / 12), //1.16
        },
        1);
  }
}
