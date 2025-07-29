import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_rich_text.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/theme_extension.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../generated/l10n.dart';

class WalletCheckCurrentBalanceCard extends StatelessWidget {
  const WalletCheckCurrentBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String ln = await Preferences.getString(Preferences.keyLanguageCode);
        if (context.mounted) {
          AppRouter.router.push(AppRoutes.redirecting, extra: {
            "url": "https://www.booking.com/wallet.$ln.html",
            "deeplink": "",
            "openInternalBrowser": true,
            "bottomMessage": S.of(context).any_booking_from_this,
          });

          FirebaseAnalyticsService.logEvent(
            eventName: "travelcredit_checkbalanceclicked",
            parameters: {
              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: "wallet_travel_credit",
              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "check_balance",
            },
          );
        }
      },
      child: Semantics(
        enabled: true,
        label: S.of(context).check_current_balance,
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
                  height: AppSizes.heightMedium,
                  width: AppSizes.twentySix,
                  assetPath: Assets.iconsWalletCurrentBalance,
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
                        text: S.of(context).check_current_balance,
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
      ),
    );
  }
}
