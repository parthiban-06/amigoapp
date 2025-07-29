import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../generated/l10n.dart';

class DateUtil {
  static bool _is24Time = true;

  static bool get is24Time => _is24Time;

  static set is24Time(bool value) {
    _is24Time = value;
  }

  static final DateFormat _standardDate = DateFormat('MM/dd/yyyy');

  // static final DateFormat _shortDate = DateFormat('MM/dd/yy');

  // static final DateFormat _fullDateWeekDay = DateFormat('EEEE, MMMM d, yyyy');
  // static final DateFormat _fullDate = DateFormat('MMMM d, yyyy');
  // static final DateFormat _timeOnly24hrs = DateFormat('HH:mm');
  // static final DateFormat _timeOnly = DateFormat('hh:mm a');
  // static final DateFormat _dateTime24hrs = DateFormat('MM/dd/yyyy HH:mm');
  // static final DateFormat _dateTime = DateFormat('MM/dd/yyyy hh:mm');
  // static final DateFormat _shortDateWeekDay = DateFormat('E');
  static final String DATE_FORMAT_WEEKDAY_DAY_MONTH = "EEEE, d MMMM";
  static final String DATE_FORMAT_YYYY_MM_DD = "yyyy-MM-dd";
  static const String TIME_FORMAT_12_HOUR = "hh:mm a";

  static String formatGetWithFormat(
          BuildContext context, DateTime date, String datetimeFormat,
          {bool addLocalisation = true}) =>
      DateFormat(
              datetimeFormat,
              addLocalisation
                  ? Localizations.localeOf(context).languageCode
                  : "en")
          .format(date);

  static String formatFull(BuildContext context, DateTime date) =>
      DateFormat('d MMMM yyyy', Localizations.localeOf(context).languageCode)
          .format(date);

  static String formatFullDateFirst(BuildContext context, DateTime date) =>
      DateFormat('dd/MM/yyyy', Localizations.localeOf(context).languageCode)
          .format(date);

  static String formatDateMonth(BuildContext context, DateTime date) =>
      DateFormat('d MMMM', Localizations.localeOf(context).languageCode)
          .format(date);

  // Format the DateTime to 'hh:mm a' (12-hour format with am/pm)
  static final DateFormat _formattedTime24Hrs = DateFormat(TIME_FORMAT_12_HOUR);
  static final DateFormat _formattedTime = DateFormat(TIME_FORMAT_12_HOUR);

  static String formatStandard(BuildContext context, DateTime date) =>
      DateFormat('MM/dd/yyyy', Localizations.localeOf(context).languageCode)
          .format(date);

  static String formatShort(BuildContext context, DateTime date) =>
      DateFormat('MM/dd/yy', Localizations.localeOf(context).languageCode)
          .format(date);

  // static String formatFull(DateTime date) => _fullDate.format(date);

  static String formatTime(BuildContext context, DateTime date) {
    return _is24Time
        ? DateFormat('HH:mm', Localizations.localeOf(context).languageCode)
            .format(date)
        : DateFormat(TIME_FORMAT_12_HOUR,
                Localizations.localeOf(context).languageCode)
            .format(date);
  }

  static String formatTimeItinerary(BuildContext context, DateTime date) {
    return _is24Time
        ? DateFormat('HH:mm', Localizations.localeOf(context).languageCode)
            .format(date)
        : DateFormat('hh:mm', Localizations.localeOf(context).languageCode)
            .format(date);
  }

  static String formatDateTime(BuildContext context, DateTime date) {
    final localDate = date.toLocal();
    return is24Time
        ? DateFormat('MM/dd/yyyy HH:mm',
                Localizations.localeOf(context).languageCode)
            .format(localDate)
        : DateFormat('MM/dd/yyyy hh:mm',
                Localizations.localeOf(context).languageCode)
            .format(localDate);
  }

  static String formattedTime(DateTime date) {
    final localDate = date.toLocal();

    return is24Time
        ? _formattedTime24Hrs.format(localDate)
        : _formattedTime.format(localDate);
  }

  static DateTime? tryParse(String date) {
    try {
      return _standardDate.parse(date);
    } catch (e) {
      return null;
    }
  }

  static String? getUtcTime() {
    try {
      return DateTime.now().toUtc().toIso8601String();
    } catch (e) {
      return "";
    }
  }

