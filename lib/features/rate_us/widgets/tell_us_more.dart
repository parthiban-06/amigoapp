import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

class TellUsMore extends StatelessWidget {
  const TellUsMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VisaColors.transparent,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            width: context.screenWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: VisaColors.white),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VisaSizeBox(
                    height: 24.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        VisaSvgIcon(
                          height: 8.5.h,
                          width: 8.5.w,
                          assetPath: Assets.iconsIcClose,
                          color: VisaColors.black,
                        ),
                        VisaSizeBox(
                          width: 4.w,
                        ),
                        VisaTextView(
                          text: S.of(context).close.toUpperCase(),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.customLarge,
                          fontFamily: VisaFontWeight.medium,
                          fontSize: AppSizes.fontTwelve,
                          customColor: VisaColors.black,
                          colorTheme: VisaTextTheme.customTextColor,
                          letterSpacing: 2,
                        ),
                      ],
                    ),
                  ),
                  VisaSizeBox(
                    height: 24.h,
                  ),
                  Column(
                    children: [
                      VisaTextView(
                        text: S.of(context).tell_us_more,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.customLarge,
                        fontFamily: VisaFontWeight.medium,
                        fontSize: Sizes.thirtySixInt.toDouble(),
                        customColor: VisaColors.primary,
                        colorTheme: VisaTextTheme.customTextColor,
                        letterSpacing: -0.72,
                      ),
                      VisaSizeBox(
                        height: 24.h,
                      ),
                      VisaTextView(
                        text: S.of(context).based_on_your_experience,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.customLarge,
                        fontFamily: VisaFontWeight.medium,
                        fontSize: Sizes.twelveInt.toDouble(),
                        customColor: VisaColors.black,
                        lineHeight: (Sizes.sixteenInt.toDouble() /
                                Sizes.twelveInt.toDouble())
                            .h,
                        colorTheme: VisaTextTheme.customTextColor,
                        letterSpacing: 0,
                      ),
                      VisaSizeBox(
                        height: 24.h,
                      ),
                    ],
                  ),
                  VisaButton(
                    text: Platform.isIOS
                        ? S.of(context).take_me_to_app_store
                        : S.of(context).take_me_to_play_store,
                    onPressed: () async {
                      if (Platform.isAndroid) {
                        AppRouter.router
                            .pushRoute(AppRoutes.redirecting, extra: {
                          "url": AppConst.playStoreLink,
                          "bottomMessage": S.of(context).redirect_play_store,
                          "openInternalBrowser": false
                        });
                      } else if (Platform.isIOS) {
                        AppRouter.router
                            .pushRoute(AppRoutes.redirecting, extra: {
                          "url": AppConst.appStoreLink,
                          "bottomMessage": S.of(context).redirect_app_store,
                          "openInternalBrowser": false
                        });
                      }
                      Navigator.of(context).pop();
                    },
                    isDisable: false,
                    fontWeight: VisaFontWeight.medium,
                    variant: VisaButtonVariant.primary,
                  ),
                  VisaSizeBox(
                    height: 24.h,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
