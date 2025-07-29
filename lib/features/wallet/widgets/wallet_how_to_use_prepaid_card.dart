import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_rich_text.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_animated_text.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

class WalletHowToUsePrepaidCard extends StatelessWidget {
  const WalletHowToUsePrepaidCard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VisaAnimatedText(
          child: VisaTextView(
            text: S.of(context).how_to_use,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontFamily: VisaFontWeight.semibold,
            fontSize: 18.sp,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: 0,
          ),
        ),
        VisaSizeBox(
          height: 10.h,
        ),
        VisaAnimatedText(
          delay: const Duration(milliseconds: 100),
          child: VisaTextView(
              text: s.your_card_will_be,
              overflow: TextOverflow.visible,
              style: VisaTextStyle.customLarge,
              fontFamily: VisaFontWeight.regular,
              customColor: VisaColors.black,
              colorTheme: VisaTextTheme.customTextColor,
              fontSize: 14.sp,
              lineHeight: (18 / 14.sp).h),
        ),
        VisaSizeBox(
          height: 16.h,
        ),
        VisaAnimatedText(
          delay: const Duration(milliseconds: 200),
          child: VisaTextView(
              text: s.you_will_lose_access,
              overflow: TextOverflow.visible,
              style: VisaTextStyle.customLarge,
              fontFamily: VisaFontWeight.regular,
              customColor: VisaColors.black,
              colorTheme: VisaTextTheme.customTextColor,
              fontSize: 14.sp,
              lineHeight: (18 / 14.sp).h),
        ),
        VisaSizeBox(
          height: 16.h,
        ),
        VisaAnimatedText(
          delay: const Duration(milliseconds: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VisaRichText(
                overflow: TextOverflow.visible,
                textSpans: [
                  VisaTextSpan(
                    text: s.view_your_balance,
                    style: VisaTextStyle.walletNormal,
                  ),
                ],
              ),
              VisaSizeBox(
                height: Sizes.sixteenInt.h,
              ),
            ],
          ),
        ),
        VisaAnimatedText(
          delay: const Duration(milliseconds: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VisaRichText(
                overflow: TextOverflow.visible,
                textSpans: [
                  VisaTextSpan(
                    text: s.for_questions,
                    style: VisaTextStyle.walletNormal,
                  ),
                  VisaTextSpan(
                      text: s.our_faqs,
                      style: VisaTextStyle.walletHighlighted,
                      onTap: () {
                        AppRouter.router.pushRoute(AppRoutes.faq);
                      }),
                ],
              ),
              VisaSizeBox(
                height: Sizes.twentyFourInt.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  normalStyle() {
    return TextStyle(
        color: VisaColors.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        fontFamily: "VisaDialectUI",
        height: (18 / 14.sp).h);
  }

  highlightedStyle() {
    return TextStyle(
        color: VisaColors.primary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        fontFamily: "VisaDialectUI",
        height: (18 / 14.sp).h);
  }
}
