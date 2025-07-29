import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visaamigo/custom_widgets/visa_custom_native_dialog.dart';
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

class InactivityService extends ChangeNotifier with WidgetsBindingObserver {
  BuildContext? _context;
  Timer? _timer;
  Timer? _timerPopup;
  DateTime? _backgroundTime;

  final int timeoutDuration = 120 * 60;
  int _remainingTime = 120 * 60;
  final int timeoutDurationPopup = 118 * 60;
  int _remainingTimePopup = 118 * 60;

  InactivityService(BuildContext context) {
    _context = context;
    notifyListeners();
    WidgetsBinding.instance.addObserver(this);
    _resetTimer();
  }

  void _resetTimer() {
    WidgetsBinding.instance.addObserver(this);
    _timer?.cancel();
    _timerPopup?.cancel();
    _remainingTime = timeoutDuration;
    _remainingTimePopup = timeoutDurationPopup;
    _timerPopup =
        Timer(Duration(seconds: _remainingTimePopup), showSessionPopup);
    _timer = Timer(Duration(seconds: _remainingTime), _logoutUser);
    notifyListeners(); // Notify UI if needed
  }

  showSessionPopup() {
    if (AppRouter.nonAuth.contains(AppRouter.currentRoute)) {
      return;
    }
    Utils.logPrint("SessionPopup happened");
    WidgetsBinding.instance.removeObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.announceMessage(S.of(_context!).session_expiring_soon);
    });
    if (_context != null) {
      VisaNativeDialog.show(
        context: _context!,
        title: S.of(_context!).session_expiring_soon,
        message: S.of(_context!).you_will_be_logged_out,
        config: VisaDialogConfig(
          positiveButtonText: S.of(_context!).stay_signed_in,
          // negativeButtonText: S.of(_context!).cancel,
          barrierDismissible: false,
          onPositivePressed: () async {
            // Handle confirmation
            userInteraction(_context!);
          },
          onNegativePressed: () async {},
        ),
      );
    }
  }

  void _logoutUser() {
    if (AppRouter.nonAuth.contains(AppRouter.currentRoute)) {
      return;
    }
    Utils.logPrint("Logout happened");
    WidgetsBinding.instance.removeObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.announceMessage(S.of(_context!).signed_out_due_to_inactivity);
    });
    _timer?.cancel();
    if (_context != null) {
      visaSnackBar(
          context: _context!,
          type: SnackBarType.success,
          title: S.of(_context!).signed_out_due_to_inactivity,
          subtitle: S.of(_context!).please_login_to_continue,
          showAtBottom: true);
      AppRouter.router
          .goRoute(AppRoutes.login, extra: {"showBiometrics": false});
    }
  }

  void userInteraction(BuildContext context) {
    if (AppRouter.nonAuth.contains(AppRouter.currentRoute)) {
      return;
    }
    Utils.logPrint("inactivity userInteraction");
    WidgetsBinding.instance.addObserver(this);
    _context = context;
    notifyListeners();
    _resetTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppRouter.nonAuth.contains(AppRouter.currentRoute)) {
      return;
    }
    if (state == AppLifecycleState.paused) {
      // App is in background - save time
      _backgroundTime = DateTime.now();
      Utils.logPrint("background time: " + _remainingTime.toString());
      _timer?.cancel();
      _timerPopup?.cancel();
    } else if (state == AppLifecycleState.resumed && _backgroundTime != null) {
      // Calculate time spent in background
      int secondsSpentInBackground =
          DateTime.now().difference(_backgroundTime!).inSeconds;
      Utils.logPrint("user spend: " + secondsSpentInBackground.toString());
      _backgroundTime = null;

      _remainingTime -= secondsSpentInBackground; // Deduct background time
      _remainingTimePopup -= secondsSpentInBackground; // Deduct background time

      Utils.logPrint("remaning time: " + _remainingTime.toString());

      if (_remainingTime <= 0) {
        _logoutUser();
      } else {
        _timer = Timer(Duration(seconds: _remainingTime), _logoutUser);
        if (_remainingTimePopup <= 0) {
          showSessionPopup();
        } else {
          _timerPopup =
              Timer(Duration(seconds: _remainingTimePopup), showSessionPopup);
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _timerPopup?.cancel();
    super.dispose();
  }
}
