import 'package:flutter/material.dart';

class VisaColors {
  // Brand Theme Colors
  static const primaryDark = Color(0xFF021E4C); // tertiary
  static const primary = Color(0xFF1434CB); // primary
  static const primary2 = Color(0xFF1534CC); // primaryFixedDim
  static const primaryLight = Color(0xFF3B57DE); // primaryContainer
  static const primaryLight2 = Color(0xFF2B94F5); // primaryFixed

  static const secondaryDark = Color(0xFFF7B600);
  static const secondary = Color(0xFFFCC015); // secondary
  static const secondaryLight = Color(0xFFFFD700);
  static const orageColor = Color(0xFFF7A105); // secondary

  // Dark Theme Colors
  static const darkPrimaryDark = Color(0xFF000000);
  static const darkPrimary = Color(0xFF163049);
  static const darkPrimaryLight = Color(0xFF2C445C);

  static const darkSecondaryDark = Color(0xFFDFB357);
  static const darkSecondary = Color(0xFFE1B96E);
  static const darkSecondaryLight = Color(0xFFE8C887);

  // Text Colors
  static const textTertiary5 = Color(0xFF666666);
  static const textTertiary7 = Color(0xFF333333);
  static const textFieldBorder = Color(0xFF767676);
  static const scrollBarThumb = Color(0xFFC6C6C6);
  static const chatTextColor = Color(0xFF1A1A1A);
  static const shimmerGrey = Color(0xFF2E2E2E);
  static const webViewGrey = Color(0xFF505050);
  static const white = Colors.white;
  static const black = Colors.black;

  // Tertiary Colors
  static const tertiary5 = Color(0xFFE0E0E0);
  static const greyBackGround = Color(0xFFF0EFEF);
  static const tertiary7 = Color(0xFFC0C0C0);
  static const grey = Color(0xFF9E9E9E);
  static const error = Color(0xFFD92A3C);
  static const red = Color(0xFFD65168);
  static const green = Color(0xFF40996B);

  // Common Colors
  static const greyLight = Color(0xFFF0F0F0);
  static const transparent = Colors.transparent;
  static const blueLight = Color(0XFF97C7E8);
  static const greyDotLight = Color(0xFFDDDDDD);
  static const blueTextLight = Color(0xFF408DFF);
  static const blueBackgroundLight = Color(0xFFC2EBFF);
  static const blueBackgroundLight2 = Color(0xFFE7F7FF);

  static const blueBackgroundLightNew = Color(0xFFC7EDFF);
  static const chatHistorySelectionColor = Color(0xFFE8EBFA);

  // Selected Circle Gradient Color Codes
  static const selectedFirstLayerGradientColor = Color(0xFFF9C941);
  static const selectedSecondLayerGradientColor = Color(0xFFFFDD68);
  static const selectedThirdLayerGradientColor = Color(0xFFFFEEA0);
  static const selectedBlurColor = Color(0x4CFCC014);

  // Un-Selected Circle Gradient Color Codes
  static const unSelectedFirstLayerGradientColor = Color(0xFFB6ECEB);
  static const unSelectedSecondLayerGradientColor = Color(0xFF9ACBF6);
  static const unSelectedThirdLayerGradientColor = Color(0xFF8EBDFF);
  static const unSelectedBlurColor = Color(0x3390BFFB);
  static const blurColor = Color(0xFF90BFFB);

  static const greyScrollTrackColor = Color(0xFFDCDBDB);
  static const weatherCardColor = Color(0xFFEAF4FE);
  static const weatherCardTextGreyColor = Color(0xFF969696);
  static const bookingBadgeColor = Color(0xFF021E4C);
  static const dividerColor = Color(0xFF767676);
  static const starYellowColor = Color(0xFFFCC015);
  static const dialogBgColor = Color(0xFFFBEEF0);
  static const bookingCardColor = Color(0xFF003B95);
  static const lightRed = Color(0xFFFBEEF0);
  static const ratingTextColor = Color(0xFFFFFEFF);
  static const tutorialBgColor = Color(0xFF021E4C);

  static const hotelCardBgColor = Color(0xFFD9D9D9);
  static const hotelCardEmptyBgColor = Color(0xFFEFEFEF);
}

class VisaTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.0),
    brightness: Brightness.light,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: VisaColors.primary,
      primaryFixed: VisaColors.primaryLight2,
      primaryFixedDim: VisaColors.primary2,
      onPrimary: VisaColors.white,
      primaryContainer: VisaColors.primaryLight,
      onPrimaryContainer: VisaColors.white,
      secondary: VisaColors.secondary,
      onSecondary: VisaColors.black,
      secondaryContainer: VisaColors.secondaryLight,
      onSecondaryContainer: VisaColors.black,
      tertiary: VisaColors.primaryDark,
      onTertiary: VisaColors.textTertiary5,
      tertiaryContainer: VisaColors.primaryLight,
      onTertiaryContainer: VisaColors.white,
      error: VisaColors.error,
      onError: VisaColors.white,
      surface: VisaColors.white,
      onSurface: VisaColors.black,
      outline: VisaColors.grey,
    ),
    // Text Theme
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.0),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: VisaColors.darkPrimary,
      primaryFixedDim: VisaColors.primary2,
      onPrimary: VisaColors.white,
      primaryFixed: VisaColors.primaryLight2,
      primaryContainer: VisaColors.darkPrimaryLight,
      onPrimaryContainer: VisaColors.white,
      secondary: VisaColors.darkSecondary,
      onSecondary: VisaColors.black,
      secondaryContainer: VisaColors.darkSecondaryLight,
      onSecondaryContainer: VisaColors.black,
      tertiary: VisaColors.darkPrimaryDark,
      onTertiary: VisaColors.white,
      tertiaryContainer: VisaColors.darkPrimaryLight,
      onTertiaryContainer: VisaColors.white,
      error: VisaColors.error,
      onError: VisaColors.white,
      surface: VisaColors.darkPrimaryDark,
      onSurface: VisaColors.white,
      outline: VisaColors.grey,
    ),
    // Text Theme
  );
}
