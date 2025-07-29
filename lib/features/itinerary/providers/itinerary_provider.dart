import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/features/itinerary/repo/itineary_repo.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/date_util.dart';
import 'package:visaamigo/utils/test_style_util.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/l10n.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/app_const.dart';
import '../../home/providers/navigation_provider.dart';
import '../../profile/provider/user_generic_detail_provider.dart';
import '../models/event_list_model.dart';
import '../screens/widgets/shared/calendar_utils.dart';
import '../screens/widgets/visa_calendar.dart';

class ItineraryProvider extends BaseProvider {
  CalendarFormat calendarFormat = CalendarFormat.week;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode
      .disabled; // Can be toggled on/off by long pressing a date
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay = DateTime.now();
  DateTime? rangeStart;
  DateTime? rangeEnd;
  double appBarTotalHeight = 0.0;

  Locale? locale;
  ItineraryRepo? itineraryRepo;

  Map<String, List<EventList>> itinearyMapList = {};

  List<EventList> selectedDateEvent = [];

  UserGenericProvider? userGeneric;

  // Flag to prevent multiple auto-scroll calls
  bool _hasAutoScrolled = false;

  // final ScrollController scrollController = ScrollController();

  List<Event> getEventsForDay(DateTime day) {
    if (itinearyMapList.containsKey(DateUtil.formatGetWithFormat(
        mContext, day, DateUtil.DATE_FORMAT_YYYY_MM_DD))) {
      return [const Event("")];
    } else {
      return [];
    }
  }

  TextStyle getDaysTextStyle(BuildContext context) {
    return VisaTextUtils.getVisaTextStyle(
      VisaTextStyle.displayBodyL,
      context: context,
      isDarkMode: false,
      lineHeight: 0.94,
      letterSpacing: 1,
      fontFamily: VisaFontWeight.medium,
      fontColor: VisaColors.primaryDark,
    );
  }

  TextStyle getDaysTitleTextStyle(BuildContext context) {
    return VisaTextUtils.getVisaTextStyle(
      VisaTextStyle.displayBodyXs,
      context: context,
      isDarkMode: false,
      lineHeight: 1.40,
      letterSpacing: 2,
      fontFamily: VisaFontWeight.medium,
      fontColor: VisaColors.primaryDark,
    );
  }

  void resetCalendarState() {
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    // Also reset other related fields if needed
    notifyListeners();
  }

  void onDaySelected(DateTime selectDay, DateTime focusDay) {
    // itineraryCreation.calenderDaySelect

    FirebaseAnalyticsService.logEvent(
        eventName: "itineraryCreation_calenderDaySelect",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
              AppRoutes.itineraryNav,
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "calender_select_date",
        });

