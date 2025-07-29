import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/features/wallet/model/wallet_redeem_change.dart';
import 'package:visaamigo/features/wallet/widgets/wallet_popup_travel_credit.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../ui/base/base_provider.dart';

class WalletProvider extends BaseProvider {
  final UserDetailRepo userDetailRepo;

  WalletProvider({required this.userDetailRepo});

  WalletResponse? walletResponse;
  bool showReminder = false;
  List<WalletData> voucherList = [];
  List<WalletData> prePaidList = [];
  bool redeem = false;
  bool isLoad = false;

  init({bool? isPop, bool? isBookTravel}) async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    _setLoadingState(isPop, true);

    try {
      final rep = await userDetailRepo?.getWallet(WalletResponse.fromJson);

      if (rep?.data == null) {
        await _handleNoWalletData(context);
        return;
      }

      await _processWalletData(rep!.data!, context, isPop);
    } catch (e) {
      await _handleWalletError(context, isPop, e);
    }

    _logWalletScreenView();
  }

  void _setLoadingState(bool? isPop, bool val) {
    if (isPop == true) {
      isLoad = val;
    } else {
      isLoading = val;
    }
    setState();
  }

  Future<void> _processWalletData(
      WalletResponse data, BuildContext context, bool? isPop) async {
    walletResponse = data;
    _processVoucherList();

    if (_shouldRedirectToBooking(isPop)) {
      await _redirectToBooking(context);
      return;
    }

    _updateTravelCreditVisit(context);
    _setLoadingState(isPop, false);
  }

  void _processVoucherList() {
    voucherList.clear();
    for (final walletData in walletResponse!.data) {
      if (!walletData.voucher.voucherRedeemed) {
        voucherList.add(walletData);
      }
    }
  }

  bool _shouldRedirectToBooking(bool? isPop) {
    return isPop == true && voucherList.isEmpty;
  }

  Future<void> _redirectToBooking(BuildContext context) async {
    final ln = await Preferences.getString(Preferences.keyLanguageCode);
    if (context.mounted) {
      Navigator.of(context).pop();

      await navPush(AppRoutes.redirecting, extra: {
        "url": "https://www.booking.com/index.$ln.html",
        "deeplink": "",
        "openInternalBrowser": true,
        "bottomMessage": S.of(context).you_are_being_redirect,
      });
    }
  }

  void _updateTravelCreditVisit(BuildContext context) {
    if (context.mounted) {
      Provider.of<UserGenericProvider>(context, listen: false)
          .updateTravelCreditVisit();
    }
  }

  Future<void> _handleNoWalletData(BuildContext context) async {
    final ln = await Preferences.getString(Preferences.keyLanguageCode);
    if (context.mounted) {
      Navigator.of(context).pop();

      await navPush(AppRoutes.redirecting, extra: {
        "url": "https://www.booking.com/travel_coupon.$ln.html",
        "deeplink": "",
        "openInternalBrowser": true,
        "bottomMessage": S.of(context).any_booking_from_this,
      });
    }
  }

  Future<void> _handleWalletError(
      BuildContext context, bool? isPop, dynamic error) async {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    _setLoadingState(isPop, false);
    setState();
    Utils.logPrint("Error: $error");
  }

  void _logWalletScreenView() {
    FirebaseAnalyticsService.logEvent(
      eventName: "wallet_screenview",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
            FirebaseAnalyticsService.genericUiElement,
      },
    );
  }

  checkRedeemed(bool val) {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();
    if (context.mounted) {
      Provider.of<UserGenericProvider>(context, listen: false)
          .updateWalletRedeem(val);
    }
    redeem = val;
    setState();
  }

  changeReminder() {
    showReminder = !showReminder;
    Preferences.setBool(Preferences.walletReminder, showReminder);
    setState();
  }

  patchWallet(List<WalletData> walletData) async {
    if (showReminder == true) {
      // Capture context before async operations to avoid BuildContext across async gaps
      final context = getContext();
      if (context.mounted) {
        Provider.of<UserGenericProvider>(context, listen: false)
            .updateWalletRedeem(true);
      }
      RedemptionStatusResponse redemptionStatus =
          RedemptionStatusResponse(data: []);
      for (int i = 0; i < walletData.length; i++) {
        redemptionStatus.data.add(RedemptionStatus(
            packageId: walletData.elementAt(i).packageId,
            voucherRedeemed: true,
            prepaidCardRedeemed: false));
      }
      await userDetailRepo?.updateWallet(
          (json) => (), redemptionStatus.toJson());
    }
  }

  letsGoButton(bool? isBookTravel, List<WalletData>? list) async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    if (isBookTravel != null && isBookTravel == true) {
      String ln = await Preferences.getString(Preferences.keyLanguageCode);
      if (context.mounted) {
        navPush(AppRoutes.redirecting, extra: {
          "url": "https://www.booking.com/index.$ln.html",
          "deeplink": "",
          "openInternalBrowser": true,
          "bottomMessage": S.of(context).you_are_being_redirect,
        });
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    } else {
      String ln = await Preferences.getString(Preferences.keyLanguageCode);
      if (context.mounted) {
        navPush(AppRoutes.redirecting, extra: {
          "url": "https://www.booking.com/travel_coupon.$ln.html",
          "deeplink": "",
          "openInternalBrowser": true,
          "bottomMessage": S.of(context).any_booking_from_this,
        });
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }

    patchWallet((list == null || list.isEmpty) ? voucherList : list);
  }

  redeemButton(WalletData walletData) async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    if (redeem) {
      String ln = await Preferences.getString(Preferences.keyLanguageCode);
      if (context.mounted) {
        navPush(AppRoutes.redirecting, extra: {
          "url": "https://www.booking.com/index.$ln.html",
          "deeplink": "",
          "openInternalBrowser": true,
          "bottomMessage": S.of(context).you_are_being_redirect,
        });
      }
    } else {
      if (context.mounted) {
        await Utils.walletPopupTravelCredit(
            context: context,
            child: WalletPopupTravelScreen(
              list: [walletData],
            ));
      }
      setState();
    }
  }
}
