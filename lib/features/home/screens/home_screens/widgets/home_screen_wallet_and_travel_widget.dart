import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_popup_travel_credit.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/theme_extension.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../../analytics/firebase_analytics_service.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_rich_text.dart';
import '../../../../../custom_widgets/visa_show_case_widget.dart';
import '../../../../../custom_widgets/visa_svg_icon.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/tutorial_provider.dart';

// ignore: must_be_immutable
class HomeScreenWalletAndTravelWidget extends StatelessWidget {
  final HomeViewProvider homeViewProvider;

  HomeScreenWalletAndTravelWidget({super.key, required this.homeViewProvider});

  late double fontTen;
  late double fontMedium;
  late double paddingVertical;
  late double paddingHorizontal;
  late double heightMedium;
  late double sixteenRadius;
  late double heightHundrad;
  late double heightOneHundredFortyEight;
  late double iconXXSmall;

  @override
  Widget build(BuildContext context) {
    fontTen = Utils.getFontSize(context) ? AppSizes.sixHeight : AppSizes.ten;
    fontMedium = AppSizes.fontMedium;
    paddingVertical = AppSizes.dimSmall;
    paddingHorizontal = AppSizes.tweentyHeight;
    heightMedium = AppSizes.heightMedium;
    sixteenRadius = AppSizes.sixteenRadius;
    heightHundrad = AppSizes.heightHundrad;
    heightOneHundredFortyEight = AppSizes.heightOneHundredFortyEight;
    iconXXSmall =
        Utils.getFontSize(context) ? AppSizes.sixHeight : AppSizes.iconXXSmall;
    final s = S.of(context);

    final tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);

    bool showWallet = !(homeViewProvider.isLoading == false &&
        (homeViewProvider.walletResponse == null));

