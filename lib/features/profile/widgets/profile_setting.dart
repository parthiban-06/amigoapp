import 'package:flutter/material.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/profile/widgets/profile_switch_tile.dart';
import 'package:visaamigo/features/profile/widgets/profile_tiles.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

class ProfileSetting extends StatelessWidget {
  final bool mfa;
  final GlobalKey notificationSectionGlobalKey;
  final bool biometric;
  final bool showBiometrics;
  final bool notificationPermission;
  final bool dateTime24Hrs;
  final bool analyticsConsent;
  final ValueChanged<bool> onChangeMFA;
  final ValueChanged<bool> onChange24Hrs;
  final ValueChanged<bool> onChangeNotificationPermission;
  final ValueChanged<bool> onChangeBiometrics;
  final ValueChanged<bool> onChangeAnalyticsConsent;

  ProfileSetting(
      {super.key,
      required this.mfa,
      required this.notificationSectionGlobalKey,
      required this.biometric,
      required this.dateTime24Hrs,
      required this.onChangeMFA,
      required this.notificationPermission,
      required this.onChangeBiometrics,
      required this.onChange24Hrs,
      required this.onChangeNotificationPermission,
      required this.showBiometrics,
      required this.analyticsConsent,
      required this.onChangeAnalyticsConsent});

  final fontTwelve = AppSizes.fontTwelve;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSizes.heightTweentyFour),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VisaTextView(
            text: S.of(context).app_settings.toUpperCase(),
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontFamily: VisaFontWeight.medium,
            fontSize: fontTwelve,
            customColor: VisaColors.textFieldBorder,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: 2,
          ),
          const Divider(
            color: VisaColors.greyBackGround,
          ),
          ProfileTiles(
              onTap: () {
                AppRouter.router.push(AppRoutes.changeLanguageSelection,
                    extra: {"showBack": true});
              },
              title: S.of(context).change_language),
          ProfileSwitchTiles(
            key: notificationSectionGlobalKey,
            title: S.of(context).notifications,
            value: notificationPermission,
            valueChanged: (_) {
              onChangeNotificationPermission(_);
            },
          ),
          ProfileSwitchTiles(
            title: S.of(context).hr_clock,
            value: dateTime24Hrs,
            valueChanged: (_) {
              onChange24Hrs(_);
            },
          ),
          ProfileSwitchTiles(
            title: S.of(context).analytics_consent,
            value: analyticsConsent,
            valueChanged: (value) async {
              onChangeAnalyticsConsent(value);
            },
          ),
          VisaSizeBox(
            height: AppSizes.ten,
          ),
          VisaTextView(
            text: S.of(context).security_settings.toUpperCase(),
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontFamily: VisaFontWeight.medium,
            fontSize: fontTwelve,
            customColor: VisaColors.textFieldBorder,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: 2,
          ),
          const Divider(
            color: VisaColors.greyBackGround,
          ),
          ProfileTiles(
              onTap: () {
                AppRouter.router.push(AppRoutes.changePassword);
              },
              title: S.of(context).change_password),
          ProfileSwitchTiles(
            title: S.of(context).multi_factor_authentication,
            value: mfa,
            valueChanged: (_) {
              onChangeMFA(_);
            },
          ),
          showBiometrics
              ? ProfileSwitchTiles(
                  title: S.of(context).biometrics,
                  value: biometric,
                  valueChanged: (_) {
                    onChangeBiometrics(_);
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
