// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_image.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/date_util.dart';
import 'package:visaamigo/utils/file_name_cleaner_extention.dart';

import '../../../../../analytics/firebase_analytics_service.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_auto_size_text.dart';
import '../../../../../custom_widgets/visa_show_case_widget.dart';
import '../../../../../custom_widgets/visa_svg_icon.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../router/app_routes_const.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../../../utils/test_style_util.dart';
import '../../../../select_languages/providers/language_selection_generic_provider.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/navigation_provider.dart';
import '../../../providers/tutorial_provider.dart';

class HomeScreenTicketCardWidget extends StatelessWidget {
  final HomeViewProvider homeViewProvider;

  HomeScreenTicketCardWidget({super.key, required this.homeViewProvider});

  late double tweentyRadius;
  late double twentywidth;
  late double tweentyHeight;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);
    final bool isRTL =
        Provider.of<SelectLanguageGenericProvider>(context).isRTL;
    tweentyRadius = AppSizes.twentyRadius;
    twentywidth = AppSizes.tweentyWidth;
    tweentyHeight = AppSizes.tweentyHeight;
    return GestureDetector(
        onTap: () {
          goToMatchDetail(context);
        },
        child: Container(
          margin: EdgeInsets.only(
            top: AppSizes.heightSmall,
            bottom: AppSizes.heightSmall,
          ),
          decoration: ShapeDecoration(
            color: VisaColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tweentyRadius),
            ),
          ),
          width: context.screenWidth,
          child: Semantics(
            button: true,
            enabled: true,
            excludeSemantics: true,
            label: homeViewProvider.closestMatch != null
                ? "${s.ticket_details}  ${homeViewProvider.closestMatch!.eventName} "
                    "${homeViewProvider.closestMatch!.matchTeams} "
                    "${s.on} ${DateUtil.formatFull(context, homeViewProvider.closestMatch!.matchTime)} "
                    "${s.in_key} ${homeViewProvider.closestMatch!.matchCity}"
                : "${s.ticket_details}, ${s.no_tickets_semantics}",
            child: Container(
              key: tutorialProvider.tutorialTicketKey,
              padding: EdgeInsets.symmetric(
                horizontal: twentywidth,
              ),
              child: VisaShowcase(
                keyValue: tutorialProvider.tutorialTicketKeySC,
                borderRadius: BorderRadius.circular(tweentyRadius),
                isComeFromHome: true,
                targetPadding: EdgeInsets.symmetric(
                  horizontal: twentywidth,
                ),
                child: Column(
                  // Column instead of Row
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: tweentyHeight,
                              bottom: tweentyHeight,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                VisaImageIcon(
                                  semantics: false,
                                  assetPath: Assets.imagesVisaPartnershipLogo,
                                  height: AppSizes.thirtyNineHeight,
                                  width: AppSizes.oneHundredFourWidth,
                                  color: VisaColors.white,
                                ),
                                SizedBox(
                                  height: AppSizes.heightFive,
                                ),
                                VisaTextView(
                                  semantics: false,
                                  text: s.worldwide_partner,
                                  style: VisaTextStyle.displayBodyXs,
                                  fontSize: Sizes.twelveInt.toDouble(),
                                  letterSpacing: 0,
                                  lineHeight: 0.83,
                                  fontFamily: VisaFontWeight.medium,
                                  colorTheme: VisaTextTheme.customTextColor,
                                  customColor: VisaColors.white,
                                ),
                                SizedBox(height: AppSizes.heightFiftyFour),
                                VisaTextView(
                                  semantics: false,
                                  text: homeViewProvider.closestMatch !=
                                          null // ==
                                      ? DateUtil.formatFull(
                                              context,
                                              homeViewProvider
                                                  .closestMatch!.matchTime)
                                          .toUpperCase()
                                      : "",
                                  style: VisaTextStyle.displayBodyXs,
                                  fontSize: AppSizes.fontTwelve,
                                  letterSpacing: 2,
                                  lineHeight: 1.40,
                                  fontFamily: VisaFontWeight.medium,
                                  colorTheme: VisaTextTheme.customTextColor,
                                  customColor: VisaColors.white,
                                ),
                                SizedBox(height: AppSizes.heightFour),
                                AutoSizeText(
                                  homeViewProvider.isLoading || //or
                                          homeViewProvider.closestMatch != null
                                      ? s.ticket_details
                                      : "",
                                  maxLines: 1,
                                  minFontSize: 10.sp.roundToDouble(),
                                  overflow: TextOverflow.ellipsis,
                                  stepGranularity: 1,
                                  // Allows decimal stepping
                                  style: VisaTextUtils.getVisaTextStyle(
                                    VisaTextStyle.displayTitleSmall,
                                    context: context,
                                    isDarkMode: false,
                                    letterSpacing: -0.20,
                                    lineHeight: 1.05,
                                    fontFamily: VisaFontWeight.bold,
                                    // colorTheme: VisaTextTheme.customTextColor,
                                    fontColor: VisaColors.white,
                                  ),
                                ),
                                SizedBox(height: AppSizes.elevenHeight),
                                homeViewProvider.isLoading || // or
                                        homeViewProvider.closestMatch != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          VisaTextView(
                                            semantics: false,
                                            text: homeViewProvider
                                                        .closestMatch !=
                                                    null
                                                ? ("${homeViewProvider.closestMatch!.eventName} ${homeViewProvider.closestMatch!.matchTeams}")
                                                : "",
                                            style: VisaTextStyle.displayBodyXs,
                                            fontSize:
                                                Sizes.twelveInt.toDouble(),
                                            letterSpacing: 0.0,
                                            lineHeight: 0.83,
                                            maxLines: 2,
                                            overflow: TextOverflow.visible,
                                            fontFamily: VisaFontWeight.medium,
                                            colorTheme:
                                                VisaTextTheme.customTextColor,
                                            customColor:
                                                VisaColors.textFieldBorder,
                                          ),
                                          VisaAutoSizeText(
                                            text: homeViewProvider
                                                        .closestMatch !=
                                                    null
                                                ? homeViewProvider.toTitleCase(
                                                    "${homeViewProvider.closestMatch!.matchCity}, ${homeViewProvider.closestMatch!.matchState}, ${homeViewProvider.closestMatch!.matchCountry}")
                                                : "",
                                            style: VisaTextStyle.displayBodyXs,
                                            fontSize:
                                                Sizes.twelveInt.toDouble(),
                                            letterSpacing: 0.0,
                                            lineHeight: 0.83,
                                            maxLines: 3,
                                            maxFontSize:
                                                Sizes.twelveInt.toDouble(),
                                            minFontSize:
                                                Sizes.fiveInt.toDouble(),
                                            overflow: TextOverflow.visible,
                                            fontFamily: VisaFontWeight.medium,
                                            colorTheme:
                                                VisaTextTheme.customTextColor,
                                            customColor:
                                                VisaColors.textFieldBorder,
                                          ),
                                        ],
                                      )
                                    : AutoSizeText(
                                        s.ticket_details,
                                        maxLines: 1,
                                        minFontSize: 10.sp.roundToDouble(),
                                        overflow: TextOverflow.ellipsis,
                                        stepGranularity: 1,
                                        // Allows decimal stepping
                                        style: VisaTextUtils.getVisaTextStyle(
                                          VisaTextStyle.displayTitleSmall,
                                          context: context,
                                          isDarkMode: false,
                                          letterSpacing: -0.20,
                                          lineHeight: 1.05,
                                          fontFamily: VisaFontWeight.bold,
                                          // colorTheme: VisaTextTheme.customTextColor,
                                          fontColor: VisaColors.white,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: ExcludeSemantics(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: AppSizes.zero.w,
                                    // bottom: AppSizes.tweentyHeight,
                                  ),
                                  child: const VisaImageIcon(
                                    assetPath: Assets.imagesTrophyWc,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                VisaSvgIcon(
                                  semanticsLabel: Assets
                                      .iconsIcArrowBlackCircle.cleanedFileName,
                                  assetPath: Assets.iconsIcArrowBlackCircle,
                                  width: AppSizes.tweentyFourWidth,
                                  height: AppSizes.heightTweentyFour,
                                  useWithoutColor: true,
                                  padding: EdgeInsets.only(
                                    left: isRTL ? 0 : twentywidth,
                                    bottom: tweentyHeight,
                                  ),
                                  onTap: () {
                                    goToMatchDetail(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void goToMatchDetail(BuildContext context) {
    FirebaseAnalyticsService.logEvent(
      eventName: " ticketdetails_opened",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "ticket_details",
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: AppRoutes.homeNav,
      },
    );

    FirebaseAnalyticsService.logEvent(
      eventName: " ticketdetails_screenview",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: AppRoutes.homeNav,
      },
    );
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);

    // Navigate to the Ticket Details screen
    navigationProvider.goBranch(AppRoutes.ticketScreenIndex,
        scolltoPosition: true);
    // navigationProvider.tabScrollControllers[AppRoutes.ticketScreenIndex]
  }
}
