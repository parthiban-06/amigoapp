import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/profile/model/profile_model.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

class ProfileCompanionDetails extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileCompanionDetails({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSizes.tweentyHeight),
      child: InkWell(
        onTap: () {
          viewModel.getCompanionScreen();
        },
        child: Semantics(
          label: Provider.of<UserGenericProvider>(context, listen: true)
                  .listCompanion
              ? S.of(context).companion_details
              : S.of(context).add_companion,
          container: true,
          button: true,
          excludeSemantics: true,
          onTap: () {
            viewModel.getCompanionScreen();
          },
          child: Container(
            height: AppSizes.heightSixtyFour,
            width: context.screenWidth.w,
            decoration: BoxDecoration(
                color: VisaColors.blueBackgroundLight2,
                borderRadius: BorderRadius.circular(16).r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.tweentyWidth),
              child: Row(
                children: [
                  SvgPicture.asset(Assets.iconsCompanion,
                      width: AppSizes.dimMedium),
                  VisaSizeBox(
                    width: AppSizes.dimSmall,
                  ),
                  Flexible(
                    child: VisaTextView(
                      text: Provider.of<UserGenericProvider>(context,
                                  listen: true)
                              .listCompanion
                          ? S.of(context).companion_details
                          : S.of(context).add_companion,
                      softWrap: true,
                      semantics: false,
                      overflow: TextOverflow.visible,
                      style: VisaTextStyle.customLarge,
                      fontFamily: VisaFontWeight.semibold,
                      fontSize: AppSizes.fontMedium,
                      customColor: VisaColors.black,
                      colorTheme: VisaTextTheme.customTextColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  VisaSizeBox(
                    width: AppSizes.eightWidth,
                  ),
                  VisaSvgIcon(
                    assetPath: Assets.iconsIcLeftArrow,
                    color: VisaColors.black,
                    width: AppSizes.tweleveWidth,
                    semantics: false,
                    height: AppSizes.tweleveHeight,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
