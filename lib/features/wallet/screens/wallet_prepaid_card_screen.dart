import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/di/service_locator.dart' show getIt;
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_animated_text.dart';
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/features/wallet/providers/wallet_provider.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_check_balance.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_how_to_use_prepaid_card.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_prepaid_card.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../custom_widgets/visa_appbar.dart';

class WalletPrepaidCardScreen extends StatefulWidget {
  final WalletData walletData;
  final String index;

  const WalletPrepaidCardScreen({
    super.key,
    required this.walletData,
    required this.index,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WalletPrepaidCardScreenState createState() =>
      _WalletPrepaidCardScreenState();
}

class _WalletPrepaidCardScreenState extends State<WalletPrepaidCardScreen> {
  final FocusNode _focusNode = FocusNode();
  late final WalletProvider walletProvider;

  @override
  void initState() {
    super.initState();
    walletProvider =
        getIt<WalletProvider>(); // Retrieve WalletProvider using getIt
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
      onModelReady: (model) {},
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
                WalletPrepaidCardScreenCard(
                  walletData: widget.walletData,
                  index: widget.index,
                ),
                VisaSizeBox(
                  height: AppSizes.heightTweentyFour,
                ),
                const WalletHowToUsePrepaidCard(),
                const VisaAnimatedText(
                    delay: Duration(milliseconds: 500),
                    child: WalletCheckBalance()),
                VisaSizeBox(
                  height: 24.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
