import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../analytics/firebase_analytics_service.dart';
import '../../select_languages/providers/language_selection_generic_provider.dart';

class ProfileTiles extends StatelessWidget {
  final String title;
  final String? semanticTitle;
  final Function? onTap;

  const ProfileTiles({super.key, required this.title, this.onTap, this.semanticTitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final localLanguageProvider =
            Provider.of<SelectLanguageGenericProvider>(context, listen: false);

        FirebaseAnalyticsService.logEventButtonClick(
            btnName: localLanguageProvider.getKeyFromValue(semanticTitle ?? title));

        if (onTap != null) {
          onTap!();
        }
      },
      child: Semantics(
        label: semanticTitle ?? title,
        container: true,
        button: true,
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: ExcludeSemantics(
          excluding: true,
          child: SizedBox(
            height: AppSizes.heightFourtyFive,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: VisaTextView(
                    text: title,
                    softWrap: true,
                    semantics: false,
                    overflow: TextOverflow.visible,
                    style: VisaTextStyle.customLarge,
                    fontFamily: VisaFontWeight.medium,
                    fontSize: AppSizes.fontMedium,
                    customColor: VisaColors.black,
                    colorTheme: VisaTextTheme.customTextColor,
                    letterSpacing: -0.5,
                  ),
                ),
                VisaSvgIcon(
                  assetPath: Assets.iconsProfileArrow,
                  color: VisaColors.black,
                  width: AppSizes.dimMedium,
                  semantics: false,
                  height: AppSizes.heightTweentyFour,
                ),
                VisaSizeBox(width: AppSizes.fiveWidth)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
