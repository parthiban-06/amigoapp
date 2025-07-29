import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_icon_with_text_widget.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../utils/const_screen_size.dart';

class FaqVisaSupportToolTipWrapperWidget extends StatefulWidget {
  final Widget child;
  final SuperTooltipController superTooltipController;

  const FaqVisaSupportToolTipWrapperWidget({
    super.key,
    required this.child,
    required this.superTooltipController,
  });

  @override
  State<FaqVisaSupportToolTipWrapperWidget> createState() => _State();
}

class _State extends State<FaqVisaSupportToolTipWrapperWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperTooltip(
      controller: widget.superTooltipController,
      verticalOffset: 0.0,
      minimumOutsideMargin: 0.0,
      arrowTipDistance: 0.0,
      arrowBaseWidth: 0.0,
      elevation: 0.0,
      arrowLength: 0.0,
      arrowTipRadius: 0.0,
      shadowBlurRadius: 0.0,
      showBarrier: true,
      popupDirection: context.screenWidth <= 1450
          ? TooltipDirection.right
          : TooltipDirection.left,
      borderRadius: AppSizes.sixteenRadius,
      borderColor: VisaColors.blueBackgroundLightNew,
      backgroundColor: VisaColors.blueBackgroundLightNew,
      shadowColor: VisaColors.transparent,
      barrierColor: VisaColors.transparent,
      content: Container(
        width: 272.w,
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.tweleveHeight,
          horizontal: AppSizes.tweleveWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: AppSizes.ten,
          children: [
            VisaTextView(
              text: S.of(context).visa_go_support.toUpperCase(),
              softWrap: true,
              overflow: TextOverflow.visible,
              style: VisaTextStyle.custom,
              fontFamily: VisaFontWeight.medium,
              fontSize: AppSizes.fontTwelve,
              customColor: VisaColors.dividerColor,
              lineHeight: 1.40,
              colorTheme: VisaTextTheme.customTextColor,
              letterSpacing: 2,
            ),
            Semantics(
              label: S.of(context).email,
              button: true,
              enabled: true,
              excludeSemantics: true,
              child: InkWell(
                child: VisaIconWithTextWidget(
                  iconPath: Assets.iconsEmailOutline,
                  iconColor: VisaColors.black,
                  text: S.of(context).contact_visa_go_com,
                  style: VisaTextStyle.displayBodyS,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.primary,
                  fontFamily: VisaFontWeight.semibold,
                  lineHeight: 1.43,
                  letterSpacing: -0.50,
                  iconHeight: Sizes.twentyFourInt.toDouble(),
                  iconWidth: Sizes.twentyFourInt.toDouble(),
                  iconPadding: EdgeInsets.only(top: 5.h),
                  spacing: 10.w,
                ),
                onTap: () {},
              ),
            ),
            Semantics(
              label: S.of(context).phone_number,
              button: true,
              enabled: true,
              excludeSemantics: true,
              child: InkWell(
                child: VisaIconWithTextWidget(
                  iconPath: Assets.iconsCall,
                  iconColor: VisaColors.black,
                  text: "+1-800-VISA-GO",
                  style: VisaTextStyle.displayBodyS,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.semibold,
                  lineHeight: 1.43,
                  letterSpacing: -0.50,
                  iconHeight: Sizes.twentyFourInt.toDouble(),
                  iconWidth: Sizes.twentyFourInt.toDouble(),
                  iconPadding: EdgeInsets.only(top: 5.h),
                  spacing: 10.w,
                ),
                onTap: () {},
              ),
            ),
            Semantics(
              label: S.of(context).messages,
              button: true,
              enabled: true,
              excludeSemantics: true,
              child: InkWell(
                child: VisaIconWithTextWidget(
                  iconPath: Assets.iconsChatBubbleOutline,
                  iconColor: VisaColors.black,
                  text: "SMS: VISA-GO",
                  style: VisaTextStyle.displayBodyS,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.semibold,
                  lineHeight: 1.43,
                  letterSpacing: -0.50,
                  iconHeight: Sizes.twentyFourInt.toDouble(),
                  iconWidth: Sizes.twentyFourInt.toDouble(),
                  iconPadding: EdgeInsets.only(top: 5.h),
                  spacing: 10.w,
                ),
                onTap: () {},
              ),
            ),
            Semantics(
              label: S.of(context).whatsApp,
              button: true,
              enabled: true,
              excludeSemantics: true,
              child: InkWell(
                child: VisaIconWithTextWidget(
                  iconPath: Assets.iconsWhatsapp,
                  iconColor: VisaColors.black,
                  text: "WhatsApp: +1-800-VISA-GO",
                  style: VisaTextStyle.displayBodyS,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.semibold,
                  lineHeight: 1.43,
                  letterSpacing: -0.50,
                  iconHeight: Sizes.twentyFourInt.toDouble(),
                  iconWidth: Sizes.twentyFourInt.toDouble(),
                  iconPadding: EdgeInsets.only(top: 5.h),
                  spacing: 10.w,
                ),
                onTap: () {},
              ),
            )
          ],
        ),
      ),
      child: widget.child,
    );
  }
}
