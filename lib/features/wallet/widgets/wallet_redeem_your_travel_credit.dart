import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_rich_text.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/theme_extension.dart';

class WallerRedeemUrTravelCredits extends StatelessWidget {
  final bool isRedeemed;

  const WallerRedeemUrTravelCredits({super.key, required this.isRedeemed});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      enabled: true,
      label: isRedeemed
          ? S.of(context).book_travel2
          : S.of(context).redeem_your_travel_credit2,
      child: Container(
        height: AppSizes.heightEighty,
        width: context.screenWidth.w,
        decoration: BoxDecoration(
            color: VisaColors.blueBackgroundLightNew,
            borderRadius: BorderRadius.circular(16).r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.tweentyWidth),
          child: Row(
            children: [
              VisaSvgIcon(
                semantics: false,
                height: Sizes.twentySix.h,
                width: Sizes.twentySix.w,
                assetPath: Assets.iconsIcTravel,
                color: context.theme.primaryColor,
              ),
              VisaSizeBox(
                width: AppSizes.dimSmall,
              ),
              Expanded(
                child: VisaRichText(
                  semantics: false,
                  maxLines: 3,
                  textSpans: [
                    VisaTextSpan(
                      text: isRedeemed
                          ? S.of(context).book_travel2
                          : S.of(context).redeem_your_travel_credit2,
                      style: VisaTextStyle.displayBodyXl,
                      fontSize: AppSizes.fontMedium,
                      letterSpacing: -0.51,
                      lineHeight: 1.11,
                      fontFamily: VisaFontWeight.semibold,
                      colorTheme: VisaTextTheme.customTextColor,
                      customColor: VisaColors.black,
                      iconHeight: AppSizes.ten,
                      iconWidth: AppSizes.iconXXSmall,
                      iconPath: Assets.iconsIcRichTextRightArrow,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
