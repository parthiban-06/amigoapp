import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_checkbox.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/di/service_locator.dart' show getIt;
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/features/wallet/providers/wallet_provider.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_coupon_code.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../profile/provider/user_generic_detail_provider.dart';

class WalletPopupTravelScreen extends StatefulWidget {
  final List<WalletData>? list;
  final bool? isBookTravel;

  const WalletPopupTravelScreen({super.key, this.list, this.isBookTravel});

  @override
  // ignore: library_private_types_in_public_api
  _WalletPopupTravelScreenState createState() =>
      _WalletPopupTravelScreenState();
}

class _WalletPopupTravelScreenState extends State<WalletPopupTravelScreen> {
  late final WalletProvider walletProvider;

  @override
  void initState() {
    super.initState();
    walletProvider = getIt<WalletProvider>();
    walletProvider.setContext(context); // Retrieve WalletProvider using getIt
    walletProvider.init(
        isPop: true,
        isBookTravel: widget.isBookTravel); // Initialize the provider
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<WalletProvider>(
      viewModel: walletProvider,
      addDefaultPadding: false,
      setTopSafeArea: false,
      screenBackgroundColor: VisaColors.transparent,
      onPageBuilderMobileView:
          (BuildContext context, WalletProvider viewModel) {
        if (viewModel.isLoad) {
          return const Center(child: CircularProgressIndicator());
        }

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              width: context.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: VisaColors.blueBackgroundLightNew,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    _buildIconSection(context),
                    _buildTitleSection(context),
                    _buildVoucherList(context, viewModel),
                    _buildActionSection(context, viewModel),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        VisaSizeBox(height: 24.h),
        Semantics(
          button: true,
          excludeSemantics: false,
          enabled: true,
          label: S.of(context).close,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                VisaSvgIcon(
                  semantics: false,
                  height: 8.5.h,
                  width: 8.5.w,
                  assetPath: Assets.iconsIcClose,
                  color: VisaColors.black,
                ),
                VisaSizeBox(width: 4.w),
                VisaTextView(
                  semantics: false,
                  text: S.of(context).close.toUpperCase(),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: VisaTextStyle.customLarge,
                  fontFamily: VisaFontWeight.medium,
                  fontSize: AppSizes.fontTwelve,
                  customColor: VisaColors.black,
                  colorTheme: VisaTextTheme.customTextColor,
                  letterSpacing: 2,
                ),
              ],
            ),
          ),
        ),
        VisaSizeBox(height: 24.h),
      ],
    );
  }

  Widget _buildIconSection(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60.h,
          width: 60.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: VisaColors.primary,
          ),
          child: Center(
            child: VisaSvgIcon(
              height: Sizes.thirtyTwoInt.h,
              width: Sizes.thirtyTwoInt.w,
              assetPath: Assets.iconsIcTravel,
              color: VisaColors.blueBackgroundLightNew,
            ),
          ),
        ),
        VisaSizeBox(height: 24.h),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    final userProvider =
        Provider.of<UserGenericProvider>(context, listen: false);
    final titleText = userProvider.readTravelCredit > 2
        ? S.of(context).have_you_redeemed
        : S.of(context).you_have_a_travel_credit;

    return Column(
      children: [
        VisaTextView(
          text: titleText,
          softWrap: true,
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.customLarge,
          fontFamily: VisaFontWeight.medium,
          fontSize: 36.sp,
          customColor: VisaColors.primary,
          colorTheme: VisaTextTheme.customTextColor,
          letterSpacing: 0,
        ),
        VisaSizeBox(height: 24.h),
      ],
    );
  }

  Widget _buildVoucherList(BuildContext context, WalletProvider viewModel) {
    final hasVouchers = _hasVouchers(viewModel);

    if (!hasVouchers) {
      return const SizedBox();
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: Utils.getFontSize(context)
            ? context.screenHeight * 0.3
            : context.screenHeight * 0.4,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: _buildVoucherItems(context, viewModel),
        ),
      ),
    );
  }

  bool _hasVouchers(WalletProvider viewModel) {
    return (widget.list != null && widget.list!.isNotEmpty) ||
        viewModel.voucherList.isNotEmpty;
  }

  List<Widget> _buildVoucherItems(
      BuildContext context, WalletProvider viewModel) {
    final listToUse = _getVoucherList(viewModel);
    final length = listToUse.length;

    return List.generate(length, (index) {
      final voucherCode = _getVoucherCode(listToUse, index);
      final amount = _getVoucherAmount(listToUse, index);

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WalletCouponCode(
            coupon: voucherCode,
            onChange: () {},
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: VisaTextView(
              text: S
                  .of(context)
                  .travel_credit_starting_value(Utils.formatUsd(amount)),
              softWrap: true,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: VisaTextStyle.customLarge,
              fontFamily: VisaFontWeight.medium,
              fontSize: AppSizes.fontTwelve,
              customColor: VisaColors.black,
              colorTheme: VisaTextTheme.customTextColor,
              letterSpacing: 0,
            ),
          ),
        ],
      );
    });
  }

  List<dynamic> _getVoucherList(WalletProvider viewModel) {
    if (widget.list != null && widget.list!.isNotEmpty) {
      return widget.list!;
    }
    return viewModel.voucherList;
  }

  String _getVoucherCode(List<dynamic> list, int index) {
    final item = list.elementAt(index);
    return item.voucher.voucherCode;
  }

  String _getVoucherAmount(List<dynamic> list, int index) {
    final item = list.elementAt(index);
    return item.voucher.initialBalance.amount.toString();
  }

  Widget _buildActionSection(BuildContext context, WalletProvider viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VisaSizeBox(height: 12.h),
        VisaButton(
          text: S.of(context).lets_go,
          onPressed: () =>
              viewModel.letsGoButton(widget.isBookTravel, widget.list),
          isDisable: false,
          fontWeight: VisaFontWeight.medium,
          variant: VisaButtonVariant.primary,
        ),
        VisaSizeBox(height: 14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VisaCheckbox(
              variant: VisaCheckboxVariant.white,
              value: viewModel.showReminder,
              onChanged: (_) => viewModel.changeReminder(),
            ),
            VisaSizeBox(width: 2.w),
            Flexible(
              child: VisaTextView(
                text: S.of(context).dont_show_me_this,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: VisaTextStyle.customLarge,
                fontFamily: VisaFontWeight.regular,
                fontSize: AppSizes.fontTwelve,
                customColor: VisaColors.black,
                colorTheme: VisaTextTheme.customTextColor,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        VisaSizeBox(height: 10.h),
      ],
    );
  }
}
