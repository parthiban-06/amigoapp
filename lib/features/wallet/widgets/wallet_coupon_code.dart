import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';

class WalletCouponCode extends StatefulWidget {
  final String coupon;
  final Function onChange;

  const WalletCouponCode(
      {super.key, required this.coupon, required this.onChange});

  @override
  State<WalletCouponCode> createState() => _WalletCouponCodeState();
}

class _WalletCouponCodeState extends State<WalletCouponCode> {
  bool isCopy = false;
  final double fontfourteen = AppSizes.fontfourteen;
  final double eightWidth = AppSizes.eightWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.heightFiftySeven,
      width: context.screenWidth,
      decoration: BoxDecoration(
          color: VisaColors.white,
          borderRadius: BorderRadius.circular(AppSizes.tenRadius),
          border: isCopy
              ? Border.all(color: VisaColors.green, width: 2)
              : Border.all(color: VisaColors.transparent, width: 2)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.dimSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            VisaTextView(
              semantics: true,
              text: widget.coupon,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: VisaTextStyle.customLarge,
              fontFamily: VisaFontWeight.semibold,
              fontSize: AppSizes.fontMedium,
              customColor: VisaColors.black,
              colorTheme: VisaTextTheme.customTextColor,
              letterSpacing: 0,
            ),
            isCopy == false
                ? Semantics(
                    label: S.of(context).copy_code,
                    button: true,
                    enabled: true,
                    excludeSemantics: true,
                    child: InkWell(
                      onTap: () async {
                        FirebaseAnalyticsService.logEvent(
                          eventName: "travelcredit_codecopied",
                          parameters: {
                            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
                                FirebaseAnalyticsService.genericUiElement,
                            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                                "copy_code",
                          },
                        );

                        Clipboard.setData(ClipboardData(text: widget.coupon));
                        widget.onChange;
                        setState(() {
                          isCopy = true;
                        });
                        Utils.announceMessage(S.of(context).code_copied);
                      },
                      child: Row(
                        children: [
                          VisaSvgIcon(
                            semantics: false,
                            height: AppSizes.heightEighteen,
                            assetPath: Assets.iconsIcCopy,
                            setColorFilter: false,
                          ),
                          VisaSizeBox(
                            width: eightWidth,
                          ),
                          VisaTextView(
                            semantics: false,
                            text: S.of(context).copy_code,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: VisaTextStyle.customLarge,
                            fontFamily: VisaFontWeight.semibold,
                            fontSize: fontfourteen,
                            customColor: VisaColors.primary,
                            colorTheme: VisaTextTheme.customTextColor,
                            letterSpacing: 0,
                          ),
                        ],
                      ),
                    ),
                  )
                : Row(
                    children: [
                      VisaSvgIcon(
                        height: AppSizes.heightEighteen,
                        assetPath: Assets.iconsIcCheck,
                        setColorFilter: false,
                      ),
                      VisaSizeBox(
                        width: eightWidth,
                      ),
                      VisaTextView(
                        text: S.of(context).copied,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.customLarge,
                        fontFamily: VisaFontWeight.semibold,
                        fontSize: fontfourteen,
                        customColor: VisaColors.green,
                        colorTheme: VisaTextTheme.customTextColor,
                        letterSpacing: 0,
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
