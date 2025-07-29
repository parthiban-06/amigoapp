import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'firebase_analytics_service.dart';

class FirebaseAnalyticsRouteObserver extends NavigatorObserver {
  final FirebaseAnalyticsService analyticsListener;

  FirebaseAnalyticsRouteObserver({required this.analyticsListener});

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = route.settings.name ??
        (route.settings.arguments is String
            ? route.settings.arguments as String
            : null) ??
        route.runtimeType.toString();

    Utils.logPrintAnalytics("Firebase Analytics Route didPop - $routeName");

    analyticsListener.onRouteChanged(routeName);

    super.didPop(route, previousRoute);
  }
}
