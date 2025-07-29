import 'package:flutter/material.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/custom_visa_two_button.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;
import 'package:visaamigo/utils/shared_preferences.dart';

// ignore: must_be_immutable
class WalletLeavingVisaScreen extends StatefulWidget {
  String redirectionUrl;

  WalletLeavingVisaScreen(this.redirectionUrl, {super.key});

  @override
  State<WalletLeavingVisaScreen> createState() =>
      _WalletLeavingVisaScreenState();
}

class _WalletLeavingVisaScreenState extends State<WalletLeavingVisaScreen> {
  final sixteenWidth = AppSizes.dimSmall;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VisaColors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sixteenWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VisaSvgIcon(
                height: AppSizes.heightLarge,
                width: AppSizes.dimLarge,
                assetPath: Assets.iconsLoaderRedirect,
                setColorFilter: false,
              ),
              VisaTextView(
                text: S.of(context).you_are_now_leaving_visa,
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: VisaTextStyle.customLarge,
                fontFamily: VisaFontWeight.bold,
                fontSize: AppSizes.fontSmall,
                customColor: VisaColors.primary,
                colorTheme: VisaTextTheme.customTextColor,
                letterSpacing: 0,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: sixteenWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VisaTextView(
              text: (widget.redirectionUrl.isEmpty)
                  ? S.of(context).you_are_being_redirect
                  : S.of(context).you_are_being_redirect_booking,
              softWrap: true,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: VisaTextStyle.customLarge,
              fontFamily: VisaFontWeight.regular,
              fontSize: AppSizes.fontfourteen,
              customColor: VisaColors.black,
              colorTheme: VisaTextTheme.customTextColor,
              letterSpacing: 0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.tweentyHeight),
              child: CustomTwoButtons(
                leftButtonText: S.of(context).back,
                rightButtonText: S.of(context).txt_continue,
                rightButtonDisable: false,
                onLeftButtonPressed: () {
                  FirebaseAnalyticsService.logEvent(
                      eventName: "exitback_clicked",
                      parameters: {
                        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "back",
                      });
                  Navigator.of(context).pop();
                },
                onRightButtonPressed: () async {
                  FirebaseAnalyticsService.logEvent(
                      eventName: "exitcontinue_clicked",
                      parameters: {
                        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "continue",
                        "exit_link": widget.redirectionUrl,
                      });
                  if (widget.redirectionUrl.isEmpty) {
                    String ln = await Preferences.getString(
                        Preferences.keyLanguageCode);
                    AppRouter.router.pushReplacement(AppRoutes.webView, extra: {
                      "url": "https://www.booking.com/travel_coupon.$ln.html",
                      "openWeb": true
                    });
                  } else {
                    AppRouter.router.pushReplacement(AppRoutes.webView,
                        extra: {"url": widget.redirectionUrl, "openWeb": true});
                  }
                },
                isRightButtonLoading: false,
                isLeftButtonLoading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
