import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../analytics/firebase_analytics_service.dart';
import '../features/select_languages/providers/language_selection_generic_provider.dart';
import '../ui/provider/theme_provider.dart'; // Import the VisaTextView class, its enums and utilities
// Import the VisaTextView class, its enums and utilities
import '../utils/const_screen_size.dart';
import 'visa_textview.dart';

class VisaRichText extends StatelessWidget {
  final List<VisaTextSpan> textSpans;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final bool softWrap;
  final TextWidthBasis textWidthBasis;
  final bool semantics;
  final int? semanticsIndex;
  final String? semanticsLabel;

  const VisaRichText({
    super.key,
    required this.textSpans,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap = true,
    this.textWidthBasis = TextWidthBasis.parent,
    this.semantics = true,
    this.semanticsIndex,
    this.semanticsLabel,
  });

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
                      child: _getRichTextWidget(context, themeProvider),
                    )
                  : Semantics(
                      sortKey: semanticsIndex != null
                          ? OrdinalSortKey(semanticsIndex!.toDouble())
                          : null,
                      enabled: true,
                      hidden: false,
                      label: semanticsLabel ?? "",
                      child: _getRichTextWidget(context, themeProvider),
                    ),
            );
          },
        );
      },
    );
  }

  Widget _getRichTextWidget(BuildContext context, ThemeProvider themeProvider) {
    return RichText(
      textScaler:
          TextScaler.linear(Utils.getCappedScale(context, AppSizes.fontMedium)),
      text: TextSpan(
        children: textSpans
            .map((span) => span.getTextSpan(themeProvider.isDarkMode, context))
            .toList(),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textWidthBasis: textWidthBasis,
    );
  }
}

class VisaTextSpan {
  final String text;
  final String? semanticTitle;
  final VisaTextStyle style;
  final VisaTextTheme colorTheme;
  final Color customColor;
  final bool isItalic;
  final double? letterSpacing;
  final double? lineHeight;
  final double? fontSize;
  final VisaFontWeight fontFamily;
  final GestureTapCallback? onTap;
  final TextDecoration? decoration;
  final double? textLineHeight;
  final double? decorationThickness;

  // Added icon properties
  final String? iconPath;
  final double? iconHeight;
  final double? iconWidth;
  final Color? iconColor;
  final double? iconSpacing;
  final EdgeInsets? iconPadding;
  final EdgeInsets? iconMargin;

  VisaTextSpan({
    required this.text,
    this.customColor = Colors.black,
    this.style = VisaTextStyle.bodyMedium,
    this.colorTheme = VisaTextTheme.primary,
    this.isItalic = false,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.02,
    this.fontSize,
    this.textLineHeight,
    this.fontFamily = VisaFontWeight.regular,
    this.onTap,
    this.decoration,
    this.semanticTitle,
    // Initialize icon properties
    this.iconPath,
    this.iconWidth,
    this.iconHeight,
    this.iconColor,
    this.iconSpacing,
    this.iconPadding,
    this.iconMargin,
    this.decorationThickness = 1.5,
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

    switch (style) {
      // Reusing the same style logic as VisaTextView to maintain consistency
      case VisaTextStyle.displayLarge:
      case VisaTextStyle.custom:
        return TextStyle(
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          fontWeight: materialFontWeight,
          fontSize: (fontSize != null) ? fontSize : FontSizes.xsmall,
          color: baseColor,
          fontFamily: textFont,
          letterSpacing: letterSpacing ?? -0.25,
          height: lineHeight ?? 1.12,
          decoration: decoration,
          decorationThickness: decorationThickness,
        );
      // Add more cases as needed, mirroring VisaTextView styles
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
        double fontSizeCustom = _getHeadingFontSize(context);
        return TextStyle(
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          fontWeight: materialFontWeight,
          fontSize: (fontSize != null) ? fontSize : fontSizeCustom,
          color: baseColor,
          fontFamily: textFont,
          letterSpacing: letterSpacing ?? -1.sp,
          height: textLineHeight ?? _getHeadingLineHeight(),
          decoration: decoration,
          decorationThickness: decorationThickness,
        );

      case VisaTextStyle.walletNormal:
        return TextStyle(
            color: VisaColors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            fontFamily: textFont,
            height: (18 / 14.sp).h);

      case VisaTextStyle.walletHighlighted:
        return TextStyle(
            color: VisaColors.primary,
            fontSize: 14.sp,
            decoration: TextDecoration.underline,
            decorationThickness: decorationThickness,
            fontWeight: FontWeight.w600,
            fontFamily: textFont,
            height: (18 / 14.sp).h);
      // Default case to handle other styles
      default:
        return TextStyle(
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          fontWeight: materialFontWeight,
          fontSize: (fontSize != null) ? fontSize : 14.sp,
          fontFamily: textFont,
          color: baseColor,
          letterSpacing: letterSpacing ?? 0.25,
          height: lineHeight ?? 1.43,
          decoration: decoration,
          decorationThickness: decorationThickness,
        );
    }
  }

  double _getHeadingFontSize(BuildContext context) {
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

  double _getHeadingLineHeight() {
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

  InlineSpan getTextSpan(bool isDarkMode, BuildContext context) {
    TextStyle textStyle = _getTextStyle(isDarkMode, context);
    if(MediaQuery.of(context).boldText){
      textStyle = textStyle.copyWith(
        fontWeight: MediaQuery.of(context).boldText ? FontWeight.bold : textStyle.fontWeight,
      );
    }
    final TextStyle? iconTextStyle = iconPath != null
        ? textStyle.copyWith(
            fontSize: iconHeight?.sp ?? textStyle.fontSize,
            color: iconColor ?? textStyle.color)
        : null;

    // If there's no icon, return a simple TextSpan
    if (iconPath.isNullOrEmpty) {
      return TextSpan(
        text: text,
        semanticsLabel: semanticTitle ?? (text.toLowerCase().startsWith(S.of(context).faq.toLowerCase()) ? S.of(context).frequently_asked_questions : text),
        style: textStyle,
        recognizer: onTap != null
            ? (TapGestureRecognizer()
              ..onTap = () {
                setAnalytics(context, text);
                onTap!();
              })
            : null,
      );
    }

    // If there's an icon, return a TextSpan with children
    return TextSpan(
      style: textStyle,
      recognizer: onTap != null
          ? (TapGestureRecognizer()
            ..onTap = () {
              setAnalytics(context, text);
              onTap!();
            })
          : null,
      children: [
        TextSpan(text: text),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Directionality(
            textDirection: Directionality.of(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: iconSpacing ?? Sizes.ten),
                VisaSvgIcon(
                  assetPath: iconPath!,
                  width: iconWidth?.sp ?? (textStyle.fontSize ?? 14.sp),
                  height: iconHeight?.sp ?? (textStyle.fontSize ?? 14.sp),
                  color: iconColor ?? textStyle.color,
                  padding: iconPadding ?? EdgeInsets.zero,
                  margin: iconMargin ?? EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void setAnalytics(BuildContext context, String text) {
    SelectLanguageGenericProvider localLanguageProvider =
        Provider.of<SelectLanguageGenericProvider>(context, listen: false);
    FirebaseAnalyticsService.logEventButtonClick(
        btnName: localLanguageProvider.getKeyFromValue(text),
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: AppRouter.router.state.path ?? "",
      }
    );
  }
}
