import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/ui/provider/theme_provider.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/responsive_util.dart';

// Font weight enum to match available font files
enum VisaFontWeight {
  light, // VisaDialect-Light w300
  regular, // VisaDialect-Regular w400
  medium, // VisaDialect-Medium w500
  semibold, // VisaDialect-Semibold w600
  bold // VisaDialect-Bold w700
}

enum VisaTextStyle {
  // Display styles for large headers
  displayLarge,
  displayMedium,
  displaySmall,

  // Headline styles
  headlineLarge,
  headlineMedium,
  headlineSmall,

  // Title styles
  titleLarge,
  titleMedium,
  titleSmall,

  // Body text styles
  bodyLarge,
  bodyMedium,
  bodySmall,

  // Label styles
  labelLarge,
  labelMedium,
  labelSmall,

  // Caption styles
  captionLarge,
  captionMedium,
  captionSmall,

  // Special styles
  button,
  link,
  overLine,
  custom,
  //custom
  customLarge,
  customMedium,
  customSmall,
  displayStyleH1, // 48
  displayStyleH2, //44
  displayStyleH3, //40
  displayStyleH4, //26
  displayStyleH5, //30
  displayTitleLarge, // 28
  displayTitleMedium, // 24
  displayTitleSmall, //20
  displayBodyXl, //18
  displayBodyL, // 16
  // displayBodyM,
  displayBodyS, //14
  displayBodyXs, //12
  walletNormal,
  walletHighlighted
}

enum VisaTextTheme {
  primary,
  primaryLight,
  primaryDark,
  secondary,
  secondaryLight,
  secondaryDark,
  customTextColor,
  textColorBlack
}

class VisaTextView extends StatelessWidget {
  final String text;
  final VisaTextStyle style;
  final VisaTextTheme colorTheme;
  final TextAlign textAlign;
  final Color customColor;
  final int? textLength;
  final int? maxLines;
  final String? semanticsLabel;
  final TextOverflow overflow;
  final bool isItalic;
  final double? letterSpacing;
  final double? lineHeight;
  final double? fontSize;
  final VisaFontWeight fontFamily;
  final bool softWrap;
  final TextWidthBasis textWidthBasis;
  final double? textLineHeight;
  final bool enableCopy;
  final bool? noScaling;
  final bool semantics;
  final int? semanticsIndex;
  final bool semanticsFocus;

  const VisaTextView({
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
    this.enableCopy = false,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.02,
    this.fontSize,
    this.textLineHeight,
    this.softWrap = true,
    this.textWidthBasis = TextWidthBasis.parent,
    this.fontFamily = VisaFontWeight.regular,
    this.semantics = true,
    this.noScaling,
    this.semanticsLabel,
    this.semanticsIndex,
    this.semanticsFocus = false,
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

    if (_isDisplayStyle()) {
      return _createDisplayStyleTextStyle(
          baseColor, textFont, materialFontWeight, context);
    }

    switch (style) {
      case VisaTextStyle.displayLarge:
        return _createDisplayLargeTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.displayMedium:
        return _createDisplayMediumTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.displaySmall:
        return _createDisplaySmallTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.walletNormal:
        return _createWalletNormalTextStyle(textFont);
      case VisaTextStyle.walletHighlighted:
        return _createWalletHighlightedTextStyle(textFont);
      case VisaTextStyle.headlineLarge:
        return _createHeadlineLargeTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.headlineMedium:
        return _createHeadlineMediumTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.headlineSmall:
        return _createHeadlineSmallTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.titleLarge:
        return _createTitleLargeTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.titleMedium:
        return _createTitleMediumTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.titleSmall:
        return _createTitleSmallTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.bodyLarge:
        return _createBodyLargeTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.bodyMedium:
        return _createBodyMediumTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.bodySmall:
        return _createBodySmallTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.labelLarge:
        return _createLabelLargeTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.labelMedium:
        return _createLabelMediumTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.labelSmall:
        return _createLabelSmallTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.captionLarge:
        return _createCaptionLargeTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.captionMedium:
        return _createCaptionMediumTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.captionSmall:
        return _createCaptionSmallTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.button:
        return _createButtonTextStyle(baseColor, textFont, materialFontWeight);
      case VisaTextStyle.link:
        return _createLinkTextStyle(baseColor, textFont, materialFontWeight);
      case VisaTextStyle.overLine:
        return _createOverLineTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.customLarge:
        return _createCustomLargeTextStyle(
            baseColor, textFont, materialFontWeight, context);
      case VisaTextStyle.customMedium:
        return _createCustomMediumTextStyle(
            baseColor, textFont, materialFontWeight);
      case VisaTextStyle.customSmall:
        return _createCustomSmallTextStyle(baseColor);
      case VisaTextStyle.custom:
        return _createCustomTextStyle(baseColor, textFont, materialFontWeight);
      default:
        return _createDefaultTextStyle(baseColor, textFont, materialFontWeight);
    }
  }

  bool _isDisplayStyle() {
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

  TextStyle _createDisplayStyleTextStyle(Color baseColor, String textFont,
      FontWeight materialFontWeight, BuildContext context) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: getFontSize(context),
      color: baseColor,
      fontFamily: textFont,
      letterSpacing: letterSpacing ?? -1.sp,
      height: textLineHeight ?? getLineHeight(),
    );
  }

