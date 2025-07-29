import 'package:flutter/material.dart';

class VisaNoScrollBehaviorWeb extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // 👈 disables the glow effect
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // 👈 disables scrollbar (Web only)
  }
}
