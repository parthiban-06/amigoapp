import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

enum ErrorCode {
  notFound,
  unknownError,
}

class VisaSnackBar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static show({
    String? message,
    ErrorCode? errorCode,
    Duration? duration,
  }) {
    if (scaffoldMessengerKey.currentState == null ||
        AppRouter.nonAuth.contains(AppRouter.currentRoute)) {
      return;
    }

    return scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        duration: duration ?? const Duration(milliseconds: 2500),
        backgroundColor: VisaColors.blueBackgroundLight,
        showCloseIcon: true,
        closeIconColor: VisaColors.black,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5).h,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15).r),
        dismissDirection: DismissDirection.down,
        content: Align(
          alignment: Alignment.topCenter,
          child: Text(
            S
                .of(scaffoldMessengerKey.currentState!.context)
                .something_went_wrong_vpn_issue,
            style: TextStyle(
                color: VisaColors.black,
                fontSize: AppSizes.fontXXSmall,
                fontWeight: FontWeight.w600),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom:  AppSizes.tweentyHeight, left: AppSizes.tweentyWidth, right: AppSizes.tweentyWidth),
      ),
    );
  }

  static getContext() {
    if (scaffoldMessengerKey.currentState == null ||
        scaffoldMessengerKey.currentState!.mounted == false) {
      return null;
    }
    return scaffoldMessengerKey.currentState!.context;
  }
}
