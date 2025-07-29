import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/profile/widgets/profile_tiles.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart' show AppRoutes;
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../home/providers/navigation_provider.dart';
import '../model/profile_model.dart';

class ProfileHelp extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileHelp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final navigationBar =
        Provider.of<NavigationProvider>(context, listen: false);

    final userGenericProvider =
        Provider.of<UserGenericProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(top: AppSizes.heightTweentyFour),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VisaTextView(
            text: S.of(context).help.toUpperCase(),
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontFamily: VisaFontWeight.medium,
            fontSize: AppSizes.fontTwelve,
            customColor: VisaColors.textFieldBorder,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: 2,
          ),
          const Divider(
            color: VisaColors.greyBackGround,
          ),
          ProfileTiles(
              onTap: () async {
                viewModel.navFaq();
              },
              semanticTitle: S.of(context).frequently_asked_questions,
              title: S.of(context).faqs),
          ProfileTiles(
              onTap: () {
                viewModel.ticketSupportRedirect();
              },
              title: S.of(context).ticket_support),
          ProfileTiles(
              onTap: () async {
                viewModel.bookingSupportRedirect();
              },
              title: S.of(context).booking_support),
          ((userGenericProvider.isCompanion) ?? false)
              ? const SizedBox.shrink()
              : ProfileTiles(
                  onTap: () {
                    viewModel.prepaidSupportRedirect();
                  },
                  title: S.of(context).prepaid_card_support),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.heightTwo),
            child: const Divider(
              color: VisaColors.greyBackGround,
            ),
          ),
          ProfileTiles(
            title: S.of(context).revisit_visa_go,
            onTap: () {
              viewModel.reWatchIntro(navigationBar);
            },
          ),
          ProfileTiles(
            title: S.of(context).rewatch_tutorial,
            onTap: () {
              viewModel.reWatchTutorial(navigationBar);
            },
          ),
          ProfileTiles(
            title: S.of(context).privacy_notice,
            onTap: () {
              viewModel.goToPrivacyPolicy();
            },
          ),
          ProfileTiles(title: S.of(context).access_my_personal_data),
          ProfileTiles(
            title: S.of(context).termConditions,
            onTap: () {
              viewModel.goToTermAndCondition();
            },
          ),
          ((userGenericProvider.isCompanion) ?? false)
              ? const SizedBox.shrink()
              : ProfileTiles(
                  title: S.of(context).rate_us,
                  onTap: () {
                    AppRouter.router.push(AppRoutes.rateUs);
                  },
                ),
        ],
      ),
    );
  }
}
