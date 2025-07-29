import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/di/service_locator.dart' show getIt;
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_animated_text.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/features/wallet/providers/wallet_provider.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_check_current_balance_card.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_how_to_use_travel_credit.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_redeem_your_travel_credit.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_travel_credit_screen_card.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/visa_appbar.dart';

class WalletTravelCredit extends StatefulWidget {
  final WalletData walletData;
  final String index;

  const WalletTravelCredit({
    super.key,
    required this.walletData,
    required this.index,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WalletTravelCreditState createState() => _WalletTravelCreditState();
}

class _WalletTravelCreditState extends State<WalletTravelCredit> {
  final FocusNode _focusNode = FocusNode();
  late final WalletProvider walletProvider;
  final double heightTweentyFour = AppSizes.heightTweentyFour;

  @override
  void initState() {
    super.initState();
    walletProvider = getIt<WalletProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<WalletProvider>(
      viewModel: walletProvider,
      setTopSafeArea: false,
      addDefaultPadding: false,
      buildAppBar: VisaAppBar(
        isActionButtonShow: true,
        focusNode: _focusNode,
        isCancelWithTextButtonShow: true,
        onCancelPress: () {
          Navigator.of(context).pop();
        },
      ),
      onModelReady: (model) {
        model.checkRedeemed(widget.walletData.voucher.voucherRedeemed);
      },
      onPageBuilderMobileView:
          (BuildContext context, WalletProvider viewModel) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.dimSmall),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VisaSizeBox(
                  height: AppSizes.heightSmall,
                ),
                WalletTravelCreditScreenCard(
                  walletData: widget.walletData,
                  index: widget.index,
                ),
                VisaSizeBox(
                  height: heightTweentyFour,
                ),
                const WalletHowToUseTravelCredit(),
                InkWell(
                    onTap: () {
                      viewModel.redeemButton(widget.walletData);

                      FirebaseAnalyticsService.logEvent(
                        eventName: "travelcredit_booktravelclicked",
                        parameters: {
                          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
                              "wallet_travel_credit",
                          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                              "book_travel",
                        },
                      );
                    },
                    child: VisaAnimatedText(
                      delay: const Duration(milliseconds: 500),
                      child: WallerRedeemUrTravelCredits(
                        isRedeemed: viewModel.redeem ||
                            Provider.of<UserGenericProvider>(context,
                                        listen: false)
                                    .walletRedeem ==
                                true,
                      ),
                    )),
                viewModel.redeem == true ||
                        Provider.of<UserGenericProvider>(context, listen: false)
                                .walletRedeem ==
                            true
                    ? Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: heightTweentyFour),
                        child: const VisaAnimatedText(
                            delay: Duration(milliseconds: 600),
                            child: WalletCheckCurrentBalanceCard()),
                      )
                    : VisaSizeBox(
                        height: heightTweentyFour,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
