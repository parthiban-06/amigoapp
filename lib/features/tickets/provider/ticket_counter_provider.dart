import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/utils.dart';

class TicketCounterProvider extends BaseProvider {
  DateTime fifaStartTime = DateTime(2026, 6, 10, 23, 59, 59);

  DateTime fifaLeagueStart = DateTime(2026, 6, 30, 23, 59, 59);

  DateTime fifaEndTime = DateTime(2026, 7, 18, 23, 59, 59);
  Duration? timeLeft;
  Timer? _countdownTimer;

  Future<void> init(BuildContext context) async {
    Utils.logPrint("init for match detail");

    // setFifaStartTime();
    // setEndTime();
    _startCountdown();
  }

  void _startCountdown() {
    final now = DateTime.now();
    timeLeft = fifaStartTime.difference(now);

    _countdownTimer?.cancel(); // cancel if already running

    _countdownTimer = Timer.periodic(const Duration(seconds: 58), (timer) {
      final remaining = fifaStartTime.difference(DateTime.now());

      if (remaining.isNegative) {
        timer.cancel();
        timeLeft = Duration.zero;
      } else {
        timeLeft = remaining;
      }

      setState();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _countdownTimer?.cancel();
  }

  void setEndTime() {
    fifaEndTime = DateTime.now().subtract(const Duration(days: 1));

    setState();
  }

  void setFifaStartTime() {
    fifaStartTime = DateTime.now().subtract(const Duration(days: 1));

    setState();
  }

  void setFifaPlayoffStartTime() {
    // fifaPlayoffStartDate = DateTime.now().add(const Duration(days: 2));

    setState();
  }

  resetDateTime() {
    Utils.logPrint("fifaStartDateTime ${fifaStartTime.toString()}");
    fifaStartTime = DateTime(
      2026,
      5,
      11,
    );

    fifaEndTime = DateTime(
      2026,
      5,
      20,
    );

    setState();
  }
}
