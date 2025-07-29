import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:visaamigo/core/config/env_config.dart';
import 'package:visaamigo/features/itinerary/models/itinerary_location_search_model.dart';
import 'package:visaamigo/features/itinerary/models/timezone_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/date_util.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../router/app_routes_const.dart';
import '../../../ui/base/base_provider.dart';

class LocationItineraryProvider extends BaseProvider {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchLocationText = TextEditingController();

  UserDetailRepo? userDetailRepo;
  String timezoneOffset = "";
  String languageCode = "";
  Timer? _debounce;
  PlaceResponse? placePredictions;

  Future<void> init(String? location) async {
    languageCode = await Preferences.getString(Preferences.keyLanguageCode);
    userDetailRepo = UserDetailRepo(apiClient);

    if (location != null && location.isNotEmpty) {
      searchLocationText.text = location;
      searchLocation();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  getTimeOffset(String str, Location location) async {
    isLoading = true;
    setState();
    try {
      final timeOffsetRep = await apiClient.get(
          endpoint: "",
          isDataNodePresent: false,
          fromJson: TimeZoneInfo.fromJson,
          addAuthHeader: false,
          customUrl:
              "https://maps.googleapis.com/maps/api/timezone/json?location=${location.lat},${location.lng}&timestamp=${DateTime.now().millisecondsSinceEpoch / 1000}&key=${EnvConfig.googlePlacesApiKey}");
      if (timeOffsetRep.isSuccess &&
          timeOffsetRep.data != null &&
          timeOffsetRep.data!.status != null &&
          timeOffsetRep.data!.status == AppConst.OK) {
        timezoneOffset = DateUtil.getFormattedOffset(
            (timeOffsetRep.data!.rawOffset ?? 0) +
                (timeOffsetRep.data!.dstOffset ?? 0));
        Navigator.of(getContext()).pop({
          "search": str,
          "timezoneOffset": timezoneOffset,
          "timeOffsetData": timeOffsetRep.data,
          "location": location
        });
      }
      isLoading = false;
      setState();
    } catch (e) {
      Utils.logPrint("Error: $e");
      isLoading = false;
      setState();
    }
  }

  clearSearch() {
    // itineraryCreation.locationSearch

    FirebaseAnalyticsService.logEvent(
        eventName: "itineraryCreation_LocationSearchClear",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
              AppRoutes.addItineraryLocation,
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "clear_search",
        });
    searchLocationText.text = "";
    placePredictions = null;
    setState();
  }

  searchLocation() async {
    setState();
    if (searchLocationText.text.isNotEmpty) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 50), () {
        _fetchSuggestions();
      });
    } else {
      placePredictions = null;
      setState();
    }
  }

  Future<void> _fetchSuggestions() async {
    final rep = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?query=${searchLocationText.text.trim()}&region=us&language=$languageCode&key=${EnvConfig.googlePlacesApiKey}"));
    if(rep.statusCode == 200 || rep.statusCode == 201){
      final json = jsonDecode(rep.body);
      placePredictions = PlaceResponse.fromJson(json);
      setState();
    }
    // final rep = await apiClient.get(
    //     endpoint: "",
    //     isDataNodePresent: false,
    //     fromJson: PlaceResponse.fromJson,
    //     addAuthHeader: false,
    //     customUrl:
    //         "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${searchLocationText.text.trim()}&region=us&language=$languageCode&key=${EnvConfig.googlePlacesApiKey}"
    //     // "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${searchLocationText.text.trim()}&types=(cities)&language=$languageCode&key=${EnvConfig.googlePlacesApiKey}"
    //     );
    // if (rep.data != null && rep.isSuccess) {
    //   placePredictions = rep.data;
    //   setState();
    // }
  }
}
