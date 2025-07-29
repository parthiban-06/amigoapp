import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/utils/responsive_util.dart';

class FontScheme {
  final String title;
  final String subtitle;
  final String body;
  final String label;
  final String input;

  const FontScheme(
      {required this.title,
      required this.subtitle,
      required this.body,
      required this.label,
      required this.input});

  FontScheme.all(String font)
      : title = font,
        subtitle = font,
        body = font,
        label = font,
        input = font;

  static FontScheme get roboto => FontScheme.all('Roboto');

  static FontScheme get ubuntu => FontScheme.all('Ubuntu');

  FontScheme copyWith(
      {String? title,
      String? subtitle,
      String? body,
      String? label,
      String? input}) {
    return FontScheme(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        body: body ?? this.body,
        label: label ?? this.label,
        input: input ?? this.input);
  }
}

final fonts = FontScheme.ubuntu;
const colors = ColorScheme.light();

class FontSizes {
  BuildContext context;

  FontSizes(this.context);

  static double get xxsmall => 16.0.sp;

  static double get xsmall => 24.0.sp;

  static double get small => 32.0.sp;

  double get medium =>
      Provider.of<ResponsiveUtil>(context).isDesktop(context: context)
          ? 42.0.sp
          : 42.0.sp;

  static double get large => 52.0.sp;

  static double get xlarge => 64.0.sp;

  static double get xxlarge => 96.0.sp;

  static double get max => 128.0.sp;

  static double get giant => 256.0.sp;

  double get h1 => Provider.of<ResponsiveUtil>(context, listen: false)
          .isDesktop(context: context)
      ? 48.0.sp
      : 48.sp;

  double get h2 => Provider.of<ResponsiveUtil>(context, listen: false)
          .isDesktop(context: context)
      ? 44.sp
      : 44.0.sp;

  double get h3 => Provider.of<ResponsiveUtil>(context, listen: false)
          .isDesktop(context: context)
      ? 40.0.sp
      : 40.sp;

  double get h4 => Provider.of<ResponsiveUtil>(context, listen: false)
          .isDesktop(context: context)
      ? 36.0.sp
      : 36.sp;

  double get h5 => Provider.of<ResponsiveUtil>(context, listen: false)
          .isDesktop(context: context)
      ? 30.0.sp
      : 30.sp;

  double get displayTitleLarge =>
      Provider.of<ResponsiveUtil>(context, listen: false)
              .isDesktop(context: context)
          ? 28.0.sp
          : 28.sp;

  double get displayTitleMedium =>
      Provider.of<ResponsiveUtil>(context, listen: false)
              .isTablet(context: context)
          ? 30.0.sp
          : Provider.of<ResponsiveUtil>(context, listen: false)
                  .isDesktop(context: context)
              ? 40.0.sp
              : 24.sp;

  double get displayTitleSmall =>
      Provider.of<ResponsiveUtil>(context, listen: false)
              .isDesktop(context: context)
          ? 20.0.sp
          : 20.sp;

  double get displayBodyXL =>
      Provider.of<ResponsiveUtil>(context, listen: false)
              .isDesktop(context: context)
          ? 18.0.sp
          : 18.sp;

  double get displayBodyL => Provider.of<ResponsiveUtil>(context, listen: false)
          .isDesktop(context: context)
      ? 16.0.sp
      : 16.sp;

  double get displayBodyS => Provider.of<ResponsiveUtil>(context, listen: false)
          .isDesktop(context: context)
      ? 14.0.sp
      : 14.sp;

  double get displayBodyXs =>
      Provider.of<ResponsiveUtil>(context, listen: false)
              .isDesktop(context: context)
          ? 12.0.sp
          : 12.sp;
}

extension FontSizeExtension on BuildContext {
  double getCustomFontSize({
    required int desktopSize,
    required int tabSize,
    required int mobileSize,
  }) {
    final responsiveUtil = Provider.of<ResponsiveUtil>(this, listen: false);
    // Check isTablet Before isDesktop
    if (responsiveUtil.isTablet(context: this)) {
      return tabSize.toDouble();
    } else if (responsiveUtil.isDesktop(context: this)) {
      return desktopSize.toDouble();
    } else {
      return mobileSize.toDouble();
    }
  }
}

class FontSizesDeskTop {
  BuildContext context;

  FontSizesDeskTop(this.context);

  static double get xxsmall => 16.0.sp;

