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
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

class ItineraryPopup extends StatelessWidget {
  final String place;

  const ItineraryPopup({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VisaColors.transparent,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            width: context.screenWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: VisaColors.blueBackgroundLightNew),
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
                      Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: VisaColors.primary),
                        child: Center(
                          child: VisaSvgIcon(
                            height: Sizes.thirtySeven.h,
                            width: Sizes.thirtySeven.w,
                            assetPath: Assets.iconsIcCalendar,
                            color: VisaColors.blueBackgroundLightNew,
                          ),
                        ),
                      ),
                      VisaSizeBox(
                        height: 20.h,
                      ),
                      VisaTextView(
                        text: S.of(context).add_to_itinerary,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.customLarge,
                        fontFamily: VisaFontWeight.medium,
                        fontSize: 36.sp,
                        customColor: VisaColors.primary,
                        colorTheme: VisaTextTheme.customTextColor,
                        letterSpacing: 0,
                      ),
                      VisaSizeBox(
                        height: 20.h,
                      ),
                      VisaTextView(
                        text: S.of(context).adding_to_your_itinerary,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.customLarge,
                        fontFamily: VisaFontWeight.medium,
                        fontSize: 14.sp,
                        lineHeight: 18 / 14,
                        customColor: VisaColors.primary,
                        colorTheme: VisaTextTheme.customTextColor,
                        letterSpacing: 0,
                      ),
                      VisaSizeBox(
                        height: 24.h,
                      ),
                    ],
                  ),
                  VisaButton(
                    text: S.of(context).i_acknowledge,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      AppRouter.router
                          .push(AppRoutes.addItinerary, extra: place.trim());
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
