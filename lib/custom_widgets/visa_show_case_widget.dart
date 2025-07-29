import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../core/theme/theme.dart';

class VisaShowcase extends StatelessWidget {
  final GlobalKey keyValue;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsets? targetPadding;
  final Color overlayColor;
  final Color tooltipBackgroundColor;
  final bool isComeFromHome;

  const VisaShowcase({
    super.key,
    required this.keyValue,
    required this.child,
    required this.isComeFromHome,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.targetPadding,
    this.overlayColor = Colors.transparent,
    this.tooltipBackgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: keyValue,
      description: null,
      tooltipPadding: const EdgeInsets.all(1),
      tooltipBackgroundColor: tooltipBackgroundColor,
      overlayOpacity: isComeFromHome ? 0.0 : 0.9,
      blurValue: 0.0,
      overlayColor: isComeFromHome ? overlayColor : VisaColors.tutorialBgColor,
      enableAutoScroll: true,
      showArrow: false,
      // Responsible to scroll up and down
      scrollAlignment: context.screenHeight <= 700
          ? 0.36
          : isComeFromHome
              ? 0.4
              : 0.4,
      scrollLoadingWidget: const SizedBox.shrink(),
      targetBorderRadius: borderRadius,
      movingAnimationDuration: const Duration(milliseconds: 750),
      targetPadding: targetPadding ??
          const EdgeInsets.symmetric(
            horizontal: 20,
          ),
      child: child,
    );
  }
}
