import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/companion/model/list_companion.dart';
import 'package:visaamigo/features/home/model/match_details.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/visa_auto_size_text.dart';
import '../../../utils/const_screen_size.dart';

class CompanionCardView extends StatelessWidget {
  final int index;
  final MatchResponse? matchResponse;
  final CompanionProfile companionProfile;
  final Function onChange;
  final Function onChangeResend;
  late double fontfourteen;

  CompanionCardView(
      {super.key,
      required this.companionProfile,
      required this.onChange,
      required this.index,
      required this.matchResponse,
      required this.onChangeResend});

  @override
  Widget build(BuildContext context) {
    fontfourteen = AppSizes.fontfourteen;
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.heightSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VisaTextView(
            text:
                S.of(context).companion.toUpperCase() + " $index".toUpperCase(),
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontFamily: VisaFontWeight.medium,
            fontSize: AppSizes.fontTwelve,
            lineHeight: 16.8 / 12,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: 2,
          ),
          VisaSizeBox(
            height: 9.h,
          ),
          Semantics(
            container: true,
            enabled: true,
            label: S.of(context).companion.toUpperCase() +
                " $index".toUpperCase() +
                S.of(context).detail_card,
            child: Container(
              width: context.screenWidth.w,
              decoration: BoxDecoration(
                  color: VisaColors.blueBackgroundLightNew,
                  borderRadius: BorderRadius.circular(16).r),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.tweentyWidth,
                    vertical: AppSizes.heightTweentyFour),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                            height: AppSizes.thirtySixHeight,
                            width: AppSizes.thirtySixWidth,
                            decoration: const BoxDecoration(
                                color: VisaColors.primary,
                                shape: BoxShape.circle),
                            child: Center(
                              child: VisaTextView(
                                semantics: false,
                                text: (companionProfile.firstName.toString())
                                    .toUpperCase()
                                    .substring(0, 1),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: VisaTextStyle.customLarge,
                                fontFamily: VisaFontWeight.regular,
                                fontSize: 21.14,
                                customColor: VisaColors.white,
                                colorTheme: VisaTextTheme.customTextColor,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: Sizes.twelve),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VisaAutoSizeText(
                                    text:
                                        ("${companionProfile.firstName} ${companionProfile.lastName}"),
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: VisaTextStyle.customLarge,
                                    fontFamily: VisaFontWeight.bold,
                                    fontSize: AppSizes.fontMedium,
                                    customColor: VisaColors.black,
                                    colorTheme: VisaTextTheme.customTextColor,
                                    letterSpacing: -0.5,
                                  ),
                                  VisaSizeBox(
                                    height: 8.h,
                                  ),
                                  VisaAutoSizeText(
                                    text: companionProfile.email,
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: VisaTextStyle.customLarge,
                                    fontFamily: VisaFontWeight.semibold,
                                    fontSize: fontfourteen,
                                    customColor: VisaColors.black,
                                    colorTheme: VisaTextTheme.customTextColor,
                                    letterSpacing: -0.5,
                                  ),
                                  VisaSizeBox(
                                    height: 8.h,
                                  ),
                                  (matchResponse == null ||
                                          matchResponse!.data!.isEmpty)
                                      ? const SizedBox()
                                      : Builder(builder: (context) {
                                          final matchTeams = companionProfile
                                              .matchIds
                                              .map((matchId) {
                                            final data = matchResponse!.data
                                                .firstWhere((match) =>
                                                    match.id == matchId);
                                            return data.eventName +
                                                " " +
                                                data.matchTeams;
                                          }).toList();
                                          final matchTeamsText =
                                              matchTeams.join(', ');
                                          return SizedBox(
                                              width:
                                                  context.screenWidth * 0.575,
                                              child: VisaTextView(
                                                text: matchTeamsText,
                                                softWrap: true,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    VisaTextStyle.customLarge,
                                                fontFamily:
                                                    VisaFontWeight.regular,
                                                fontSize: fontfourteen,
                                                customColor: VisaColors.black,
                                                colorTheme: VisaTextTheme
                                                    .customTextColor,
                                                letterSpacing: -0.5,
                                              ));
                                        }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        FirebaseAnalyticsService.logEvent(
                            eventName: "companionDetails_editbutton",
                            parameters: {
                              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                                  "editbutton"
                            });

                        final rep = await AppRouter.router.push(
                            AppRoutes.addCompanion,
                            extra: companionProfile);
                        if (rep == true) {
                          onChange();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(start: Sizes.eight),
                        child: VisaSvgIcon(
                            assetPath: Assets.iconsEditProfile,
                            width: AppSizes.dimMedium,
                            height: AppSizes.heightTweentyFour),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          VisaSizeBox(
            height: 9.h,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Semantics(
              enabled: true,
              link: true,
              container: true,
              label: S.of(context).resend_companion_invite,
              child: InkWell(
                onTap: () {
                  onChangeResend();
                },
                child: VisaTextView(
                  semantics: false,
                  text: S.of(context).resend_companion_invite,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: VisaTextStyle.link,
                  fontFamily: VisaFontWeight.semibold,
                  fontSize: fontfourteen,
                  customColor: VisaColors.primary,
                  colorTheme: VisaTextTheme.customTextColor,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
