import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/theme_extension.dart';
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
class HomeScreenAddCompanionWidget extends StatelessWidget {
  final HomeViewProvider homeViewProvider;
  final Function? onTap;

   HomeScreenAddCompanionWidget(
      {super.key, required this.homeViewProvider, this.onTap});
  late double paddingVertical;
  late double tweentyHeight;

  @override
  Widget build(BuildContext context) {
     paddingVertical = AppSizes.dimSmall;
    tweentyHeight =AppSizes.tweentyHeight;
    final s = S.of(context);
    final tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        key: tutorialProvider.tutorialCompanionKey,
        width: context.screenWidth,
        padding: EdgeInsets.only(
          left: paddingVertical,
          right: paddingVertical,
          top: tweentyHeight,
          bottom: tweentyHeight,
        ),
        decoration: BoxDecoration(
          color: VisaColors.blueBackgroundLightNew,
          // Light blue background color
          borderRadius: BorderRadius.circular(Sizes.sixteen),
        ),
        child: VisaShowcase(
          keyValue: tutorialProvider.tutorialCompanionKeySC,
          borderRadius: BorderRadius.circular(Sizes.sixteen),
          isComeFromHome: true,
          targetPadding: EdgeInsets.only(
            left: paddingVertical,
            right: paddingVertical,
            top: tweentyHeight,
            bottom: tweentyHeight,
          ),
          child: Row(
            spacing: Sizes.sixteen,
            children: [
              // Star icon
              VisaSvgIcon(
                height: AppSizes.heightMedium,
                width: AppSizes.twentySix,
                assetPath: Assets.iconsIcCompanion,
                color: context.theme.primaryColor,
              ),
              // Text content with arrow using RichText
              Expanded(
                child: VisaRichText(
                  maxLines: 3,
                  textSpans: [
                    VisaTextSpan(
                      text: homeViewProvider.isCompanion == true
                          ? s.companion_details
                          : s.add_companion,
                      style: VisaTextStyle.displayBodyXl,
                      fontSize: AppSizes.fontMedium,
                      letterSpacing: -0.51,
                      lineHeight: 1.11,
                      fontFamily: VisaFontWeight.semibold,
                      colorTheme: VisaTextTheme.customTextColor,
                      customColor: VisaColors.black,
                      iconHeight: AppSizes.ten,
                      iconWidth: AppSizes.iconXXSmall,
                      iconPath: Assets.iconsIcRichTextRightArrow,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