  static double get xsmall => 24.0.sp;

  static double get small => 32.0.sp;

  static double get medium => 42.0.sp;

  static double get large => 52.0.sp;

  static double get xlarge => 64.0.sp;

  static double get xxlarge => 96.0.sp;

  static double get max => 128.0.sp;

  static double get giant => 256.0.sp;

  double get h1 =>
      Provider.of<ResponsiveUtil>(context).isDesktop(context: context)
          ? 56.0.sp
          : 25.sp;

  static double get h2 => 44.0.sp;

  static double get h3 => 40.0.sp;

  static double get h4 => 36.0.sp;

  static double get h5 => 30.0.sp;

  static double get displayTitleLarge => 28.0.sp;

  static double get displayTitleMedium => 24.0.sp;

  static double get displayTitleMediumSecond => 24.0.sp;

  static double get displayTitleSmall => 20.0.sp;

  static double get displayBodyXL => 18.0.sp;

  static double get displayBodyL => 16.0.sp;

  static double get displayBodyS => 14.0.sp;

  static double get displayBodyXs => 12.0.sp;
}

class IconSizes {
  static double get xxsmall => 46.0.w;

  static double get xsmall => 52.0.w;

  static double get small => 64.0.w;

  static double get medium => 72.0.w;

  static double get large => 96.0.sp;

  static double get xlarge => 128.0.w;

  static double get xxlarge => 256.0.w;

  static double get max => 512.0;
}

class IconSizesDesktop {
  static double get xxsmall => 46.0.w;

  static double get xsmall => 52.0.w;

  static double get small => 64.0.w;

  static double get medium => 72.0.w;

  static double get large => 96.0.sp;

  static double get xlarge => 128.0.w;

  static double get xxlarge => 256.0.w;

  static double get max => 512.0;
}

class Sizes {
  // Double Sizes (from 0 to 100)
  static double get zero => 0.0.r;

  static double get one => 1.0.r;

  static double get two => 2.0.r;

  static double get three => 3.0.r;

  static double get four => 4.0.r;

  static double get five => 5.0.r;

  static double get six => 6.0.r;

  static double get seven => 7.0.r;

  static double get eight => 8.0.r;

  static double get nine => 9.0.r;

  static double get ten => 10.0.r;

  static double get eleven => 11.0.r;

  static double get twelve => 12.0.r;

  static double get thirteen => 13.0.r;

  static double get fourteen => 14.0.r;

  static double get fifteen => 15.0.r;

  static double get sixteen => 16.0.r;

  static double get seventeen => 17.0.r;

  static double get eighteen => 18.0.r;

  static double get nineteen => 19.0.r;

  static double get twenty => 20.0.r;

  static double get twentyOne => 21.0.r;

  static double get twentyTwo => 22.0.r;

  static double get twentyThree => 23.0.r;

  static double get twentyFour => 24.0.r;

  static double get twentyFive => 25.0.r;

  static double get twentySix => 26.0.r;

  static double get twentySeven => 27.0.r;

  static double get twentyEight => 28.0.r;

  static double get twentyNine => 29.0.r;

  static double get thirty => 30.0.r;

  static double get thirtyOne => 31.0.r;

  static double get thirtyTwo => 32.0.r;

  static double get thirtyThree => 33.0.r;

  static double get thirtyFour => 34.0.r;

  static double get thirtyFive => 35.0.r;

  static double get thirtySix => 36.0.r;

  static double get thirtySeven => 37.0.r;

  static double get thirtyEight => 38.0.r;

  static double get thirtyNine => 39.0.r;

  static double get forty => 40.0.r;

  static double get fortyOne => 41.0.r;

  static double get fortyTwo => 42.0.r;

  static double get fortyThree => 43.0.r;

  static double get fortyFour => 44.0.r;

  static double get fortyFive => 45.0.r;

  static double get fortySix => 46.0.r;

  static double get fortySeven => 47.0.r;

  static double get fortyEight => 48.0.r;

  static double get fortyNine => 49.0.r;

  static double get fifty => 50.0.r;

  static double get fiftyOne => 51.0.r;

  static double get fiftyTwo => 52.0.r;

  static double get fiftyThree => 53.0.r;

  static double get fiftyFour => 54.0.r;

  static double get fiftyFive => 55.0.r;

  static double get fiftySix => 56.0.r;