  TextStyle _createDisplayLargeTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : FontSizes.xsmall,
      color: baseColor,
      fontFamily: textFont,
      letterSpacing: letterSpacing ?? -0.25,
      height: lineHeight ?? 1.12,
    );
  }

  TextStyle _createDisplayMediumTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 30.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing,
      height: lineHeight ?? 1.16,
    );
  }

  TextStyle _createDisplaySmallTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 24.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing,
      height: lineHeight ?? 1.22,
    );
  }

  TextStyle _createWalletNormalTextStyle(String textFont) {
    return TextStyle(
      color: VisaColors.black,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontFamily: textFont,
      height: (18 / 14.sp).h,
    );
  }

  TextStyle _createWalletHighlightedTextStyle(String textFont) {
    return TextStyle(
      color: VisaColors.black,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      fontFamily: textFont,
      height: (18 / 14.sp).h,
    );
  }

  TextStyle _createHeadlineLargeTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 34.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing,
      height: lineHeight ?? 1.25,
    );
  }

  TextStyle _createHeadlineMediumTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 28.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing,
      height: lineHeight ?? 1.29,
    );
  }

  TextStyle _createHeadlineSmallTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontFamily: textFont,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 20.sp,
      color: baseColor,
      letterSpacing: letterSpacing,
      height: lineHeight ?? 1.33,
    );
  }

  TextStyle _createTitleLargeTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 30.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing,
      height: lineHeight ?? 1.27,
    );
  }

  TextStyle _createTitleMediumTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 24.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.15,
      height: lineHeight ?? 1.5,
    );
  }

  TextStyle _createTitleSmallTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 18.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.1,
      height: lineHeight ?? 1.43,
    );
  }

  TextStyle _createBodyLargeTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 16.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.5,
      height: lineHeight ?? 1.5,
    );
  }

  TextStyle _createBodyMediumTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 14.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.25,
      height: lineHeight ?? 1.43,
    );
  }

  TextStyle _createBodySmallTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 12.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.4,
      height: lineHeight ?? 1.33,
    );
  }

  TextStyle _createLabelLargeTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 14.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.1,
      height: lineHeight ?? 1.43,
    );
  }

  TextStyle _createLabelMediumTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 12.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.5,
      height: lineHeight ?? 1.33,
    );
  }

  TextStyle _createLabelSmallTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 11.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.5,
      height: lineHeight ?? 1.45,
    );
  }

  TextStyle _createCaptionLargeTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 12.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.4,
      height: lineHeight ?? 1.33,
    );
  }

  TextStyle _createCaptionMediumTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 11.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.5,
      height: lineHeight ?? 1.45,
    );
  }

  TextStyle _createCaptionSmallTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 10.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.5,
      height: lineHeight ?? 1.2,
    );
  }

  TextStyle _createButtonTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 14.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 1.25,
      height: lineHeight ?? 1.43,
    );
  }

  TextStyle _createLinkTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 14.sp,
      fontFamily: textFont,
      decorationThickness: 1.5,
      color: baseColor,
      letterSpacing: letterSpacing ?? 1,
      height: lineHeight ?? 1.43,
    );
  }

  TextStyle _createOverLineTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 10.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 1.5,
      height: lineHeight ?? 1.6,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  TextStyle _createCustomLargeTextStyle(Color baseColor, String textFont,
      FontWeight materialFontWeight, BuildContext context) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: _getCustomLargeFontSize(context),
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? -1,
      height: lineHeight ?? 1.2,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  double _getCustomLargeFontSize(BuildContext context) {
    if (fontSize != null) {
      return fontSize!;
    }
    final responsiveUtil = Provider.of<ResponsiveUtil>(context, listen: false);
    if (responsiveUtil.isDesktop(context: context)) {
      return 54.sp;
    } else if (responsiveUtil.isTablet(context: context)) {
      return 30.sp;
    } else {
      return 24.sp;
    }
  }

  TextStyle _createCustomMediumTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 14.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 1,
      height: lineHeight ?? 1.6,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  TextStyle _createCustomSmallTextStyle(Color baseColor) {
    return TextStyle(
      color: baseColor,
      fontSize: (fontSize != null) ? fontSize : 14.sp,
      letterSpacing: letterSpacing ?? 1.5,
      height: lineHeight ?? 1.6,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  TextStyle _createCustomTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : fontSize,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.5,
      height: lineHeight ?? 1.5,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  TextStyle _createDefaultTextStyle(
      Color baseColor, String textFont, FontWeight materialFontWeight) {
    return TextStyle(
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: materialFontWeight,
      fontSize: (fontSize != null) ? fontSize : 14.sp,
      fontFamily: textFont,
      color: baseColor,
      letterSpacing: letterSpacing ?? 0.25,
      height: lineHeight ?? 1.43,
    );
  }

  double getMaxScale(double fontSize) {
    if (fontSize < 10) return 2;
    if (fontSize < 14) return 1.7;
    if (fontSize < 20) return 1.4;
    return 1.3;
  }

  double getCappedScale(BuildContext context, double fontSize) {
    final currentScale = MediaQuery.of(context).textScaler.scale(1);
    final maxAllowed = getMaxScale(fontSize);
    return currentScale > maxAllowed ? maxAllowed : currentScale;
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
              child: semantics == false
                  ? ExcludeSemantics(
                      child: _buildTextContent(context, themeProvider))
                  : Semantics(
                      sortKey: semanticsIndex != null
                          ? OrdinalSortKey(semanticsIndex!.toDouble())
                          : null,
                      enabled: true,
                      container: true,
                      excludeSemantics: true,
                      focusable: semanticsFocus,
                      focused: semanticsFocus,
                      label: semanticsLabel ??
                          (textLength != null
                              ? text.substring(
                                  0, textLength!.clamp(0, text.length))
                              : text),
                      child: _buildTextContent(context, themeProvider),
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextContent(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      // padding: (style == VisaTextStyle.link)
      //     ? EdgeInsets.zero
      //     : EdgeInsets.zero,
      // margin: EdgeInsets.zero,
      // Space between text and underline
      decoration: (style == VisaTextStyle.link)
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      _getTextStyle(themeProvider.isDarkMode, context).color ??
                          Colors.black,
                  width: 0.8.w,
                ),
              ),
            )
          : null,
      child: Text(
        textLength != null
            ? text.substring(0, textLength!.clamp(0, text.length))
            : text,
        textScaler: TextScaler.linear(getCappedScale(context, fontSize ?? 14)),
        style: _getTextStyle(themeProvider.isDarkMode, context),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textWidthBasis: textWidthBasis,
      ),
    );
  }

  double getFontSize(BuildContext context) {
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

  double getLineHeight() {
    switch (style) {
      case VisaTextStyle.displayStyleH1:
        return (49 / 48); //1.02
      case VisaTextStyle.displayStyleH2:
        return (45 / 44); //1.02
      case VisaTextStyle.displayStyleH3:
        return (41 / 40); //1.02
      case VisaTextStyle.displayStyleH4:
        return (37 / 36); //1.02
      case VisaTextStyle.displayStyleH5:
        return (31 / 30); //1.03
      case VisaTextStyle.displayTitleLarge:
        return (29 / 28); //1.03
      case VisaTextStyle.displayTitleMedium:
        return (25 / 24); // 1,04
      case VisaTextStyle.displayTitleSmall:
        return (21 / 20); //1.05
      case VisaTextStyle.displayBodyXl:
        return (20 / 18); // 1.1
      case VisaTextStyle.displayBodyL:
        return (20 / 16); //1.25
      case VisaTextStyle.displayBodyS:
        return (20 / 14); // 1.42
      case VisaTextStyle.displayBodyXs:
        return (14 / 12); //1.16

      default:
        return 1;
    }
  }
}
