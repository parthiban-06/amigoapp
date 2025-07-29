import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
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

import '../../../router/app_router.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/app_const.dart';
import '../../../utils/shared_preferences.dart';

class WalletCheckBalance extends StatelessWidget {
  const WalletCheckBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return DateTime.now().isAfter(DateTime(2026, 6, 1)) ||
            DateTime.now().isAtSameMomentAs(DateTime(2026, 6, 1))
        ? Semantics(
            enabled: true,
            button: true,
            label: S.of(context).check_balance,
            excludeSemantics: true,
            child: Column(
              children: [
                Divider(
                  height: Sizes.oneInt.h,
                  color: VisaColors.textFieldBorder,
                ),
                VisaSizeBox(
                  height: Sizes.twentyFourInt.h,
                ),
                InkWell(
                  onTap: () async {
                    FirebaseAnalyticsService.logEvent(
                      eventName: "prepaidcard_checkbalanceclicked",
                      parameters: {
                        AnalyticsEventConst
                            .PARAM_NAME_UI_ELEMENT_LOCATION: "wallet_prepaid_card",
                        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                        "check_balance",
                      },
                    );
                    String ln = await Preferences.getString(
                        Preferences.keyLanguageCode);
                    if (context.mounted) {
                      AppRouter.router.pushRoute(AppRoutes.redirecting, extra: {
                        "url": AppConst.prepaidSupport(ln),
                        "deeplink": "",
                        "openInternalBrowser": true,
                        "bottomMessage": S.of(context).you_are_being_to_prepaid,
                      });
                    }
                  },
                  child: Container(
                    height: 82.h,
                    width: context.screenWidth.w,
                    decoration: BoxDecoration(
                        color: VisaColors.blueBackgroundLightNew,
                        borderRadius: BorderRadius.circular(16).r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          VisaSvgIcon(
                            semantics: false,
                            height: Sizes.twentySix.h,
                            width: Sizes.twentySix.w,
                            assetPath: Assets.iconsWalletCurrentBalance,
                            color: context.theme.primaryColor,
                          ),
                          VisaSizeBox(
                            width: 16.w,
                          ),
                          VisaRichText(
                            semantics: false,
                            maxLines: 3,
                            textSpans: [
                              VisaTextSpan(
                                text: S.of(context).check_balance,
                                style: VisaTextStyle.displayBodyXl,
                                fontSize: Sizes.eighteenInt.sp,
                                letterSpacing: -0.51,
                                lineHeight: 1.11,
                                fontFamily: VisaFontWeight.semibold,
                                colorTheme: VisaTextTheme.customTextColor,
                                customColor: VisaColors.black,
                                iconHeight: Sizes.tenInt.h,
                                iconWidth: Sizes.fourteenInt.w,
                                iconPath: Assets.iconsIcRichTextRightArrow,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
