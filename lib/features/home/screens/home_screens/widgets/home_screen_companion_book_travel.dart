import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_popup_travel_credit.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/theme_extension.dart';
import 'package:visaamigo/utils/utils.dart';

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

class HomeScreenCompanionBookTravel extends StatelessWidget {
  final HomeViewProvider homeViewProvider;

  HomeScreenCompanionBookTravel({super.key, required this.homeViewProvider});

  late double paddingVertical;
  late double paddingHorizontal;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);
    paddingVertical = AppSizes.dimSmall;
    paddingHorizontal = AppSizes.tweentyHeight;

    return Semantics(
      label: s.book_travel2, // For screen reader: "Book your travel"
      button: true,
      child: InkWell(
        onTap: () {
          Utils.walletPopupTravelCredit(
              context: context,
              child: WalletPopupTravelScreen(
                list: homeViewProvider.voucherList,
              ));
          // homeViewProvider.getCompanionScreen();
        },
        child: Container(
          key: tutorialProvider.tutorialBookTravelKey,
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
            borderRadius: BorderRadius.circular(Sizes.sixteen),
          ),
          child: VisaShowcase(
            keyValue: tutorialProvider.tutorialBookTravelKeySC,
            tooltipBackgroundColor: VisaColors.transparent,
            borderRadius: BorderRadius.circular(Sizes.sixteen),
            isComeFromHome: true,
            targetPadding: EdgeInsets.only(
              left: paddingVertical,
              right: paddingVertical,
              top: paddingHorizontal,
              bottom: paddingHorizontal,
            ),
            child: Row(
              spacing: Sizes.sixteen,
              children: [
                // Star icon
                VisaSvgIcon(
                  semantics: false,
                  height: AppSizes.heightMedium,
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
                          fontSize: AppSizes.fontMedium,
                          letterSpacing: -0.51,
                          lineHeight: 1.11,
                          fontFamily: VisaFontWeight.semibold,
                          colorTheme: VisaTextTheme.customTextColor,
                          customColor: VisaColors.black,
                          iconHeight: Utils.getFontSize(context)
                              ? AppSizes.sixHeight
                              : AppSizes.ten,
                          iconWidth: Utils.getFontSize(context)
                              ? AppSizes.sixHeight
                              : AppSizes.iconXXSmall,
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
}
