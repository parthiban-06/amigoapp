import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

class CustomSplitView extends StatelessWidget {
  final Widget rightWightView;
  final bool isDesktopView;
  final bool isVisaLogoSemanticsShowFirstTime;

  const CustomSplitView(
      {required this.rightWightView,
      required this.isDesktopView,
      required this.isVisaLogoSemanticsShowFirstTime,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          // Left side with Visa logo
          Expanded(
            flex: isDesktopView ? Sizes.fiftySevenInt : Sizes.fortyThreeInt,
            child: Container(
              color: Theme.of(context).colorScheme.primaryFixedDim,
              // Visa blue
              height: double.infinity,
              padding: EdgeInsets.only(
                  bottom: isDesktopView
                      ? Sizes.hundredInt.toDouble()
                      : Sizes.eightyInt.toDouble()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  VisaSvgIcon(
                    semantics: isVisaLogoSemanticsShowFirstTime,
                    semanticsIndex:
                        isVisaLogoSemanticsShowFirstTime ? Sizes.oneInt : null,
                    useWithoutColor: true,
                    assetPath: Assets.iconsIcVisaLogo,
                    width: isDesktopView
                        ? Sizes.twoHundredNinetyFour.w
                        : Sizes.hundredInt.w,
                    height: isDesktopView
                        ? Sizes.ninetyFiveInt.h
                        : Sizes.fiftyFiveInt.h,
                  ),
                  VisaSizeBox(
                    height: Sizes.twentyInt.toDouble(),
                  ),
                  VisaTextView(
                    semantics: isVisaLogoSemanticsShowFirstTime,
                    semanticsIndex:
                        isVisaLogoSemanticsShowFirstTime ? Sizes.twoInt : null,
                    text:
                        S.of(context).everywhere_you_want.capitalizeEachWord(),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: VisaTextStyle.custom,
                    fontFamily: VisaFontWeight.regular,
                    fontSize: context.getCustomFontSize(
                      desktopSize: Sizes.twentyFourInt,
                      tabSize: Sizes.sixteenInt,
                      mobileSize: Sizes.sixteenInt,
                    ),
                    customColor: VisaColors.white,
                    colorTheme: VisaTextTheme.customTextColor,
                    textAlign: TextAlign.center,
                    lineHeight: (18 / 24).toDouble(),
                  ),
                ],
              ),
            ),
          ),

          // Right side with language selection
          Expanded(
            flex: isDesktopView ? Sizes.fortyThreeInt : Sizes.fiftySevenInt,
            child: rightWightView,
          ),
        ],
      ),
    );
  }
}
