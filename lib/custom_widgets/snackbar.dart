import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

snackBar(BuildContext? context, String? str,
    {Duration? duration, bool? showAtBottom}) {
  return (context == null || str.isNullOrEmpty)
      ? null
      : null; /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: duration ?? const Duration(milliseconds: 2500),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            showCloseIcon: true,
            closeIconColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5).h,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15).r),
            dismissDirection: DismissDirection.down,
            content: Align(
              alignment: Alignment.topCenter,
              child: Text(
                str!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                bottom: showAtBottom != null && showAtBottom ?  AppSizes.tweentyHeight : 150.h,
                left: AppSizes.tweentyWidth,
                right: AppSizes.tweentyWidth),
          ),
        );*/
}

snackBarWithContext(BuildContext? context, String? str,
    {Duration? duration, bool? showAtBottom}) {
  return (context == null || str.isNullOrEmpty)
      ? null
      : (() {
          final double bottomMargin =
              (showAtBottom != null && showAtBottom == true)
                  ? 100.h
                  : AppSizes.tweentyHeight;
          return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: duration ?? const Duration(milliseconds: 2500),
              backgroundColor: VisaColors.blueBackgroundLight,
              showCloseIcon: true,
              closeIconColor: VisaColors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 5).h,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15).r),
              dismissDirection: DismissDirection.down,
              content: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  str ?? "",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: AppSizes.fontXXSmall,
                      fontWeight: FontWeight.w600),
                ),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                  bottom: bottomMargin,
                  left: AppSizes.tweentyWidth,
                  right: AppSizes.tweentyWidth),
            ),
          );
        })();
}
