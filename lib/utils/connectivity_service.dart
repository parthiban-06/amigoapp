import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:visaamigo/utils/utils.dart';

import '../custom_widgets/no_internet_screen.dart';
import '../ui/base/base_provider.dart';

class ConnectivityService extends BaseProvider {
  Connectivity connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isNoInternetShown = false;

  void checkConnectivity(
    BuildContext context, {
    void Function()? onShowModal,
  }) {
    _connectivitySubscription?.cancel();

    _connectivitySubscription = connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) async {
        // Wait briefly to avoid false negatives from iOS
        await Future.delayed(const Duration(milliseconds: 300));

        final realConnection = await hasRealInternetConnection();

        Utils.logPrint("realConnection $realConnection");

        if (!realConnection && !_isNoInternetShown) {
          _isNoInternetShown = true;

          if (!context.mounted) return;

          onShowModal?.call();

          await Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => NoInternetScreen(
                onPressed: () async {
                  return await hasRealInternetConnection();
                },
              ),
            ),
          );

          // await showModalBottomSheet<void>(
          //   context: context,
          //   isDismissible: false,
          //   enableDrag: false,
          //   isScrollControlled: true,
          //   backgroundColor: VisaColors.white,
          //   shape:
          //       const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          //   builder: (BuildContext context) {
          //     return SizedBox(
          //       height: context.screenHeight, // FULL SCREEN HEIGHT
          //       child: NoInternetScreen(
          //         onPressed: () async {
          //           return await hasRealInternetConnection(); // returns true/false
          //         },
          //       ),
          //     );
          //   },
          // );

          _isNoInternetShown = false;
        }

        if (realConnection && _isNoInternetShown) {
          if (!context.mounted) return;

          final nav = Navigator.of(context, rootNavigator: true);
          if (nav.canPop()) nav.pop();

          _isNoInternetShown = false;
        }
      },
    );
  }

  Future<bool> hasRealInternetConnection() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate delay
    try {
      final result = await InternetAddress.lookup('visa.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
