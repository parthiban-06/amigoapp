import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';

import '../utils/const_screen_size.dart';
import '../utils/test_style_util.dart';
import '../utils/utils.dart';

enum SnackBarType { success, failure }

visaSnackBar(
    {required BuildContext? context,
    required String? title,
    required String? subtitle,
    SnackBarType? type = SnackBarType.success,
    Duration? duration,
    bool? isNavBar = true,
    bool? showAtBottom}) {
  if (subtitle != null && subtitle.isNotEmpty) {
    Utils.announceMessage(subtitle);
  }
  return (context == null || title == null || title.isEmpty)
      ? null
      : ScaffoldMessenger.of(context)?..hideCurrentSnackBar()..showSnackBar(
          SnackBar(
            duration: duration ?? const Duration(seconds: 2),
            backgroundColor: VisaColors.black,
            showCloseIcon: true,
            closeIconColor: VisaColors.white,
            padding: EdgeInsets.only(
              left: AppSizes.dimSmall,
              top: AppSizes.heightSmall,
              bottom: AppSizes.heightSmall,
              right: 4.w,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16).r),
            dismissDirection: DismissDirection.down,
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VisaSvgIcon(
                  assetPath:
                      (type ?? SnackBarType.success) == SnackBarType.success
                          ? Assets.iconsIcCheck
                          : Assets.iconsIcErrorToast,
                  width: 18.w,
                  height: AppSizes.heightEighteen,
                  setColorFilter: false,
                  padding: EdgeInsets.only(
                    top: AppSizes.ten,
                  ),
                ),
                VisaSizeBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VisaTextView(
                        text: title ?? "",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.displayBodyS,
                        colorTheme: VisaTextTheme.customTextColor,
                        customColor: VisaColors.white,
                        fontSize: AppSizes.fontfourteen,
                        fontFamily: VisaFontWeight.bold,
                        letterSpacing: -0.28,
                        lineHeight: 1.14,
                      ),
                      VisaTextView(
                        text: "$subtitle" ?? "",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.displayBodyS,
                        colorTheme: VisaTextTheme.customTextColor,
                        customColor: VisaColors.white,
                        fontSize: AppSizes.fontfourteen,
                        fontFamily: VisaFontWeight.regular,
                        letterSpacing: 0.0,
                        lineHeight: 1.29,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: showAtBottom != null &&
                      showAtBottom == true &&
                      isNavBar == false
                  ? AppSizes.heightThrityFive
                  : showAtBottom != null && showAtBottom == true
                      ? AppSizes.heightHundrad
                      : AppSizes.tweentyHeight,
              left: AppSizes.dimSmall,
              right: AppSizes.dimSmall,
            ),
          ),
        );
}

void closeSnackBar({required BuildContext? context}) {
  if (context != null) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}

void showVisaToast({
  required BuildContext context,
  required String title,
  String? subtitle,
  SnackBarType type = SnackBarType.success,
  Duration duration = const Duration(seconds: 2),
  bool showAtTop = false,
}) {
  Toastification().show(
      context: context,
      title: Text(
        title,
        style: VisaTextUtils.getVisaTextStyle(
          VisaTextStyle.displayBodyL,
          context: context,
          isDarkMode: false,
          fontFamily: VisaFontWeight.regular,
          fontColor: VisaColors.black,
        ),
      ),
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.always,
        buttonBuilder: (context, onClose) {
          return GestureDetector(
            onTap: onClose,
            child: const VisaSvgIcon(
              assetPath: Assets.iconsCopyEva,
              color: VisaColors.black,
            ),
          );
        },
      ),
      description: subtitle != null && subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: VisaTextUtils.getVisaTextStyle(
                VisaTextStyle.displayBodyL,
                context: context,
                isDarkMode: false,
                fontFamily: VisaFontWeight.regular,
                fontColor: VisaColors.black,
              ),
            )
          : null,
      alignment: showAtTop ? Alignment.topCenter : Alignment.bottomCenter,
      autoCloseDuration: duration,
      backgroundColor: VisaColors.white,
      borderRadius: BorderRadius.circular(16).r,
      icon: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: VisaSvgIcon(
          assetPath: Assets.iconsIcNotification,
          width: 18.w,
          height: AppSizes.heightEighteen,
          setColorFilter: false,
        ),
      ),
      closeButtonShowType: CloseButtonShowType.onHover,
      showProgressBar: false,
      // margin: EdgeInsets.symmetric(horizontal: AppSizes.dimSmall, vertical: 16),
      closeOnClick: true);
}
