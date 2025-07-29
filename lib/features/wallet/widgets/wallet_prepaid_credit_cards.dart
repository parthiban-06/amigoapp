import 'package:flutter/material.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_prepaid_card_less.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../analytics/firebase_analytics_service.dart';

class WalletPrepaidCredits extends StatelessWidget {
  final List<WalletData> list;

  const WalletPrepaidCredits({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VisaTextView(
                text: S.of(context).prepaid_cards.toUpperCase(),
                softWrap: true,
                overflow: TextOverflow.visible,
                style: VisaTextStyle.customLarge,
                fontFamily: VisaFontWeight.medium,
                fontSize: AppSizes.fontTwelve,
                customColor: VisaColors.black,
                colorTheme: VisaTextTheme.customTextColor,
                letterSpacing: 2,
              ),
              Column(
                children: List.generate(list.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: AppSizes.heightSmall,
                    ),
                    child: InkWell(
                      onTap: () {
                        AppRouter.router.push(
                            AppRoutes.homeNestedWalletPrepaidCredit,
                            extra: {
                              "wallet": list.elementAt(index),
                              "index": index.toString()
                            });

                        // prepaidcards.clicked
                        FirebaseAnalyticsService.logEvent(
                          eventName: "prepaidcards_clicked",
                          parameters: {
                            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
                                FirebaseAnalyticsService.genericUiElement,
                            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                                "prepaid_cards",
                          },
                        );

                        FirebaseAnalyticsService.logEvent(
                          eventName: "prepaidcards_screenviewed",
                          parameters: {
                            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
                                FirebaseAnalyticsService.genericUiElement,
                          },
                        );
                      },
                      child: Hero(
                        tag: list
                                .elementAt(index)
                                .prepaidCard
                                .provisioningToken +
                            index.toString(),
                        child: WalletPrepaidCardLess(
                          walletData: list.elementAt(index),
                          semantics: true,
                        ),
                      ),
                    ),
                  );
                }),
              )
            ],
          );
  }
}
