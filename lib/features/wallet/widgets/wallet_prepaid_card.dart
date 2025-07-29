import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_auto_size_text.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_prepaid_card_less.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';

class WalletPrepaidCardScreenCard extends StatefulWidget {
  final WalletData walletData;
  final String index;

  const WalletPrepaidCardScreenCard(
      {super.key, required this.walletData, required this.index});

  @override
  State<WalletPrepaidCardScreenCard> createState() =>
      _WalletPrepaidCardScreenCardState();
}

class _WalletPrepaidCardScreenCardState
    extends State<WalletPrepaidCardScreenCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFront = true;

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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VisaTextView(
          text: S.of(context).prepaid_cards.toUpperCase(),
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.customLarge,
          fontFamily: VisaFontWeight.medium,
          fontSize: 12.sp,
          customColor: VisaColors.black,
          colorTheme: VisaTextTheme.customTextColor,
          letterSpacing: 2,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h),
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
                    ? backOfCard()
                    : Column(
                        children: [
                          Hero(
                              tag: widget.walletData.prepaidCard
                                      .provisioningToken +
                                  widget.index,
                              child: WalletPrepaidCardLess(
                                walletData: widget.walletData,
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

  backOfCard() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: Container(
        height: 220.h,
        width: context.screenWidth,
        decoration: BoxDecoration(
          color: VisaColors.primary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VisaSvgIcon(
                    semantics: false,
                    assetPath: Assets.iconsVisaLogo,
                    width: 80.w,
                    height: 35.h,
                    isIconFlip: false,
                    color: VisaColors.white,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        VisaTextView(
                          // semantics: false,
                          text: S.of(context).total_value,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.customLarge,
                          fontFamily: VisaFontWeight.semibold,
                          fontSize: 12.sp,
                          customColor: VisaColors.white,
                          colorTheme: VisaTextTheme.customTextColor,
                          letterSpacing: 0,
                        ),
                        VisaSizeBox(
                          height: 4.h,
                        ),
                        VisaAutoSizeText(
                          // semantics: false,
                          text: Utils.formatUsd(widget
                              .walletData.prepaidCard.initialBalance.amount),
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
              !(DateTime.now().isAfter(DateTime(2026, 6, 1)) ||
                      DateTime.now().isAtSameMomentAs(DateTime(2026, 6, 1)))
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VisaTextView(
                            semantics: true,
                            text: S
                                .of(context)
                                .card_access_begins
                                .toUpperCase(),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: VisaTextStyle.customLarge,
                            fontFamily: VisaFontWeight.medium,
                            fontSize: Sizes.twelveInt.sp,
                            customColor: VisaColors.white,
                            lineHeight: 15.8.h / Sizes.twelveInt.toDouble(),
                            colorTheme: VisaTextTheme.customTextColor,
                            letterSpacing: 2,
                          ),
                          VisaTextView(
                            semantics: true,
                            text: S.of(context).first_june_2026.toUpperCase(),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: VisaTextStyle.customLarge,
                            fontFamily: VisaFontWeight.medium,
                            fontSize: Sizes.twelveInt.sp,
                            lineHeight: 15.8.h / Sizes.twelveInt.toDouble(),
                            customColor: VisaColors.white,
                            colorTheme: VisaTextTheme.customTextColor,
                            letterSpacing: 2,
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        FirebaseAnalyticsService.logEvent(
                          eventName: "prepaidcards_addtoapplewalletclicked",
                          parameters: {
                            AnalyticsEventConst
                                    .PARAM_NAME_UI_ELEMENT_LOCATION: "wallet_prepaid_card",
                            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                                "add_to_apple_wallet",
                          },
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VisaTextView(
                            text: S.of(context).redeem_date.toUpperCase(),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: VisaTextStyle.customLarge,
                            fontFamily: VisaFontWeight.medium,
                            fontSize: 12.sp,
                            customColor: VisaColors.white,
                            colorTheme: VisaTextTheme.customTextColor,
                            letterSpacing: 2,
                          ),
                          VisaSizeBox(
                            height: 16.h,
                          ),
                          Container(
                            height: 60.h,
                            width: context.screenWidth,
                            decoration: BoxDecoration(
                              color: VisaColors.black,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Assets.imagesAppleWallet,
                                    height: 45.h,
                                    width: 60.w,
                                  ),
                                  VisaSizeBox(
                                    width: 8.w,
                                  ),
                                  VisaTextView(
                                    text: S.of(context).add_to_apple_wallet,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: VisaTextStyle.customLarge,
                                    fontFamily: VisaFontWeight.semibold,
                                    fontSize: 16.sp,
                                    customColor: VisaColors.white,
                                    colorTheme: VisaTextTheme.customTextColor,
                                    letterSpacing: 0,
                                  ),
                                ],
                              ),
                            ),
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
