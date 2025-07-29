import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_rich_text.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_animated_text.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/shared_preferences.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../router/app_router.dart';
import '../../../router/app_routes_const.dart';

class WalletHowToUseTravelCredit extends StatelessWidget {
  const WalletHowToUseTravelCredit({super.key});

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
          child: VisaRichText(
            overflow: TextOverflow.visible,
            textSpans: [
              VisaTextSpan(
                text: s.when_you,
                style: VisaTextStyle.walletNormal,
              ),
              VisaTextSpan(
                  text: s.redeem_your_travel_credit,
                  style: VisaTextStyle.walletHighlighted,
                  onTap: () async {
                    String ln = await Preferences.getString(
                        Preferences.keyLanguageCode);
                    if (context.mounted) {
                      AppRouter.router.push(AppRoutes.redirecting, extra: {
                        "url": "https://www.booking.com/travel_coupon.$ln.html",
                        "deeplink": "",
                        "openInternalBrowser": true,
                        "bottomMessage": S.of(context).any_booking_from_this,
                      });

                      FirebaseAnalyticsService.logEvent(
                        eventName: "travelcredit_redeemclicked",
                        parameters: {
                          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
                              FirebaseAnalyticsService.genericUiElement,
                          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                              "redeem_your_travel_credit",
                        },
                      );
                    }
                  }),
              VisaTextSpan(
                text: s.on_booking_you_will,
                style: VisaTextStyle.walletNormal,
              ),
            ],
          ),
        ),
        VisaSizeBox(
          height: 16.h,
        ),
        VisaAnimatedText(
          delay: const Duration(milliseconds: 200),
          child: VisaTextView(
            text: s.once_you_add_your,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontFamily: VisaFontWeight.regular,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            fontSize: AppSizes.fontfourteen,
            lineHeight: (18 / 14.sp).h,
          ),
        ),
        VisaSizeBox(
          height: 16.h,
        ),
        VisaAnimatedText(
          delay: const Duration(milliseconds: 300),
          child: Column(
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
                    text: s.see,
                    style: VisaTextStyle.walletNormal,
                  ),
                  VisaTextSpan(
                      text: s.booking_terms_conditions,
                      style: VisaTextStyle.walletHighlighted,
                      onTap: () async {
                        String ln = await Preferences.getString(
                            Preferences.keyLanguageCode);
                        if (context.mounted) {
                          AppRouter.router.push(AppRoutes.redirecting, extra: {
                            "url":
                                "https://www.booking.com/content/terms.$ln.html",
                            "deeplink": "",
                            "openInternalBrowser": true,
                            "bottomMessage":
                                S.of(context).any_booking_from_this,
                          });
                        }
                      }),
                ],
              ),
              VisaSizeBox(
                height: Sizes.twentyFourInt.h,
              ),
              Divider(
                height: Sizes.oneInt.h,
                color: VisaColors.textFieldBorder,
              ),
            ],
          ),
        ),
        VisaSizeBox(
          height: Sizes.twentyFourInt.h,
        ),
      ],
    );
  }
}
