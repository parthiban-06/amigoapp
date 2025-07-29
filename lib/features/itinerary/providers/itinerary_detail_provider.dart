import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/ui/base/base_provider.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utils.dart';
import '../../home/providers/navigation_provider.dart';
import '../models/event_list_model.dart';

class ItineraryDetailProvider extends BaseProvider {
  double appBarTotalHeight = 0.0;
  bool is24hrsClockEnable = true;

  Future<void> init(
    BuildContext context,
  ) async {
    appBarTotalHeight = MediaQuery.paddingOf(context).top + kToolbarHeight;
    is24hrsClockEnable = await Preferences.getBool(Preferences.KeyIs24Time);

    setState();

    Utils.logPrint("is24hrsClockEnable ${is24hrsClockEnable}");
  }

  void openMaps(double lat, double lng) {
    navPush(AppRoutes.redirecting, extra: {
      "url": Utils.openMaps(lat, lng),
      "bottomMessage": S.of(mContext).you_redirection_maps,
      "openInternalBrowser": false
    });
  }

  void openAddToItineary(EventList? eventDetail) {
    FirebaseAnalyticsService.logEvent(
        eventName: "itineraryCreation_editEvent",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
              AppRoutes.itineraryNav,
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "edit",
        });
    navPush(AppRoutes.addItinerary, extra: eventDetail);
  }

  void openEvaChat() {
    FirebaseAnalyticsService.logEvent(
        eventName: "itineraryCreation_exporeNearbyActivitiesLink",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
              AppRoutes.itineraryNav,
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "explore_activity_eva",
        });

    FirebaseAnalyticsService.logEvent(
      eventName: AnalyticsEventConst.EVENT_NAME_EVAASSISTANT_OPENED,
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
            AppRoutes.itineraryNav,
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: AppRoutes.evaNav,
      },
    );

    FirebaseAnalyticsService.logEvent(
      eventName: AnalyticsEventConst.EVENT_NAME_EVAASSISTANT_SCREENVIEWED,
    );

    Provider.of<NavigationProvider>(mContext, listen: false)
        .goBranch(AppRoutes.evaScreenIndex);
  }
}