  static Duration getTimeDifference(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate);
  }

  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }

  // Returns a greeting string ("Morning", "Afternoon", "Evening", or "Night") based on the current hour.
  static String getTimeOfDayGreetingWithPreFix(
      BuildContext context, bool isPrefix) {
    final currentTime = DateTime.now();
    var hour = currentTime.hour;

    if (hour >= 5 && hour < 12) {
      return isPrefix ? S.of(context).good_morning : S.of(context).morning;
      // ? Utils.getErrorMessageFromString("good_morning")
      // : Utils.getErrorMessageFromString("morning");
    } else if (hour >= 12 && hour < 17) {
      return isPrefix ? S.of(context).good_afternoon : S.of(context).afternoon;
      // ? Utils.getErrorMessageFromString("good_afternoon")
      // : Utils.getErrorMessageFromString("afternoon");
    } else if (hour >= 17 && hour <= 4) {
      return isPrefix ? S.of(context).good_evening : S.of(context).evening;
      // ? Utils.getErrorMessageFromString("good_evening")
      // : Utils.getErrorMessageFromString("evening");
    } else {
      return isPrefix ? S.of(context).good_evening : S.of(context).evening;
      // ? Utils.getErrorMessageFromString("good_evening")
      // : Utils.getErrorMessageFromString("evening");
    }
  }

  //Different Length Abbreviations: Some languages do not use
  //two-letter abbreviations for weekdays. For example, in Korean:
  //English: "Mon" → "Mo"
  //Korean: "월" (one character, not two)
  //Non-Latin Characters: Some languages use full words instead of abbreviations,
  // and substring extraction may not be reliable.
  static String getShortDayOfWeek(BuildContext context, String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      String shortDay = DateFormat('E').format(date); // Mon, Tue, Wed...
      return shortDay.length > 2
          ? shortDay.substring(0, 2)
          : shortDay; // Take only first two letters: Mo, Tu, We
    } catch (e) {
      return S.of(context).invalid_date;
    }
  }

  static bool isStartTimeAfterEndTime(TimeOfDay startTime, TimeOfDay endTime) {
    return startTime.isAfter(endTime);
  }

  static bool isBetweenInclusive(DateTime check, DateTime start, DateTime end) {
    return (check.isAtSameMomentAs(start) || check.isAfter(start)) &&
        (check.isAtSameMomentAs(end) || check.isBefore(end));
  }

  // Function to map common names to IANA timezone identifiers
  static String mapTimezoneNameToIANA(String commonName) {
    // Map of common timezone names to IANA timezone database names
    Map<String, String> timezoneMap = {
      'Central Standard Time (Mexico)': 'America/Mexico_City',
      'Eastern Standard Time': 'America/New_York',
      'Pacific Standard Time': 'America/Los_Angeles',
      'Central European Time': 'Europe/Paris',
      'Greenwich Mean Time': 'Europe/London',
      'Japan Standard Time': 'Asia/Tokyo',
      // Add more mappings as needed
    };

    return timezoneMap[commonName] ?? commonName;
  }

  static String getTimezoneOffset(String timezoneName) {
    try {
      // Find the timezone location
      tz.Location location = tz.getLocation(timezoneName);

      // Get current time in that timezone
      tz.TZDateTime now = tz.TZDateTime.now(location);

      // Get the timezone offset in hours and minutes
      Duration offset = now.timeZoneOffset;

      // Format the offset as a string
      String offsetHours = (offset.inHours).toString().padLeft(2, '0');
      String offsetMinutes =
          (offset.inMinutes % 60).abs().toString().padLeft(2, '0');
      String offsetSign = offset.isNegative ? '' : '+';

      return '$offsetSign$offsetHours:$offsetMinutes';
    } catch (e) {
      return 'Timezone not found: $e';
    }
  }

  static String getFormattedOffset(int totalOffsetSeconds) {
    Duration offset = Duration(seconds: totalOffsetSeconds);

    String sign = offset.isNegative ? '-' : '+';
    int hours = offset.inHours.abs();
    int minutes = offset.inMinutes.abs() % 60;

    return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  static void initializeTimezones() {
    // Initialize the timezone database
    tz_data.initializeTimeZones();
  }

  // Function to calculate nights between two dates(checkIn/checkOut)
  static int? calculateNights(String checkIn, String checkout) {
    try {
      final checkInDate = DateTime.parse(checkIn);
      final checkoutDate = DateTime.parse(checkout);

      final duration = checkoutDate.difference(checkInDate);
      return duration.inDays;
    } catch (e) {
      return null;
    }
  }
}

extension DateChecks on DateTime {
  bool get isTodayOrFuture {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(year, month, day);
    return inputDate.isAtSameMomentAs(today) || inputDate.isAfter(today);
  }
}