  static double get fiftySeven => 57.0.r;

  static double get fiftyEight => 58.0.r;

  static double get fiftyNine => 59.0.r;

  static double get sixty => 60.0.r;

  static double get sixtyOne => 61.0.r;

  static double get sixtyTwo => 62.0.r;

  static double get sixtyThree => 63.0.r;

  static double get sixtyFour => 64.0.r;

  static double get sixtyFive => 65.0.r;

  static double get sixtySix => 66.0.r;

  static double get sixtySeven => 67.0.r;

  static double get sixtyEight => 68.0.r;

  static double get sixtyNine => 69.0.r;

  static double get seventy => 70.0.r;

  static double get seventyOne => 71.0.r;

  static double get seventyTwo => 72.0.r;

  static double get seventyThree => 73.0.r;

  static double get seventyFour => 74.0.r;

  static double get seventyFive => 75.0.r;

  static double get seventySix => 76.0.r;

  static double get seventySeven => 77.0.r;

  static double get seventyEight => 78.0.r;

  static double get seventyNine => 79.0.r;

  static double get eighty => 80.0.r;

  static double get eightyOne => 81.0.r;

  static double get eightyTwo => 82.0.r;

  static double get eightyThree => 83.0.r;

  static double get eightyFour => 84.0.r;

  static double get eightyFive => 85.0.r;

  static double get eightySix => 86.0.r;

  static double get eightySeven => 87.0.r;

  static double get eightyEight => 88.0.r;

  static double get eightyNine => 89.0.r;

  static double get ninety => 90.0.r;

  static double get ninetyOne => 91.0.r;

  static double get ninetyTwo => 92.0.r;

  static double get ninetyThree => 93.0.r;

  static double get ninetyFour => 94.0.r;

  static double get ninetyFive => 95.0.r;

  static double get ninetySix => 96.0.r;

  static double get ninetySeven => 97.0.r;

  static double get ninetyEight => 98.0.r;

  static double get ninetyNine => 99.0.r;

  static double get oneHundred => 100.0.r;

  static double get twoHundred => 200.0;

  static double get oneThirtyTwo => 132.0;

  static double get oneHundredForty => 140.0;

  static double get oneHundredFortyNine => 149.0;

  static double get twoHundredSixteen => 216.0;

  static double get twoHundredEighteen => 218.0;

  static double get twoHundredThirty => 230.0;

  static double get twoHundredFifty => 250.0;

  static double get oneHundredFortyEight => 148.0;

  // Integer Sizes (from 0 to 100)
  static int get zeroInt => 0;

  static int get oneInt => 1;

  static int get twoInt => 2;

  static int get threeInt => 3;

  static int get fourInt => 4;

  static int get fiveInt => 5;

  static int get sixInt => 6;

  static int get sevenInt => 7;

  static int get eightInt => 8;

  static int get nineInt => 9;

  static int get tenInt => 10;

  static int get elevenInt => 11;

  static int get twelveInt => 12;

  static int get thirteenInt => 13;

  static int get fourteenInt => 14;

  static int get fifteenInt => 15;

  static int get sixteenInt => 16;

  static int get seventeenInt => 17;

  static int get eighteenInt => 18;

  static int get nineteenInt => 19;

  static int get twentyInt => 20;

  static int get twentyOneInt => 21;

  static int get twentyTwoInt => 22;

  static int get twentyThreeInt => 23;

  static int get twentyFourInt => 24;

  static int get twentyFiveInt => 25;

  static int get twentySixInt => 26;

  static int get twentySevenInt => 27;

  static int get twentyEightInt => 28;

  static int get twentyNineInt => 29;

  static int get thirtyInt => 30;

  static int get thirtyOneInt => 31;

  static int get thirtyTwoInt => 32;

  static int get thirtyThreeInt => 33;

  static int get thirtyFourInt => 34;

  static int get thirtyFiveInt => 35;

  static int get thirtySixInt => 36;

  static int get thirtySevenInt => 37;

  static int get thirtyEightInt => 38;

  static int get thirtyNineInt => 39;

  static int get fortyInt => 40;

  static int get fortyOneInt => 41;

  static int get fortyTwoInt => 42;

  static int get fortyThreeInt => 43;

  static int get fortyFourInt => 44;

  static int get fortyFiveInt => 45;

  static int get fortySixInt => 46;

  static int get fortySevenInt => 47;

