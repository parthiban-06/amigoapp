import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/theme_extension.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_rich_text.dart';
import '../../../../../custom_widgets/visa_show_case_widget.dart';
import '../../../../../custom_widgets/visa_size_box.dart';
import '../../../../../custom_widgets/visa_svg_icon.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../router/app_routes_const.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/navigation_provider.dart';
import '../../../providers/tutorial_provider.dart';

class HomeScreenEvaTravelWidget extends StatelessWidget {
  final HomeViewProvider homeViewProvider;

  const HomeScreenEvaTravelWidget({
    super.key,
    required this.homeViewProvider,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final navigationProvider = context.read<NavigationProvider>();
    final tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);
    return Semantics(
      label: s.ask_eva_travel, // For screen reader: "Book your travel"
      button: true,
      child: Container(
        key: tutorialProvider.tutorialEvaTravelKey,
        width: context.screenWidth,
        padding: EdgeInsets.only(
          left: AppSizes.dimSmall,
          right: AppSizes.dimSmall,
          top: Sizes.twenty,
          bottom: Sizes.twenty,
        ),
        decoration: BoxDecoration(
          color: VisaColors.blueBackgroundLightNew,
          // Light blue background color
          borderRadius: BorderRadius.circular(16),
        ),
        child: VisaShowcase(
          keyValue: tutorialProvider.tutorialEvaTravelKeySC,
          borderRadius: BorderRadius.circular(16),
          isComeFromHome: true,
          targetPadding: EdgeInsets.only(
            left: AppSizes.dimSmall,
            right: AppSizes.dimSmall,
            top: Sizes.twenty,
            bottom: Sizes.twenty,
          ),
          child: GestureDetector(
            onTap: () {
              FirebaseAnalyticsService.logEvent(
                eventName: AnalyticsEventConst.EVENT_NAME_EVAASSISTANT_OPENED,
                parameters: {
                  AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
                  AppRoutes.homeNav,
                  AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: AppRoutes.evaNav,
                },
              );
              FirebaseAnalyticsService.logEvent(
                eventName: AnalyticsEventConst.EVENT_NAME_EVAASSISTANT_SCREENVIEWED,
              );
              navigationProvider.goBranch(AppRoutes.evaScreenIndex);

            },
            child: Row(
              children: [
                // Star icon
                VisaSvgIcon(
                  semantics: false,
                  height: AppSizes.heightMedium,
                  width: AppSizes.twentySix,
                  assetPath: Assets.iconsEva,
                  color: context.theme.primaryColor,
                ),
                VisaSizeBox(
                  width: Sizes.twelveInt.w,
                ),

                // Text content with arrow using RichText
                Expanded(
                  child: VisaRichText(
                    semantics: false,
                    maxLines: 3,
                    textSpans: [
                      VisaTextSpan(
                          text: s.ask_eva_travel,
                          style: VisaTextStyle.displayBodyXl,
                          fontSize: AppSizes.fontMedium,
                          letterSpacing: -0.5,
                          lineHeight: AppSizes.twentyRadius,
                          fontFamily: VisaFontWeight.semibold,
                          colorTheme: VisaTextTheme.customTextColor,
                          customColor: VisaColors.black,
                          iconHeight:
                              MediaQuery.of(context).textScaler.scale(1) > 1.3
                                  ? AppSizes.sixHeight
                                  : AppSizes.ten,
                          iconWidth:
                              MediaQuery.of(context).textScaler.scale(1) > 1.3
                                  ? AppSizes.sixHeight
                                  : AppSizes.iconXXSmall,
                          iconPath: Assets.iconsIcRichTextRightArrow),
                    ],
                  ),
                ),

                VisaSizeBox(
                  width: AppSizes.heightSmall,
                  height: AppSizes.heightSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
