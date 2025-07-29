import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_auto_size_text.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

class WalletLessInfoTravelCard extends StatelessWidget {
  final WalletData walletData;
  final bool semantics;

  const WalletLessInfoTravelCard(
      {super.key, required this.walletData, required this.semantics});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          "${S.of(context).travel_credits} ${S.of(context).booking_com} ${S.of(context).total_value} ${Utils.formatUsd(walletData.voucher.initialBalance.amount)}",
      excludeSemantics: semantics,
      child: IgnorePointer(
        ignoring: true,
        child: Material(
          child: Container(
            height: 205.h,
            width: context.screenWidth,
            decoration: BoxDecoration(
              color: VisaColors.bookingCardColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Stack(
              children: [
                VisaSvgIcon(
                  semantics: false,
                  assetPath: Assets.iconsIcBooking,
                  width: 250.w,
                  height: 250.h,
                  isIconFlip: false,
                  setColorFilter: false,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            VisaTextView(
                              semantics: false,
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
                              semantics: false,
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: VisaSvgIcon(
                          assetPath: Assets.iconsIconBooking,
                          width: 132.w,
                          isIconFlip: false,
                          height: 23.h,
                          setColorFilter: false,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