  static int get fortyEightInt => 48;

  static int get fortyNineInt => 49;

  static int get fiftyInt => 50;

  static int get fiftyOneInt => 51;

  static int get fiftyTwoInt => 52;

  static int get fiftyThreeInt => 53;

  static int get fiftyFourInt => 54;

  static int get fiftyFiveInt => 55;

  static int get fiftySixInt => 56;

  static int get fiftySevenInt => 57;

  static int get fiftyEightInt => 58;

  static int get fiftyNineInt => 59;

  static int get sixtyInt => 60;

  static int get sixtyOneInt => 61;

  static int get sixtyTwoInt => 62;

  static int get sixtyThreeInt => 63;

  static int get sixtyFourInt => 64;

  static int get sixtyFiveInt => 65;

  static int get sixtySixInt => 66;

  static int get sixtySevenInt => 67;

  static int get sixtyEightInt => 68;

  static int get sixtyNineInt => 69;

  static int get seventyInt => 70;

  static int get seventyOneInt => 71;

  static int get seventyTwoInt => 72;

  static int get seventyThreeInt => 73;

  static int get seventyFourInt => 74;

  static int get seventyFiveInt => 75;

  static int get seventySixInt => 76;

  static int get seventySevenInt => 77;

  static int get seventyEightInt => 78;

  static int get seventyNineInt => 79;

  static int get eightyInt => 80;

  static int get eightyOneInt => 81;

  static int get eightyTwoInt => 82;

  static int get eightyThreeInt => 83;

  static int get eightyFourInt => 84;

  static int get eightyFiveInt => 85;

  static int get eightySixInt => 86;

  static int get eightySevenInt => 87;

  static int get eightyEightInt => 88;

  static int get eightyNineInt => 89;

  static int get ninetyInt => 90;

  static int get ninetyOneInt => 91;

  static int get ninetyTwoInt => 92;

  static int get ninetyThreeInt => 93;

  static int get ninetyFourInt => 94;

  static int get ninetyFiveInt => 95;

  static int get ninetySixInt => 96;

  static int get ninetySevenInt => 97;

  static int get ninetyEightInt => 98;

  static int get ninetyNineInt => 99;

  static int get hundredInt => 100;

  static int get oneHundredFiftyInt => 150;

  static int get oneHundredSixtyInt => 160;

  static int get oneHundredSeventyInt => 170;

  static int get oneHundredEightyInt => 180;

  static int get oneHundredSixteenInt => 116;

  static int get oneHundredTwentySixInt => 126;

  static int get oneHundredFour => 104;

  static int get oneHundredFiftyOneInt => 151;

  static int get twoHundredSeventeen => 217;

  static int get oneHundredSeventeen => 117;

  static int get oneHundredTwenty => 120;

  static int get twoHundredInt => 200;

  static int get twoHundredNinetyFour => 294;

  static int get oneHundredTwentyInt => 120;
}

class Dimensions {
  static double get xxsmall => 6.0.w;

  static double get xsmall => 8.0.w;

  static double get small => 16.0.w;

  static double get medium => 24.0.w;

  static double get large => 48.0.w;

  static double get xlarge => 64.0.w;

  static double get xxlarge => 96.0.w;

  static double get giant => 256.0.w;
}

class DimensionsHeight {
  static double get xxsmall => 6.0.h;

  static double get xsmall => 8.0.h;

  static double get small => 16.0.h;

  static double get medium => 24.0.h;

  static double get large => 48.0.h;

  static double get xlarge => 64.0.h;

  static double get xxlarge => 96.0.h;

  static double get giant => 256.0.h;
}

class Paddings {
  static EdgeInsets get zero => EdgeInsets.zero;

  static EdgeInsets get buttonLoose => EdgeInsets.symmetric(
      horizontal: Dimensions.xlarge, vertical: Dimensions.large);

  static EdgeInsets get containerTight => EdgeInsets.only(
      top: Dimensions.xsmall,
      left: Dimensions.xsmall,
      right: Dimensions.xsmall,
      bottom: Dimensions.xsmall);

  static EdgeInsets get label => EdgeInsets.only(
      top: Dimensions.small,
      left: Dimensions.small,
      right: Dimensions.small,
      bottom: Dimensions.large);

  static EdgeInsets get left => EdgeInsets.only(left: Dimensions.medium);

  static EdgeInsets get right => EdgeInsets.only(left: Dimensions.medium);

