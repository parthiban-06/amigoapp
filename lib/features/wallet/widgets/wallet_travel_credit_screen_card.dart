import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_auto_size_text.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_coupon_code.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_less_info_travel_card.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;
import 'package:visaamigo/utils/utils.dart';

class WalletTravelCreditScreenCard extends StatefulWidget {
  final WalletData? walletData;
  final String index;

  const WalletTravelCreditScreenCard(
      {super.key, this.walletData, required this.index});

  @override
  State<WalletTravelCreditScreenCard> createState() =>
      _WalletTravelCreditScreenCardState();
}

class _WalletTravelCreditScreenCardState
    extends State<WalletTravelCreditScreenCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFront = true;
  final double fontTwelve = AppSizes.fontTwelve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 650), () {
      _flipCard();
      setState(() {});
    });
  }

  void _flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    setState(() {
      isFront = !isFront;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VisaTextView(
          semantics: true,
          text: S.of(context).travel_credits.toUpperCase(),
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.customLarge,
          fontFamily: VisaFontWeight.medium,
          fontSize: fontTwelve,
          customColor: VisaColors.black,
          colorTheme: VisaTextTheme.customTextColor,
          letterSpacing: 2,
        ),
        Padding(
          padding: EdgeInsets.only(top: AppSizes.heightSmall),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final isBackVisible = _animation.value > math.pi / 2;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_animation.value),
                child: isBackVisible
                    ? backOfCard(widget.walletData!)
                    : Column(
                        children: [
                          Hero(
                              tag: widget.walletData!.voucher.voucherCode +
                                  widget.index,
                              child: WalletLessInfoTravelCard(
                                walletData: widget.walletData!,
                                semantics: false,
                              )),
                          SizedBox(
                            height: 15.h,
                          )
                        ],
                      ),
              );
            },
          ),
        )
      ],
    );
  }

  backOfCard(WalletData walletData) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: Container(
        height: 220.h,
        width: context.screenWidth,
        decoration: BoxDecoration(
          color: VisaColors.bookingCardColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VisaSvgIcon(
                    semantics: false,
                    assetPath: Assets.iconsIconBooking,
                    width: 100.w,
                    height: 15.h,
                    isIconFlip: false,
                    setColorFilter: false,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        VisaTextView(
                          text: S.of(context).total_value,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.customLarge,
                          fontFamily: VisaFontWeight.semibold,
                          fontSize: AppSizes.fontTwelve,
                          customColor: VisaColors.white,
                          colorTheme: VisaTextTheme.customTextColor,
                          letterSpacing: 0,
                        ),
                        VisaSizeBox(
                          height: 4.h,
                        ),
                        VisaAutoSizeText(
                          semantics: true,
                          text: Utils.formatUsd(
                              walletData.voucher.initialBalance.amount),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.customLarge,
                          fontFamily: VisaFontWeight.semibold,
                          fontSize: 36.sp,
                          customColor: VisaColors.white,
                          colorTheme: VisaTextTheme.customTextColor,
                          letterSpacing: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: VisaTextView(
                        semantics: true,
                        text: S.of(context).redeem_date.toUpperCase(),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.customLarge,
                        fontFamily: VisaFontWeight.medium,
                        fontSize: AppSizes.fontTwelve,
                        customColor: VisaColors.white,
                        colorTheme: VisaTextTheme.customTextColor,
                        letterSpacing: 2,
                      ),
                    ),
                    VisaSizeBox(
                      height: 16.h,
                    ),
                    Expanded(
                      child: WalletCouponCode(
                          coupon: walletData.voucher.voucherCode,
                          onChange: () {}),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
