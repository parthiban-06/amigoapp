import 'dart:ui';

import 'package:visaamigo/custom_widgets/visa_textview.dart';

class VisaFontFamily {
  static const String light = 'VisaDialectLight';
  static const String lightItalic = 'VisaDialectLightItalic';
  static const String regular = 'VisaDialectRegular';
  static const String regularItalic = 'VisaDialectRegularItalic';
  static const String medium = 'VisaDialectMedium';
  static const String mediumItalic = 'VisaDialectMediumItalic';
  static const String semibold = 'VisaDialectSemibold';
  static const String semiboldItalic = 'VisaDialectSemiboldItalic';
  static const String bold = 'VisaDialectBold';
  static const String boldItalic = 'VisaDialectBoldItalic';
  static const String VisaDialectUI = 'VisaDialectBoldItalic';

  static String getFontFamily(VisaFontWeight? weight, bool? isItalic) {
    /* switch (weight) {
      case VisaFontWeight.light:
        return isItalic ? lightItalic : light;
      case VisaFontWeight.regular:
        return isItalic ? regularItalic : regular;
      case VisaFontWeight.medium:
        return isItalic ? mediumItalic : medium;
      case VisaFontWeight.semibold:
        return isItalic ? semiboldItalic : semibold;
      case VisaFontWeight.bold:
        return isItalic ? boldItalic : bold;
    }*/

    return "VisaDialectUI";
  }

  // Helper method to get FontWeight from VisaFontWeight
  static FontWeight getMaterialFontWeight(VisaFontWeight weight) {
    switch (weight) {
      case VisaFontWeight.light:
        return FontWeight.w300;
      case VisaFontWeight.regular:
        return FontWeight.w400;
      case VisaFontWeight.medium:
        return FontWeight.w500;
      case VisaFontWeight.semibold:
        return FontWeight.w600;
      case VisaFontWeight.bold:
        return FontWeight.w700;
    }
  }
}