  static EdgeInsets get allXSmall => EdgeInsets.all(Dimensions.xsmall);

  static EdgeInsets get allSmall => EdgeInsets.all(Dimensions.small);

  static EdgeInsets get allMedium => EdgeInsets.all(Dimensions.medium);

  static EdgeInsets get allLarge => EdgeInsets.all(Dimensions.large);

  static EdgeInsets get logo => EdgeInsets.symmetric(
      horizontal: Dimensions.medium, vertical: Dimensions.medium);

  static EdgeInsets get container => EdgeInsets.symmetric(
      horizontal: Dimensions.medium, vertical: Dimensions.medium);

  static EdgeInsets get containerFluid => EdgeInsets.symmetric(
      horizontal: Dimensions.large, vertical: Dimensions.medium);

  static EdgeInsets get containerXFluid => EdgeInsets.symmetric(
      horizontal: Dimensions.xxlarge, vertical: Dimensions.xlarge);

  static EdgeInsets get card => EdgeInsets.symmetric(
      horizontal: Dimensions.large, vertical: Dimensions.medium);

  static EdgeInsets get cardFluid => EdgeInsets.symmetric(
      horizontal: Dimensions.xlarge, vertical: Dimensions.large);

  static EdgeInsets get button => EdgeInsets.symmetric(
      horizontal: Dimensions.large, vertical: Dimensions.medium);

  static EdgeInsets get input => EdgeInsets.symmetric(
      horizontal: Dimensions.large, vertical: Dimensions.medium);

  static EdgeInsets get inputLoose => EdgeInsets.symmetric(
      horizontal: Dimensions.xxlarge, vertical: Dimensions.xlarge);

  static EdgeInsets get listItem => EdgeInsets.only(bottom: Dimensions.large);

  static EdgeInsets get listItemHorizontal =>
      EdgeInsets.only(left: Dimensions.small, right: Dimensions.large);

  static EdgeInsets get bottom => EdgeInsets.only(bottom: Dimensions.medium);

  static EdgeInsets get top => EdgeInsets.only(top: Dimensions.medium);
}

class BorderRadii {
  static BorderRadius get zero => BorderRadius.circular(0.0);

  static BorderRadius get small => BorderRadius.circular(16.0.w);

  static BorderRadius get medium => BorderRadius.circular(32.0.w);

  static BorderRadius get large => BorderRadius.circular(46.0.w);

  static BorderRadius get xlarge => BorderRadius.circular(64.0.w);

  static BorderRadius get xxlarge => BorderRadius.circular(96.0.w);

  static BorderRadius get max => BorderRadius.circular(128.0.w);
}

// class Radii {
//   static Radius get zero => const Radius.circular(0.0);

//   static Radius get small => Radius.circular(16.0.w);

//   static Radius get medium => Radius.circular(32.0.w);

//   static Radius get large => Radius.circular(46.0.w);

//   static Radius get xlarge => Radius.circular(64.0.w);

//   static Radius get xxlarge => Radius.circular(96.0.w);

//   static Radius get max => Radius.circular(128.0.w);
// }

class VSpacings {
  static SizedBox get xxsmall => SizedBox(height: DimensionsHeight.xxsmall); //6
  static SizedBox get xsmall =>
      SizedBox(height: DimensionsHeight.xsmall); // 8.0

  static SizedBox get small => SizedBox(height: DimensionsHeight.small); // 16

  static SizedBox get medium => SizedBox(height: DimensionsHeight.medium); //24

  static SizedBox get large => SizedBox(height: DimensionsHeight.large); //48

  static SizedBox get xlarge => SizedBox(height: DimensionsHeight.xlarge); //64

  static SizedBox get xxlarge =>
      SizedBox(height: DimensionsHeight.xxlarge); //64

  static SizedBox get giant => SizedBox(height: DimensionsHeight.giant); //96
}

class HSpacings {
  static VisaSizeBox get xxsmall => VisaSizeBox(
        width: Dimensions.xxsmall,
        isHorozontal: false,
      );

  static VisaSizeBox get xsmall => VisaSizeBox(
        width: Dimensions.xsmall,
        isHorozontal: false,
      );

  // static SizedBox get xsmall => SizedBox(width: Dimensions.xsmall);

  static SizedBox get small => SizedBox(width: Dimensions.small);

