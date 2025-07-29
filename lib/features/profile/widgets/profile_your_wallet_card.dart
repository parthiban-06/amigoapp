import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../analytics/firebase_analytics_service.dart';
import '../../../router/app_router.dart';
import '../../../router/app_routes_const.dart';
import '../../home/providers/navigation_provider.dart';

class ProfileYourWalletCard extends StatelessWidget {
  const ProfileYourWalletCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSizes.tweentyHeight),
      child: GestureDetector(
        onTap: () async {
          // nav(context);
          final navigationBar =
              Provider.of<NavigationProvider>(context, listen: false);

          await navigationBar.goBranch(AppRoutes.homeScreenIndex);

          AppRouter.router.goRoute(AppRoutes.homeNestedWallet);

          // switch (navigationBar.selectedIndex) {
          //   case AppRoutes.HOME_SCREEN_INDEX:
          //     AppRouter.router.goRoute(AppRoutes.homeNestedWallet);
          //     break;
          //
          //   case AppRoutes.EVA_SCREEN_INDEX:
          //     AppRouter.router.goRoute(AppRoutes.evaNavNestedWallet);
          //     break;
          //
          //   case AppRoutes.ITINERARY_SCREEN_INDEX:
          //     AppRouter.router.goRoute(AppRoutes.itineraryNavNestedWallet);
          //
          //     break;
          //
          //   case AppRoutes.TICKET_SCREEN_INDEX:
          //     AppRouter.router.goRoute(AppRoutes.ticketsNavNestedWallet);
          //     break;
          // }
        },
        child: Semantics(
          label: S.of(context).your_wallet,
          container: true,
          button: true,
          excludeSemantics: true,
          onTap: () {
            nav(context);
          },
          child: Container(
            height: AppSizes.heightSixtyFour,
            width: context.screenWidth.w,
            decoration: BoxDecoration(
                color: VisaColors.blueBackgroundLight2,
                borderRadius: BorderRadius.circular(16).r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.tweentyWidth),
              child: Row(
                children: [
                  SvgPicture.asset(Assets.iconsWallet,
                      width: AppSizes.dimMedium),
                  VisaSizeBox(
                    width: AppSizes.dimSmall,
                  ),
                  Flexible(
                    child: VisaTextView(
                      text: S.of(context).your_wallet,
                      softWrap: true,
                      semantics: false,
                      overflow: TextOverflow.visible,
                      style: VisaTextStyle.customLarge,
                      fontFamily: VisaFontWeight.semibold,
                      fontSize: AppSizes.fontMedium,
                      customColor: VisaColors.black,
                      colorTheme: VisaTextTheme.customTextColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  VisaSizeBox(
                    width: AppSizes.eightWidth,
                  ),
                  VisaSvgIcon(
                    assetPath: Assets.iconsIcLeftArrow,
                    color: VisaColors.black,
                    semantics: false,
                    width: AppSizes.tweleveWidth,
                    height: AppSizes.tweleveHeight,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  nav(BuildContext context) {
    FirebaseAnalyticsService.logEvent(
      eventName: AnalyticsEventConst.EVENT_NAME_WALLET_CLICKED,
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: AppRoutes.profile,
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "access_wallet",
      },
    );
    FirebaseAnalyticsService.genericUiElement = AppRoutes.profile;
    AppRouter.router.pushRoute(AppRoutes.wallet);
  }
}
