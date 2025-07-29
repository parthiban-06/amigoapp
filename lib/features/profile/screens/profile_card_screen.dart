import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/file_name_cleaner_extention.dart';

import '../../../custom_widgets/visa_auto_size_text.dart';
import '../../../utils/const_screen_size.dart';

class ProfileCardView extends StatelessWidget {
  final UserModel? userModel;
  final Function onChange;

  const ProfileCardView(
      {super.key, required this.userModel, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth.w,
      decoration: BoxDecoration(
          color: VisaColors.blueBackgroundLightNew,
          borderRadius: BorderRadius.circular(16).r),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.tweentyWidth,
            vertical: AppSizes.heightThrityFive),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.h),
                    child: Container(
                      height: AppSizes.thirtySixHeight,
                      width: AppSizes.thirtySixWidth,
                      decoration: const BoxDecoration(
                          color: VisaColors.primary, shape: BoxShape.circle),
                      child: Center(
                        child: VisaTextView(
                          text: userModel != null
                              ? (userModel!.firstName.toString())
                                  .toUpperCase()
                                  .substring(0, 1)
                              : "",
                          semantics: false,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.customLarge,
                          fontFamily: VisaFontWeight.regular,
                          fontSize: AppSizes.fontTweentyOne,
                          customColor: VisaColors.white,
                          colorTheme: VisaTextTheme.customTextColor,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                  // VisaSizeBox(
                  //   width: width:AppSizes.tweleveWidth,
                  // ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: AppSizes.twelveRadius),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VisaAutoSizeText(
                            text: userModel != null
                                ? ("${userModel!.firstName} ${userModel!.lastName}")
                                : "",
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: VisaTextStyle.customLarge,
                            fontFamily: VisaFontWeight.bold,
                            fontSize: AppSizes.fontMedium,
                            customColor: VisaColors.black,
                            colorTheme: VisaTextTheme.customTextColor,
                            letterSpacing: -0.5,
                          ),
                          VisaSizeBox(
                            height: 4.h,
                          ),
                          VisaAutoSizeText(
                            text: userModel != null ? userModel!.email : "",
                            softWrap: true,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: VisaTextStyle.customLarge,
                            fontFamily: VisaFontWeight.medium,
                            fontSize: AppSizes.fontfourteen,
                            customColor: VisaColors.black,
                            colorTheme: VisaTextTheme.customTextColor,
                            letterSpacing: -0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                FirebaseAnalyticsService.logEventButtonClick(
                    btnName: AppRoutes.editProfile);
                await AppRouter.router.push(AppRoutes.editProfile);
                onChange();
              },
              child: Semantics(
                button: true,
                label: Assets.iconsEditProfile.cleanedFileName,
                excludeSemantics: true,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: Sizes.eight),
                  child: VisaSvgIcon(
                      semantics: false,
                      assetPath: Assets.iconsEditProfile,
                      width: AppSizes.dimMedium,
                      height: AppSizes.heightTweentyFour),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