  static SizedBox get medium => SizedBox(width: Dimensions.medium);

  static SizedBox get large => SizedBox(width: Dimensions.large);

  static SizedBox get xlarge => SizedBox(width: Dimensions.xlarge);
}

// class TextStyles {
//   static TextStyle get giant => TextStyle(
//       fontSize: FontSizes.xxlarge, color: Colors.white, fontFamily: fonts.body);

//   static TextStyle get giantTitle => TextStyle(
//       fontSize: FontSizes.xxlarge,
//       color: Colors.white,
//       height: 1.2,
//       fontFamily: fonts.title);

//   static TextStyle get dark => TextStyle(
//       fontSize: FontSizes.small,
//       color: Colors.black,
//       fontFamily: fonts.body,
//       height: 1.2);

//   static TextStyle get light => dark.copyWith(color: Colors.white);

//   static TextStyle get muted => dark.copyWith(color: Colors.grey[600]);

//   static TextStyle get error => TextStyle(
//       fontSize: FontSizes.small, color: colors.error, fontFamily: fonts.body);

//   static TextStyle get input => TextStyle(
//       height: 1.3,
//       fontSize: FontSizes.small,
//       fontWeight: FontWeight.w400,
//       color: Colors.black,
//       fontFamily: fonts.input);

//   static TextStyle get inputLight => input.copyWith(color: Colors.white);

//   static TextStyle get inputDisabled => input.copyWith(color: Colors.black54);

//   static TextStyle get title => TextStyle(
//       height: 1.3,
//       fontSize: FontSizes.xlarge,
//       fontWeight: FontWeight.w600,
//       fontFamily: fonts.title);

//   static TextStyle get titleLight => title.copyWith(color: Colors.white);

//   static TextStyle get subtitle =>
//       TextStyle(fontSize: FontSizes.large, fontFamily: fonts.subtitle);

//   static TextStyle get subtitleLight => TextStyle(
//       fontSize: FontSizes.large,
//       fontFamily: fonts.subtitle,
//       color: Colors.white);

//   static TextStyle get buttonDark => TextStyle(
//       fontSize: FontSizes.small, color: Colors.white, fontFamily: fonts.label);

//   static TextStyle get buttonLight => buttonDark.copyWith(color: Colors.black);

//   static TextStyle get buttonDarkSmall =>
//       buttonDark.copyWith(fontSize: FontSizes.small);

//   static TextStyle get buttonLightSmall =>
//       buttonLight.copyWith(fontSize: FontSizes.small);

//   static TextStyle get body => TextStyle(
//       fontSize: FontSizes.small, color: Colors.black, fontFamily: fonts.body);

//   static TextStyle get bodyLight => body.copyWith(color: Colors.white);
// }

// class Shapes {
//   static RoundedRectangleBorder get rounded =>
//       RoundedRectangleBorder(borderRadius: BorderRadii.large);

//   static RoundedRectangleBorder get maxed =>
//       RoundedRectangleBorder(borderRadius: BorderRadii.max);
// }

// class Shadows {
//   static BoxShadow get solid => const BoxShadow();

//   static BoxShadow get blurry =>
//       BoxShadow(color: Colors.black, blurRadius: 14.0.w);

//   static BoxShadow glowColor(Color color, {double? opacity}) => BoxShadow(
//       color: color.withValues(alpha: opacity ?? 0.54), blurRadius: 24.0.w);

//   static BoxShadow get glow => glowColor(Colors.white54);

//   static BoxShadow get spread => const BoxShadow();
// }

class AppSizes {
  // Font Sizes
  static double get fontXXSmall => 16.0.sp;

  static double get fontXSmall => 24.0.sp;

  static double get fontSmall => 36.0.sp;

  static double get fontMedium => 18.0.sp;

  static double get fontLarge => 52.0.sp;

  static double get fontSixty => 60.0.sp;

  static double get fontXLarge => 64.0.sp;

  static double get fontXXLarge => 96.0.sp;

  static double get fontMax => 128.0.sp;

  static double get fontGiant => 256.0.sp;

  static double get fontfourteen => 14.sp;

  static double get fontTweenty => 20.sp;

  static double get fontTweentyTwo => 22.sp;

  static double get fontNineteen => 19.sp;

  static double get fontTwelve => 12.sp;

  static double get fontThirty => 30.sp;

  static double get fontTweentysix => 26.sp;

