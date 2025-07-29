import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/features/redirecting/model/redirecting_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/custom_visa_two_button.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../utils/const_screen_size.dart';

class RedirectingView extends StatelessWidget {
  final String url;
  final String deeplink;
  final String bottomMessage;
  final bool openInternalBrowser;

  const RedirectingView({
    super.key,
    required this.url,
    this.deeplink = '',
    required this.bottomMessage,
    required this.openInternalBrowser,
  });

  @override
  Widget build(BuildContext context) {
    // Utils.announceMessage(S.of(context).redirected_screen);
    return ChangeNotifierProvider(
      create: (_) => RedirectingProvider(),
      child: Consumer<RedirectingProvider>(
        builder: (context, viewModel, _) {
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.tweentyHeight,
                horizontal: AppSizes.dimSmall,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        VisaSvgIcon(
                          semantics: false,
                          assetPath: Assets.iconsLoaderRedirect,
                          color: VisaColors.primary,
                          height: Sizes.fortyEightInt.h,
                          width: Sizes.fortyEightInt.w,
                        ),
                        VisaSizeBox(
                          height: Sizes.twentyInt.toDouble(),
                        ),
                        VisaTextView(
                          semanticsFocus: true,
                          text: S.of(context).you_are_now_leaving_visa_go,
                          colorTheme: VisaTextTheme.customTextColor,
                          customColor: VisaColors.primary,
                          fontSize: AppSizes.fontSmall,
                          fontFamily: VisaFontWeight.bold,
                          overflow: TextOverflow.visible,
                          lineHeight: (36 / 34).toDouble(),
                          textAlign: TextAlign.center,
                          letterSpacing: -2,
                        ),
                      ],
                    ),
                  ),
                  VisaTextView(
                    text: bottomMessage,
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
                  SizedBox(
                    height: AppSizes.thirtyHeight,
                  ),
                  CustomTwoButtons(
                    leftButtonText: S.of(context).back,
                    rightButtonText: S.of(context).txt_continue,
                    rightButtonDisable: false,
                    onLeftButtonPressed: () {
                      FirebaseAnalyticsService.logEvent(
                          eventName: "exitback_clicked",
                          parameters: {
                            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "back",
                          });
                      viewModel.closeScreen();
                    },
                    onRightButtonPressed: () {
                      FirebaseAnalyticsService.logEvent(
                          eventName: "exitcontinue_clicked",
                          parameters: {
                            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                                "continue",
                            "exit_link": (openInternalBrowser) ? url : deeplink,
                          });
                      if (openInternalBrowser) {
                        viewModel.openInternalApplication(url);
                      } else {
                        viewModel.openExternalApplication(url, deeplink);
                      }
                    },
                    isRightButtonLoading: false,
                    isLeftButtonLoading: false,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
