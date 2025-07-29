import 'package:flutter/material.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/di/service_locator.dart' show getIt;
import 'package:visaamigo/features/wallet/providers/wallet_provider.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_prepaid_credit_cards.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_travel_credit_card.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../custom_widgets/visa_appbar.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final WalletProvider walletProvider;

  @override
  void initState() {
    super.initState();
    walletProvider =
        getIt<WalletProvider>(); // Retrieve WalletProvider using getIt
    walletProvider.setContext(context);
    walletProvider.init(); // Initialize the provider
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<WalletProvider>(
      viewModel: walletProvider,
      setTopSafeArea: false,
      addDefaultPadding: false,
      buildAppBar: VisaAppBar(
        isActionButtonShow: true,
        isCancelWithTextButtonShow: true,
        onCancelPress: () {
          Navigator.of(context).pop();
        },
      ),
      onPageBuilderMobileView:
          (BuildContext context, WalletProvider viewModel) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.dimSmall),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: AppSizes.tweentyHeight),
                  child: VisaTextView(
                    text: S.of(context).wallet,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: VisaTextStyle.customLarge,
                    fontFamily: VisaFontWeight.semibold,
                    fontSize: AppSizes.fontXSmall,
                    customColor: VisaColors.black,
                    colorTheme: VisaTextTheme.customTextColor,
                    letterSpacing: -1,
                  ),
                ),
                WalletTravelCreditCard(
                  list: viewModel.walletResponse != null
                      ? viewModel.walletResponse!.data
                      : [],
                  onChange: () {},
                ),
                VisaSizeBox(
                  height: AppSizes.heightSmall,
                ),
                WalletPrepaidCredits(
                  list: viewModel.walletResponse != null
                      ? viewModel.walletResponse!.data
                      : [],
                ),
                AppSizes.mediumVS,
              ],
            ),
          ),
        );
      },
    );
  }
}