  static double get fontTweentyOne => 21.14.sp;
  static double get fontThirtyFive => 35.0.sp;

  static double get fontThirtyTwo => 32.sp;
  static double get fifteen => 15.sp;

  // Icon Sizes
  static double get ten => 10.h;

  static double get iconXXSmall => 14.w;

  static double get iconXSmall => 52.0.w;

  static double get iconSmall => 64.0.w;

  static double get iconMedium => 72.0.w;

  static double get iconLarge => 96.0.w;

  static double get iconXLarge => 128.0.w;

  static double get iconXXLarge => 256.0.w;

  static double get iconMax => 512.0.w;

  // Dimensions
  static double get dimXXSmall => 6.0.w;

  static double get dimXSmall => 10.0.w;

  static double get dimSmall => 16.0.w;

  static double get dimMedium => 24.0.w;

  static double get twentyFive => 25.0.w;

  static double get twentySix => 26.0.w;

  static double get dimLarge => 48.0.w;

  static double get dimXLarge => 64.0.w;

  static double get dimXXLarge => 96.0.w;

  static double get dimGiant => 250.0.w;

  static double get twenty => 20.0.r;

  static double get fifteenDim => 15.0.w;

  // Heights
  static double get heightTwo => 2.h;

  static double get heightFour => 4.h;

  static double get heightFive => 5.0.h;

  static double get sixHeight => 6.h;

  static double get eightHeight => 8.h;

  static double get elevenHeight => 11.h;

  static double get tweleveHeight => 12.h;

  static double get tweentyHeight => 20.h;

  static double get tweentyThree => 23.0.h;

  static double get thirtyHeight => 30.0.h;

  static double get thirtyTwoHeight => 32.h;

  static double get thirtySixHeight => 36.0.h;

  static double get thirtyNineHeight => 39.h;

  static double get dividerHeight => 1.0.h;

  static double get heightThree => 3.0.h;

  static double get heightXXSmall => 6.0.h;

  static double get heightXSmall => 8.0.h;

  static double get heightSmall => 16.0.h;

  static double get heightEighteen => 18.0.h;

  static double get heightMedium => 26.0.h;

  static double get heightTweentyEight => 28.0.h;

  static double get heightTweentyFour => 24.0.h;

  static double get heightLarge => 48.0.h;

  static double get heightFourty => 40.0.h;

  static double get heightFourtyOne => 41.0.h;

  static double get heightFiftyFour => 54.0.h;

  static double get heightFiftyFive => 55.0.h;

  static double get heightXLarge => 60.0.h;

  static double get heightEighty => 82.0.h;

  static double get heightFifty => 50.0.h;

  static double get heightFiftySeven => 57.0.h;

  static double get heightNintyFive => 120.0.h;

  static double get heightXXLarge => 111.0.h;

  static double get heightHundrad => 100.0.h;

  static double get heightOneHundredFortyEight => 148.0;

  static double get heightOneTwenty => 120.0.h;

  static double get heightGiant => 200.h;

  static double get heightTwotweenty => 220.h;

  static double get heightTwoHunFive => 205.h;

  static double get heightFourteen => 14.0.h;

  static double get heightThrityFive => 35.0.h;

  static double get heightFourtyThree => 43.0.h;

  static double get heightFourtyFive => 45.0.h;

  static double get heightSeventySeven => 77.0.h;

  static double get heightSixtyFour => 64.0.h;
  static double get heightTwentyFive => 25.0.h;

//Width
  static double get tweleveWidth => 12.w;

  static double get oneWidth => 1.w;

  static double get fourWidth => 4.w;

  static double get fiveWidth => 5.w;

  static double get nineWidth => 9.0.w;

  static double get tweentyWidth => 20.w;

  static double get tweentyFourWidth => 24.w;

  static double get tweentyEightWidth => 28.w;

  static double get thirtySixWidth => 36.0.w;

  static double get thirtyWidth => 30.0.w;

  static double get fourtyWidth => 40.w;

  static double get thirtyTwoWidth => 32.0.w;

  static double get eightWidth => 8.w;

  static double get fiftyTwoWidth => 52.w;

  static double get fiftyFiveWidth => 55.w;

  static double get twoNintyFourWidth => 294.0.w;

  static double get sixtyWidth => 60.w;

  static double get eightyWidth => 80.0.w;

  static double get nintyWidth => 95.0.w;

  static double get hundradWidth => 100.0.w;

