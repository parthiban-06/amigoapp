import 'package:flutter/material.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_less_info_travel_card.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../analytics/firebase_analytics_service.dart';

class WalletTravelCreditCard extends StatelessWidget {
  final List<WalletData> list;
  final Function onChange;

  const WalletTravelCreditCard(
      {super.key, required this.list, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VisaTextView(
                text: S.of(context).travel_credits.toUpperCase(),
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
                    padding: EdgeInsets.only(top: AppSizes.heightSmall),
                    child: InkWell(
                      onTap: () async {
                        await AppRouter.router.push(
                            AppRoutes.homeNestedWalletTravelCredit,
                            extra: {
                              "wallet": list.elementAt(index),
                              "index": index.toString()
                            });

                        FirebaseAnalyticsService.logEvent(
                          eventName: "travelcredit_clicked",
                          parameters: {
                            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
                                FirebaseAnalyticsService.genericUiElement,
                            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                                "travel_credits_wallet",
                          },
                        );
                      },
                      child: Hero(
                        tag: list.elementAt(index).voucher.voucherCode +
                            index.toString(),
                        child: WalletLessInfoTravelCard(
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
