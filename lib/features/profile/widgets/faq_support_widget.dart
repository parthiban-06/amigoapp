import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

class FaqSupportWidget extends StatelessWidget {
  final String txt;
  final Function? onTap;

  const FaqSupportWidget({super.key, required this.txt, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Semantics(
        button: true,
        enabled: true,
        label: txt,
        child: Container(
          height: Sizes.sixtySixInt.h,
          width: context.screenWidth,
          decoration: BoxDecoration(
              color: VisaColors.blueBackgroundLightNew,
              borderRadius: BorderRadius.circular(Sizes.sixteenInt.h)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.sixteenInt.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VisaTextView(
                  semantics: false,
                  text: txt,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: VisaTextStyle.customLarge,
                  fontFamily: VisaFontWeight.semibold,
                  fontSize: Sizes.eighteenInt.h,
                  customColor: VisaColors.black,
                  lineHeight: 0,
                  colorTheme: VisaTextTheme.customTextColor,
                  letterSpacing: -0.5,
                ),
                VisaSizeBox(
                  width: Sizes.tenInt.toDouble(),
                ),
                Flexible(
                  child: VisaSvgIcon(
                    semantics: false,
                    assetPath: Assets.iconsIcLeftArrow,
                    color: VisaColors.black,
                    width: Sizes.twelveInt.w,
                    height: Sizes.twelveInt.h,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