  static double get oneHundredFourWidth => 104.w;

  static double get oneSeventyWidth => 170.w;

  static double get oneTweentywWidth => 120.0.w;

  static double get oneThirtyTwWidth => 132.0.w;

  static double get fourTwentyEightWidth => 428.0.w;

  static double get fourFiveFourWidth => 454.0.w;

  static double get threeTwoEightWidth => 328.0.w;
  static double get twentyFiveWidth => 25.0.w;

  static double get fiftyWidth => 50.w;

  static double get navBarWidth => 300.w;

  // Paddings
  static EdgeInsets get paddingSmall => EdgeInsets.all(dimSmall);

  static EdgeInsets get paddingMedium => EdgeInsets.all(dimMedium);

  static EdgeInsets get paddingLarge => EdgeInsets.all(dimLarge);

  //Radius
  static double get zero => 0.0.r;

  static double get twoRadius => 2.0.r;

  static double get threeRadius => 3.0.r;

  static double get fiveRadius => 5.0.r;

  static double get eightRadius => 8.0.r;

  static double get tenRadius => 10.0.r;

  static double get twentySixRadius => 26.0.r;

  static double get twentyRadius => 20.0.r;

  static double get twentyFourRadius => 24.0.r;

  static double get twentyEightRadius => 28.0.r;

  static double get twentyNineRadius => 29.0.r;

  static double get thirtyradius => 30.0.r;

  static double get thirtySix => 36.0.r;

  static double get sixteenRadius => 16.0.r;

  static double get eightteenRadius => 18.0.r;

  static double get fiftyFiveRadius => 55.0.r;

  static double get fifty => 50.0.r;

  static double get twelveRadius => 12.0.r;

  static double get fourtyRadius => 40.0.r;

  static double get oneHundredRadius => 100.0.r;

  static double get twentyTwoRadius => 22.0.r;

  // value in int
  static int get zeroInt => 0;

  static int get fiftySevenInt => 57;

  static int get fiftyThreeInt => 53;

  static int get sixtyInt => 60;

  static int get twoInt => 2;

  static double get oneThirtyTwo => 132.0;

  // Border Radii
  static BorderRadius get borderRadiusSmall => BorderRadius.circular(dimXSmall);

  static BorderRadius get borderRadiusMedium => BorderRadius.circular(dimSmall);

  static BorderRadius get borderRadiusLarge => BorderRadius.circular(dimLarge);

  // Shadows
  static BoxShadow get shadowSmall =>
      BoxShadow(color: Colors.black, blurRadius: 4.0.w);

  static BoxShadow get shadowMedium =>
      BoxShadow(color: Colors.black, blurRadius: 8.0.w);

  static BoxShadow get shadowLarge =>
      BoxShadow(color: Colors.black, blurRadius: 16.0.w);

  //Vs spacing
  static SizedBox get xxsmallVS =>
      SizedBox(height: DimensionsHeight.xxsmall); //6
  static SizedBox get xsmallVS =>
      SizedBox(height: DimensionsHeight.xsmall); // 8.0
  static SizedBox get smallVS => SizedBox(height: DimensionsHeight.small); // 16
  static SizedBox get mediumVS =>
      SizedBox(height: DimensionsHeight.medium); //24
  static SizedBox get largeVS => SizedBox(height: DimensionsHeight.large); //48
  static SizedBox get xlargeVS =>
      SizedBox(height: DimensionsHeight.xlarge); //64
  static SizedBox get xxlargeVS =>
      SizedBox(height: DimensionsHeight.xxlarge); //64
  static SizedBox get giantVS => SizedBox(height: DimensionsHeight.giant); //96

// Hs spacing
  static VisaSizeBox get xxsmallHS => VisaSizeBox(
        width: Dimensions.xxsmall,
        isHorozontal: false,
      );

  static VisaSizeBox get xsmallHS => VisaSizeBox(
        width: Dimensions.xsmall,
        isHorozontal: false,
      );

  static SizedBox get smallHS => SizedBox(width: Dimensions.small);

  static SizedBox get mediumHS => SizedBox(width: Dimensions.medium);

  static SizedBox get mediHS => SizedBox(width: Dimensions.large);

  static SizedBox get largeHS => SizedBox(width: Dimensions.large);

  static SizedBox get xlargeHS => SizedBox(width: Dimensions.xlarge);
}
