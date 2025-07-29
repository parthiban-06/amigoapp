import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../ui/base/base_provider.dart';

class ResponsiveUtil extends BaseProvider {
  BuildContext ctx;

  double? appBarTotalHeight;

  ResponsiveUtil(this.ctx) {
    appBarTotalHeight = MediaQuery.paddingOf(ctx).top + kToolbarHeight;
  }

  static bool get isWeb => kIsWeb;

  bool kISWeb() {
    return kIsWeb;
  }

  bool isMobile({BuildContext? context}) {
    context ??= ctx;

    return context.screenWidth < 600;
  }

  bool isTablet({BuildContext? context}) {
    context ??= ctx;
    return context.screenWidth >= 600 && context.screenWidth < 1200;
  }

  bool isDesktop({BuildContext? context}) {
    context ??= ctx;

    return context.screenWidth >= 1200 || isTablet(context: context);
  }

  bool isMobileWeb({BuildContext? context}) {
    context ??= ctx;
    return kISWeb() && isMobile(context: context);
  }

  double getResponsiveWidth(BuildContext context, double percentage) {
    return context.screenWidth * (percentage / 100);
  }

  Widget responsiveWrapper({
    required BuildContext context,
    required Widget mobileView,
    Widget? tabletView,
    Widget? desktopView,
  }) {
    if (isDesktop(context: context) && desktopView != null && isWeb) {
      return desktopView;
    }
    if (isTablet(context: context) && tabletView != null) {
      return tabletView;
    }
    return mobileView;
  }
}