    bool showCompanion = !(homeViewProvider.isLoading == false &&
        homeViewProvider.matchResponse != null &&
        homeViewProvider.matchResponse!.data.isEmpty);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Aligns boxes at the top
          children: [
            showWallet == false
                ? showCompanion == true
                    ? blockCompanion(
                        context: context,
                        s: s,
                        tutorialProvider: tutorialProvider,
                      )
                    : const SizedBox()
                : Expanded(
                    flex: 1,
                    child: Semantics(
                      label: s
                          .access_wallet, // For screen reader: "Book your travel"
                      button: true,
                      child: InkWell(
                        onTap: () {
                          FirebaseAnalyticsService.logEvent(
                            eventName:
                                AnalyticsEventConst.EVENT_NAME_WALLET_CLICKED,
                            parameters: {
                              AnalyticsEventConst
                                      .PARAM_NAME_UI_ELEMENT_LOCATION:
                                  AppRoutes.homeNav,
                              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                                  "access_wallet",
                            },
                          );
                          FirebaseAnalyticsService.genericUiElement =
                              AppRoutes.homeNav;
                          AppRouter.router
                              .pushRoute(AppRoutes.homeNestedWallet);
                        },
                        child: Container(
                          height: Utils.getFontSize(context)
                              ? Sizes.oneHundredEightyInt.toDouble()
                              : Sizes.oneHundredFortyEight.toDouble().h,
                          key: tutorialProvider.tutorialWalletKey,
                          width: context.screenWidth,
                          padding: EdgeInsets.symmetric(
                              vertical: paddingVertical,
                              horizontal: paddingHorizontal),
                          decoration: BoxDecoration(
                            color: VisaColors.blueBackgroundLightNew,
                            borderRadius: BorderRadius.circular(sixteenRadius),
                          ),
                          child: VisaShowcase(
                            keyValue: tutorialProvider.tutorialWalletKeySC,
                            borderRadius: BorderRadius.circular(sixteenRadius),
                            isComeFromHome: true,
                            targetPadding: EdgeInsets.symmetric(
                              vertical: paddingVertical,
                              horizontal: paddingHorizontal,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Prevents stretching
                              children: [
                                /// Wallet Icon
                                VisaSvgIcon(
                                  semantics: false,
                                  height: heightMedium,
                                  width: heightMedium,
                                  assetPath: Assets.iconsIcEvaWallet,
                                  color: context.theme.primaryColor,
                                ),
                                SizedBox(height: paddingHorizontal),

                                /// Wallet Text
                                Flexible(
                                  child: VisaRichText(
                                    semantics: false,
                                    maxLines: 3,
                                    textSpans: [
                                      VisaTextSpan(
                                        text: s.access_wallet,
                                        style: VisaTextStyle.displayBodyXl,
                                        fontSize: fontMedium,
                                        letterSpacing: -0.51,
                                        lineHeight: 1.11,
                                        fontFamily: VisaFontWeight.semibold,
                                        colorTheme:
                                            VisaTextTheme.customTextColor,
                                        customColor: VisaColors.black,
                                        iconHeight: fontTen,
                                        iconWidth: iconXXSmall,
                                        iconPath:
                                            Assets.iconsIcRichTextRightArrow,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

            AppSizes.smallHS,

            /// **Travel Section**
            showWallet == false && showCompanion == false
                ? rowBookTravel(
                    context: context,
                    s: s,
                    showCompanion: showCompanion,
                    tutorialProvider: tutorialProvider,
                  )
                : Expanded(
                    flex: 1,
                    child: Semantics(
                      label: s
                          .book_travel, // For screen reader: "Book your travel"
                      button: true,
                      child: InkWell(
                        onTap: () async {
                          Utils.walletPopupTravelCredit(
                              context: context,
                              child: WalletPopupTravelScreen(
                                list: homeViewProvider.voucherList,
                                isBookTravel:
                                    false, // redirect to booking.com coupon page
                              ));
                        },
                        child: Container(
                          height: Utils.getFontSize(context)
                              ? Sizes.oneHundredEightyInt.toDouble()
                              : Sizes.oneHundredFortyEight.toDouble().h,
                          key: tutorialProvider.tutorialBookTravelKey,
                          width: context.screenWidth,
                          padding: EdgeInsets.symmetric(
                            vertical: paddingVertical,
                            horizontal: paddingHorizontal,
                          ),
                          decoration: BoxDecoration(
                            color: VisaColors.blueBackgroundLightNew,
                            borderRadius: BorderRadius.circular(sixteenRadius),
                          ),
                          child: VisaShowcase(
                            keyValue: tutorialProvider.tutorialBookTravelKeySC,
                            tooltipBackgroundColor: VisaColors.transparent,
                            borderRadius: BorderRadius.circular(sixteenRadius),
                            isComeFromHome: true,
                            targetPadding: EdgeInsets.symmetric(
                              vertical: paddingVertical,
                              horizontal: paddingHorizontal,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Prevents stretching
                              children: [
                                /// Travel Icon
                                VisaSvgIcon(
                                  semantics: false,
                                  height: heightMedium,
                                  width: AppSizes.twentySix,
                                  assetPath: Assets.iconsIcTravel,
                                  color: context.theme.primaryColor,
                                ),
                                SizedBox(height: paddingHorizontal),

                                /// Travel Text
                                VisaRichText(
                                  semantics: false,
                                  maxLines: 3,
                                  textSpans: [
                                    VisaTextSpan(
                                      text: s.book_travel,
                                      style: VisaTextStyle.displayBodyXl,
                                      fontSize: fontMedium,
                                      letterSpacing: -0.51,
                                      lineHeight: 1.11,
                                      fontFamily: VisaFontWeight.semibold,
                                      colorTheme: VisaTextTheme.customTextColor,
                                      customColor: VisaColors.black,
                                      iconHeight: fontTen,
                                      iconWidth: iconXXSmall,
                                      iconPath:
                                          Assets.iconsIcRichTextRightArrow,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        AppSizes.smallVS,
        rowCompanion(
          context: context,
          s: s,
          showCompanion: showCompanion && showWallet == true,
          tutorialProvider: tutorialProvider,
        ),
      ],
    );
  }

  rowCompanion({
    required BuildContext context,
    required dynamic s,
    required bool showCompanion,
    required TutorialProvider tutorialProvider,
  }) {
    return showCompanion == false
        ? const SizedBox()
        : Semantics(
            label: Provider.of<UserGenericProvider>(context, listen: true)
                        .listCompanion ==
                    true
                ? s.companion_details
                : s.add_companion, // For screen reader: "Book your travel"
            button: true,
            child: InkWell(
              onTap: () {
                homeViewProvider.getCompanionScreen();
              },
              child: Container(
                key: tutorialProvider.tutorialCompanionKey,
                width: context.screenWidth,
                padding: EdgeInsets.only(
                  left: paddingVertical,
                  right: paddingVertical,
                  top: paddingHorizontal,
                  bottom: paddingHorizontal,
                ),
                decoration: BoxDecoration(
                  color: VisaColors.blueBackgroundLightNew,
                  // Light blue background color
                  borderRadius: BorderRadius.circular(sixteenRadius),
                ),
                child: VisaShowcase(
                  keyValue: tutorialProvider.tutorialCompanionKeySC,
                  borderRadius: BorderRadius.circular(sixteenRadius),
                  isComeFromHome: true,
                  targetPadding: EdgeInsets.only(
                    left: paddingVertical,
                    right: paddingVertical,
                    top: paddingHorizontal,
                    bottom: paddingHorizontal,
                  ),
                  child: Row(
                    spacing: sixteenRadius,
                    children: [
                      // Star icon
                      VisaSvgIcon(
                        semantics: false,
                        height: heightMedium,
                        width: AppSizes.twentySix,
                        assetPath: Assets.iconsIcCompanion,
                        color: context.theme.primaryColor,
                      ),
                      // Text content with arrow using RichText
                      Expanded(
                        child: VisaRichText(
                          semantics: false,
                          maxLines: 3,
                          textSpans: [
                            VisaTextSpan(
                              text: Provider.of<UserGenericProvider>(context,
                                              listen: true)
                                          .listCompanion ==
                                      true
                                  ? s.companion_details
                                  : s.add_companion,
                              style: VisaTextStyle.displayBodyXl,
                              fontSize: fontMedium,
                              letterSpacing: -0.51,
                              lineHeight: 1.11,
                              fontFamily: VisaFontWeight.semibold,
                              colorTheme: VisaTextTheme.customTextColor,
                              customColor: VisaColors.black,
                              iconHeight: fontTen,
                              iconWidth: iconXXSmall,
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

  rowBookTravel({
    required BuildContext context,
    required dynamic s,
    required bool showCompanion,
    required TutorialProvider tutorialProvider,
  }) {
    Utils.logPrint('rowBookTravel$showCompanion');
    return showCompanion == false
        ? const SizedBox()
        : Semantics(
            label: s.book_travel2, // For screen reader: "Book your travel"
            button: true,
            child: InkWell(
              onTap: () {
                Utils.walletPopupTravelCredit(
                    context: context,
                    child: WalletPopupTravelScreen(
                      list: homeViewProvider.voucherList,
                      isBookTravel: true,
                    ));
              },
              child: Container(
                key: tutorialProvider.tutorialBookTravelKey,
                width: context.screenWidth,
                padding: EdgeInsets.only(
                  left: paddingVertical,
                  right: paddingVertical,
                  top: AppSizes.tweentyHeight,
                  bottom: AppSizes.tweentyHeight,
                ),
                decoration: BoxDecoration(
                  color: VisaColors.blueBackgroundLightNew,
                  // Light blue background color
                  borderRadius: BorderRadius.circular(sixteenRadius),
                ),
                child: VisaShowcase(
                  keyValue: tutorialProvider.tutorialBookTravelKeySC,
                  tooltipBackgroundColor: VisaColors.transparent,
                  borderRadius: BorderRadius.circular(sixteenRadius),
                  isComeFromHome: true,
                  targetPadding: EdgeInsets.only(
                    left: paddingVertical,
                    right: paddingVertical,
                    top: AppSizes.tweentyHeight,
                    bottom: AppSizes.tweentyHeight,
                  ),
                  child: Row(
                    spacing: sixteenRadius,
                    children: [
                      // Star icon
                      VisaSvgIcon(
                        semantics: false,
                        height: heightMedium,
                        width: AppSizes.twentySix,
                        assetPath: Assets.iconsIcTravel,
                        color: context.theme.primaryColor,
                      ),
                      // Text content with arrow using RichText
                      Expanded(
                        child: VisaRichText(
                          semantics: false,
                          maxLines: 3,
                          textSpans: [
                            VisaTextSpan(
                                text: s.book_travel2,
                                style: VisaTextStyle.displayBodyXl,
                                fontSize: fontMedium,
                                letterSpacing: -0.51,
                                lineHeight: 1.11,
                                fontFamily: VisaFontWeight.semibold,
                                colorTheme: VisaTextTheme.customTextColor,
                                customColor: VisaColors.black,
                                iconHeight: fontTen,
                                iconWidth: iconXXSmall,
                                iconPath: Assets.iconsIcRichTextRightArrow),
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

  blockCompanion({
    required BuildContext context,
    required dynamic s,
    required TutorialProvider tutorialProvider,
  }) {
    return Expanded(
      flex: 1,
      child: Semantics(
        label: Provider.of<UserGenericProvider>(context, listen: true)
                    .listCompanion ==
                true
            ? s.companion_details
            : s.add_companion, // For screen reader: "Book your travel"
        button: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: heightHundrad, // Fixed Minimum Height
            maxHeight: heightOneHundredFortyEight, // Allows Expansion
          ),
          child: InkWell(
            onTap: () {
              homeViewProvider.getCompanionScreen();
            },
            child: Container(
              key: tutorialProvider.tutorialCompanionKey,
              width: context.screenWidth,
              padding: EdgeInsets.symmetric(
                  vertical: paddingVertical, horizontal: paddingHorizontal),
              decoration: BoxDecoration(
                color: VisaColors.blueBackgroundLightNew,
                borderRadius: BorderRadius.circular(sixteenRadius),
              ),
              child: VisaShowcase(
                keyValue: tutorialProvider.tutorialCompanionKeySC,
                borderRadius: BorderRadius.circular(sixteenRadius),
                isComeFromHome: true,
                targetPadding: EdgeInsets.symmetric(
                  vertical: paddingVertical,
                  horizontal: paddingHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Prevents stretching
                  children: [
                    /// Wallet Icon
                    VisaSvgIcon(
                      semantics: false,
                      height: heightMedium,
                      width: heightMedium,
                      assetPath: Assets.iconsIcCompanion,
                      color: context.theme.primaryColor,
                    ),
                    SizedBox(height: paddingHorizontal),

                    /// Wallet Text
                    VisaRichText(
                      semantics: false,
                      maxLines: 3,
                      textSpans: [
                        VisaTextSpan(
                          text: Provider.of<UserGenericProvider>(context,
                                          listen: true)
                                      .listCompanion ==
                                  true
                              ? s.companion_details
                              : s.add_companion,
                          style: VisaTextStyle.displayBodyXl,
                          fontSize: fontMedium,
                          letterSpacing: -0.51,
                          lineHeight: 1.11,
                          fontFamily: VisaFontWeight.semibold,
                          colorTheme: VisaTextTheme.customTextColor,
                          customColor: VisaColors.black,
                          iconHeight: fontTen,
                          iconWidth: iconXXSmall,
                          iconPath: Assets.iconsIcRichTextRightArrow,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