    if (!isSameDay(selectedDay, selectDay)) {
      selectedDay = selectDay;
      focusedDay = focusDay;
      rangeStart = null; // Important to clean those
      rangeEnd = null;
      rangeSelectionMode = RangeSelectionMode.disabled;
      setState();
    }
    Utils.logPrint("onDaySelected ${selectDay} --${focusDay}");
    getEventFromSelectedDay();
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusDay) {
    selectedDay = null;
    focusedDay = focusDay;
    rangeStart = start;
    rangeEnd = end;
    rangeSelectionMode = RangeSelectionMode.disabled;

    Utils.logPrint("onRangeSelected ${start} --${end}");
    setState();
  }

  void onFormatChanged(CalendarFormat format) {
    if (calendarFormat != format) {
      calendarFormat = format;
      setState();
    }
  }

  void onNextYearClicked(DateTime date) {
    Utils.logPrint("kLastDay.year  ${kLastDay.year} --- ${date.year} ");
    if (kLastDay.year > date.year) {
      focusedDay = DateTime(date.year + 1, date.month, date.day);
      selectedDay = focusedDay;
      setState();
      getEventFromSelectedDay();
      Utils.logPrint("focusedDay $focusedDay");
    }
  }

  void onPreviousYearClicked(DateTime date) {
    if (kFirstDay.year < date.year) {
      focusedDay = DateTime(date.year - 1, date.month, date.day);
      selectedDay = focusedDay;
      setState();
      getEventFromSelectedDay();
      Utils.logPrint("focusedDay $focusedDay");
    }
  }

  void updateCalendarFormat() {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    calendarFormat = (calendarFormat == CalendarFormat.month)
        ? CalendarFormat.week
        : CalendarFormat.month;

    final state = (calendarFormat == CalendarFormat.week)
        ? S.of(context).collapsed
        : S.of(context).expanded;

    Utils.announceMessage(S.of(context).calendar + state);
    setState();

    Utils.logPrint("calendarFormat $calendarFormat");
  }

  void onNextDayClicked() {
    focusedDay = focusedDay.add(const Duration(days: 1));
    selectedDay = focusedDay;
    setState();
    getEventFromSelectedDay();
    FirebaseAnalyticsService.logEvent(
      eventName: "itineraryCreation_nextArrowDaySelected",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
            AppRoutes.itineraryNav,
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "next_arrowSelect_date",
      },
    );
  }

  void onPreviousDayClicked() {
    focusedDay = focusedDay.subtract(const Duration(days: 1));
    selectedDay = focusedDay;

    setState();
    getEventFromSelectedDay();
    // itineraryCreation.nextArrowDaySelected
    FirebaseAnalyticsService.logEvent(
      eventName: "itineraryCreation_prevArrowDaySelected",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
            AppRoutes.itineraryNav,
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "previous_arrowSelect_date",
      },
    );
  }

  Future<void> init(
      BuildContext context,
      SelectLanguageGenericProvider languageProvider,
      UserGenericProvider userGeneric) async {
    setContext(context);
    locale = languageProvider.locale;
    appBarTotalHeight = MediaQuery.paddingOf(context).top + kToolbarHeight;
    if (context.mounted) {
      setState();
    }

    fetchItineary();
  }

  /// Called when app is resumed/restored to ensure calendar shows nearest upcoming event
  void onAppResumed() {
    // Check if context is still valid before proceeding
    if (mContext == null || !mContext.mounted) {
      Utils.logPrint("Context is not valid, skipping auto-scroll");
      return;
    }

    if (itinearyMapList.isNotEmpty && !_hasAutoScrolled) {
      _scrollToNearestUpcomingEvent();
      getEventFromSelectedDay();
      _hasAutoScrolled = true;
    }
  }

  /// Called when app is first launched to ensure calendar shows nearest upcoming event
  void onAppLaunched() {
    // Check if context is still valid before proceeding
    if (mContext == null || !mContext!.mounted) {
      Utils.logPrint("Context is not valid, skipping auto-scroll");
      return;
    }

    // This will be called after fetchItineary completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mContext != null &&
          mContext!.mounted &&
          itinearyMapList.isNotEmpty &&
          !_hasAutoScrolled) {
        _scrollToNearestUpcomingEvent();
        getEventFromSelectedDay();
        _hasAutoScrolled = true;
      }
    });
  }

  // the calendar should automatically scroll to the nearest upcoming event
  /// Called when a new event is added to auto-scroll to the new event
  void onEventAdded(String eventDate) {
    // Check if context is still valid
    if (mContext == null || !mContext!.mounted) {
      Utils.logPrint("Context is not valid, skipping event auto-scroll");
      return;
    }

    try {
      final newEventDate = DateTime.parse(eventDate);
      // focusedDay = newEventDate;
      // selectedDay = newEventDate;
      // Utils.logPrint("Auto-scrolling to newly added event: $newEventDate");

      if (mContext != null && mContext!.mounted) {
        setState();
        getEventFromSelectedDay();
        // Reset flag for new events
        _hasAutoScrolled = false;
      }
    } catch (e) {
      Utils.logPrint("Error in onEventAdded: $e");
    }
  }

  void openAddToItineary() {
    FirebaseAnalyticsService.logEvent(
      eventName: AnalyticsEventConst.EVENT_NAME_ADD_ITINERARY,
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
            AppRoutes.itineraryNav,
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "add_new_event",
      },
    );

    navPush(AppRoutes.addItinerary,
        extra: {"date": focusedDay.toIso8601String()});
  }

  void openBookingcom() {
    // itineraryCreation.bookFlightAndHotelsLink

    final url = "${AppConst.bookingComLink}index.${locale?.languageCode}.html";

    if (!kIsWeb) {
      navPush(AppRoutes.redirecting, extra: {
        "url": url,
        "deeplink": "",
        "openInternalBrowser": true,
        "bottomMessage": S.of(getContext()).you_are_being_redirect_booking,
      });
    } else {
      Utils.openExternalApplication(url, "");
    }

    FirebaseAnalyticsService.logEvent(
      eventName: "itineraryCreation_bookFlightAndHotelsLink",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
            AppRoutes.itineraryNav,
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "book_flights_hotel_links",
      },
    );
  }

  void fetchItineary() async {
    isLoading = true;

    // Reset auto-scroll flag when fetching new data
    _hasAutoScrolled = false;

    itineraryRepo ??= ItineraryRepo(apiClient);

    final rep = await itineraryRepo!.getUsersEvent(
      EventList.fromDataJson,
    );
    itinearyMapList = {};
    selectedDateEvent = [];

    if (rep != null && rep.data != null) {
      for (var i in rep!.data!) {
        if (itinearyMapList.containsKey(i.eventDate)) {
          itinearyMapList[i.eventDate]!.add(i);
        } else {
          itinearyMapList[i.eventDate ?? ""] = [i];
        }
      }
    }
    setState();

    // the calendar should automatically scroll to the nearest upcoming event
    // Auto-scroll to nearest upcoming event after loading events
    _scrollToNearestUpcomingEvent();

    getEventFromSelectedDay();
    isLoading = false;
  }

  // the calendar should automatically scroll to the nearest upcoming event
  /// Finds and scrolls to the nearest upcoming event
  void _scrollToNearestUpcomingEvent() {
    // Check if context is still valid
    if (mContext == null || !mContext!.mounted) {
      Utils.logPrint("Context is not valid, skipping auto-scroll");
      return;
    }

    if (itinearyMapList.isEmpty) {
      // If no events, keep current date
      Utils.logPrint("No events found, keeping current date");
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentYear = now.year;

    Utils.logPrint("Looking for nearest upcoming event. Current date: $today");
    Utils.logPrint("Available events: ${itinearyMapList.keys.toList()}");

    // Find the nearest upcoming event
    DateTime? nearestEventDate;
    DateTime? nearestEventDateTime;

    for (final entry in itinearyMapList.entries) {
      // Skip entries with null or empty keys
      if (entry.key == null || entry.key.isEmpty) {
        continue;
      }

      final eventDate = DateTime.parse((entry.key));

      // Consider events that are today OR in the future (but not past)
      if (eventDate.isAfter(today) || eventDate.isAtSameMomentAs(today)) {
        // For events today, check if they haven't passed yet
        if (eventDate.isAtSameMomentAs(today)) {
          final events = entry.value;
          for (final event in events) {
            if (event.startTime != null && event.startTime!.isNotEmpty) {
              final timeString = event.startTime!.split(RegExp(r'[+-]')).first;
              final eventTime =
                  DateTime.parse("$currentYear-01-01T$timeString");
              final currentTime = DateTime.now();
              final currentTimeOnly = DateTime(
                  currentYear, 1, 1, currentTime.hour, currentTime.minute);

              // If event time is in the future today, this is our nearest event
              if (eventTime.isAfter(currentTimeOnly)) {
                nearestEventDate = eventDate;
                nearestEventDateTime = eventTime;
                Utils.logPrint("Found upcoming event today at $eventTime");
                break;
              }
            }
          }
        } else {
          // Future event, check if it's closer than current nearest
          if (nearestEventDate == null ||
              eventDate.isBefore(nearestEventDate)) {
            nearestEventDate = eventDate;
            // For future dates, use the first event of the day
            final events = entry.value;
            if (events.isNotEmpty &&
                events.first.startTime != null &&
                events.first.startTime!.isNotEmpty) {
              final timeString =
                  events.first.startTime!.split(RegExp(r'[+-]')).first;
              nearestEventDateTime =
                  DateTime.parse("$currentYear-01-01T$timeString");
            }
            Utils.logPrint("Found future event on $eventDate");
          }
        }
      }
    }

    // If we found a nearest upcoming event, scroll to it
    if (nearestEventDate != null) {
      focusedDay = nearestEventDate!;
      selectedDay = nearestEventDate;
      Utils.logPrint(
          "Auto-scrolling to nearest upcoming event: $nearestEventDate");

      // Check context again before calling setState
      if (mContext != null && mContext!.mounted) {
        setState();
      } else {
        Utils.logPrint("Context not valid for setState, skipping");
      }
    } else {
      // No upcoming events found, ensure we stay on today's date
      final today = DateTime.now();
      focusedDay = today;
      selectedDay = today;
      Utils.logPrint(
          "No upcoming events found, staying on today's date: $today");

      // Check context again before calling setState
      if (mContext != null && mContext!.mounted) {
        setState();
      } else {
        Utils.logPrint("Context not valid for setState, skipping");
      }
    }
  }

  void getEventFromSelectedDay() {
    // Check if context is still valid
    if (mContext == null || !mContext!.mounted) {
      Utils.logPrint("Context is not valid, skipping getEventFromSelectedDay");
      return;
    }

    try {
      var selectedDateString = DateUtil.formatGetWithFormat(
          mContext, focusedDay, DateUtil.DATE_FORMAT_YYYY_MM_DD,
          addLocalisation: false);

      Utils.logPrint("selectedDateString ${selectedDateString}");

      selectedDateEvent = itinearyMapList[selectedDateString] ?? [];

      //sorting event on start time
      final format = DateFormat("HH:mm");
      selectedDateEvent.sort((a, b) {
        final aTime = format.parse(a.startTime.substring(0, 5));
        final bTime = format.parse(b.startTime.substring(0, 5));
        return aTime.compareTo(bTime);
      });

      if (mContext != null && mContext!.mounted) {
        setState();
      }
    } catch (e) {
      Utils.logPrint("Error in getEventFromSelectedDay: $e");
    }
  }

  void openItineraryDetail(EventList? event) {
    //itineraryCreation.moreDetails
    FirebaseAnalyticsService.logEvent(
        eventName: "itineraryCreation_moreDetails",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "more_details",
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
              AppRoutes.itineraryNav,
        });

    navGo(AppRoutes.itineraryNavDetails, extra: event);
  }

  void scrollToTop() {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();
    if (context.mounted) {
      if (Provider.of<NavigationProvider>(context, listen: false)
          .tabScrollControllers[AppRoutes.itineraryScreenIndex]
          .hasClients) {
        Provider.of<NavigationProvider>(context, listen: false)
            .tabScrollControllers[AppRoutes.itineraryScreenIndex]
            .animateTo(
              0, // top of scroll view
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut, // smooth scrolling
            );
      }
    }
  }

  /// Reset the auto-scroll flag to allow auto-scroll again
  void resetAutoScrollFlag() {
    _hasAutoScrolled = false;
  }
}
