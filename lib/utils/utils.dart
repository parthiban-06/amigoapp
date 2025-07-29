import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart' show AppRoutes;
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/responsive_util.dart';
import 'package:visaamigo/utils/test_style_util.dart';

import '../analytics/firebase_analytics_service.dart';
import '../custom_widgets/visa_custom_native_dialog.dart';
import '../custom_widgets/visa_textview.dart';
import '../features/select_languages/providers/language_selection_generic_provider.dart';
import '../generated/l10n.dart';
import 'local_auth_biometric.dart';

// Configuration class for custom dialog
class CustomDialogConfig {
  final String title;
  final String description;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String? dialogRouteName;
  final bool? disableCancel;

  const CustomDialogConfig(
      {required this.title,
      required this.description,
      required this.cancelText,
      required this.confirmText,
      this.onConfirm,
      this.onCancel,
      this.dialogRouteName,
      this.disableCancel});
}

class Utils {
  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  static Future<List> loadJson(String filePath) async {
    String data = await rootBundle.loadString(filePath);
    return json.decode(data) as List;
  }

  static Future<Map<String, dynamic>> loadJsonMap(String filePath) async {
    String data = await rootBundle.loadString(filePath);
    return json.decode(data);
  }

  static walletPopupTravelCredit(
      {required BuildContext context, required Widget child}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: VisaColors.black.withAlpha(128),
      builder: (BuildContext context) {
        return child;
      },
      routeSettings:
          const RouteSettings(name: AppRoutes.dialogWalletTravelCredit),
    );
  }

  static visaItineraryPopup(
      {required BuildContext context, required Widget child}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: VisaColors.black.withAlpha(128),
      builder: (BuildContext context) {
        return child;
      },
      routeSettings: const RouteSettings(name: AppRoutes.dialogVisaItinerary),
    );
  }

  static Future<DateTime?> pickDate(
      BuildContext context, DateTime selectedDateTime) async {
    return await showDatePicker(
      context: context,
      initialDate: selectedDateTime.isBefore(DateTime.now())
          ? DateTime.now()
          : selectedDateTime,
      locale: Provider.of<SelectLanguageGenericProvider>(context, listen: false)
          .locale,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      confirmText: S.of(context).ok,
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: VisaColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: theme.textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(color: Colors.grey),
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static Future<TimeOfDay?> pickTime(
      BuildContext context, TimeOfDay? time, bool is24hrsClockEnable) async {
    final rep = await showTimePicker(
      context: context,
      initialTime: time ?? TimeOfDay.now(),
      confirmText: S.of(context).ok,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final theme = Theme.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(alwaysUse24HourFormat: is24hrsClockEnable),
          child: Theme(
            data: theme.copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.white,
                hourMinuteTextColor: Colors.black,
                dayPeriodColor: VisaColors.primary,
                // dayPeriodSelectedColor: VisaColors.primary,
                dayPeriodTextStyle: TextStyle(
                  color: VisaColors.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                dayPeriodShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  side: BorderSide(color: VisaColors.primary),
                ),
                // dayPeriodSelectedTextStyle: TextStyle(
                //   color: Colors.white,
                //   fontSize: 14,
                //   fontWeight: FontWeight.w600,
                // ),
                dialHandColor: VisaColors.primary,
                dialBackgroundColor: Colors.white,
                entryModeIconColor: VisaColors.primary,
                hourMinuteColor: Color(0xFFE5E5E5),
                hourMinuteTextStyle: TextStyle(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                helpTextStyle: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              // textTheme: theme.textTheme.apply(
              //   fontSizeFactor: 1,
              //   bodyColor: Colors.black,
              //   displayColor: Colors.black,
              // ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (rep == null) return null;

    return rep;
    // final date = DateTime.now();
    //
    // return DateTime(date.year, date.month, date.day, rep.hour, rep.minute);
  }

  printIt(dynamic message) {
    if (kDebugMode) {
      // logPrint("${DateTime.now().toIso8601String()} :- $message");
    }
  }

  static void logPrint(var str) {
    if (kDebugMode) {
      final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
      pattern
          .allMatches(str.toString())
          .forEach((match) => print("logPrint ${match.group(0).toString()}"));
    }
  }

  static void logPrintAnalytics(var str) {
    // return;
    // if (kDebugMode) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(str.toString())
        .forEach((match) => print("${match.group(0).toString()}"));
    // }
  }

  static double getMaxScale(double fontSize) {
    if (fontSize < 10) return 2;
    if (fontSize < 14) return 1.7;
    if (fontSize < 20) return 1.4;
    return 1.3;
  }

  static double getCappedScale(BuildContext context, double fontSize) {
    final currentScale = MediaQuery.of(context).textScaler.scale(1);
    final maxAllowed = getMaxScale(fontSize);
    return currentScale > maxAllowed ? maxAllowed : currentScale;
  }

  static getFontSize(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1) > 1.29;
  }

  static bool compareVersions(String appVersion, String appConfigVersion) {
    final parts1 = appVersion.split('.').map(int.parse).toList();
    final parts2 = appConfigVersion.split('.').map(int.parse).toList();

    final maxLength =
        [parts1.length, parts2.length].reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < maxLength; i++) {
      final p1 = i < parts1.length ? parts1[i] : 0;
      final p2 = i < parts2.length ? parts2[i] : 0;

      if (p1 > p2) return false;
      if (p1 < p2) return true;
    }

    return false;
  }

  static void removeFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void showKeyboard(BuildContext context) {
    FocusScope.of(context).requestScopeFocus();
  }

  static deleteCompanionPopup(
      {required BuildContext context, required Widget child}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: VisaColors.black.withAlpha(128),
      builder: (BuildContext context) {
        return child;
      },
      routeSettings: const RouteSettings(name: AppRoutes.dialogDeleteCompanion),
    );
  }

  static rateUsPopup({required BuildContext context, required Widget child}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: VisaColors.black.withAlpha(128),
      builder: (BuildContext context) {
        return child;
      },
      routeSettings: const RouteSettings(name: AppRoutes.dialogRateUs),
    );
  }

  static String getErrorMessageFromString(String msgKey,
      {bool returnTryagain = false}) {
    if (msgKey.isNullOrEmpty) {
      return "";
    }
    String translatedText = Intl.message(msgKey);
    return (translatedText.isNullOrEmpty || translatedText == msgKey)
        ? (returnTryagain)
            ? Intl.message("try_again_only")
            : ""
        : translatedText;
  }

  static Future<bool> enableBioMetrics() async {
    return await AutoBiometricInit().authenticate();
  }

  static Future<bool> isBioMetricsSupported() async {
    if (kIsWeb) return false;
    final LocalAuthentication auth = LocalAuthentication();
    return (!(await auth.isDeviceSupported()) || ResponsiveUtil.isWeb);
  }

  static String convrtStringUtf(String msg) {
    return utf8
        .decode(RegExp(r'\\x([0-9a-fA-F]{2})')
            .allMatches(msg)
            .map((match) => int.parse(match.group(1)!, radix: 16))
            .toList())
        .trim();
  }

  static String encodeHexString(String? input) {
    final bytes = utf8.encode(input ?? "");
    final buffer = StringBuffer();
    for (var byte in bytes) {
      buffer.write('\\x${byte.toRadixString(16).padLeft(2, '0')}');
    }
    return buffer.toString();
  }

  static Future<String> getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return "${packageInfo.version} (${packageInfo.buildNumber})";
    } catch (e) {
      return "";
    }
  }

  static Future<void> logoutUser() async {
    await AmplifyService().signOutUser();
    AppRouter.router.go(AppRoutes.registeredEmail);
  }

  static String getDomainName(String url) {
    final uri = Uri.parse(url);
    String domain = uri.host;

    // Remove 'www.' if present
    if (domain.startsWith('www.')) {
      domain = domain.substring(4);
    }

    return domain;
  }

  static Future<void> openExternalApplication(
      String? url, String? deepLink) async {
    final Uri? deepUri =
        (deepLink?.isNotEmpty ?? false) ? Uri.tryParse(deepLink!) : null;
    final Uri? webUri = (url?.isNotEmpty ?? false) ? Uri.tryParse(url!) : null;

    try {
      if (deepUri != null && await canLaunchUrl(deepUri)) {
        await launchUrl(deepUri, mode: LaunchMode.externalApplication);
        return;
      }

      if (webUri != null && await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      }

      throw getErrorMessageFromString('could_not_launch');
    } catch (e) {
      debugPrint('🚨 Failed to open external application. Error: $e');
      rethrow;
    }
  }

  static Future<BiometricType?> getSupportedBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();

    bool isDeviceSupported = await auth.isDeviceSupported();
    if (!isDeviceSupported) {
      logPrint('Device does not support biometrics.');
      return null;
    }

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.face)) {
      logPrint('✅ Face ID is available (iOS)');

      return Platform.isAndroid
          ? BiometricType.fingerprint
          : BiometricType.face;
    } else if (availableBiometrics.contains(BiometricType.fingerprint) ||
        availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.iris) ||
        availableBiometrics.contains(BiometricType.weak)) {
      logPrint('✅ Touch ID / Fingerprint is available');
      return Platform.isAndroid
          ? BiometricType.fingerprint
          : BiometricType.face;
    } else {
      logPrint('❌ No biometrics available');
    }
    return null;
  }

  static openMaps(double latitude, double longitude) {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final String appleMapsUrl =
        'https://maps.apple.com/?q=$latitude,$longitude';

    return Platform.isIOS ? googleMapsUrl : googleMapsUrl;
  }

  static String formatUsd(String amountStr) {
    try {
      final number = double.parse(amountStr);
      final isWhole = number % 1 == 0;

      final formatter = NumberFormat.currency(
        locale: 'en_US',
        symbol: '\$',
        decimalDigits: isWhole ? 0 : 2,
      );

      return formatter.format(number);
    } catch (e) {
      return amountStr; // fallback in case of invalid input
    }
  }

  static String localNumber(BuildContext context, int value) {
    String localCode =
        Provider.of<SelectLanguageGenericProvider>(context, listen: false)
            .locale!
            .languageCode;

    formatNumber(1000.022, "hi_IN");

    return NumberFormat.decimalPattern("hi_IN").format(value);
  }

  static String formatNumber(double number, String locale) {
    try {
      return NumberFormat.decimalPattern(locale).format(number);
    } catch (e) {
      return 'Error formatting for $locale: $e';
    }
  }

  static String extractTimeZone(BuildContext context, String input) {
    final match = RegExp(r'([+-]\d{2}:\d{2})').firstMatch(input);
    final raw = match?.group(1) ?? '';

    if (raw == '+00:00' || raw == '-00:00') {
      return '+0 ${S.of(context).title_utc}';
    }

    return '$raw';
  }

  // Common Function To Announce Semantic Label
  static void announceMessage(String message) {
    SemanticsService.announce(
      message,
      ui.TextDirection.ltr,
    );
  }

  // Common function to announces semantics bottom navigation bar labels
  static String getSemanticsLabel(S s, int index, bool isSelected) {
    final tabLabels = [
      "${s.home_tab}, ${s.one_of_four}",
      "${s.eva_tab}, ${s.two_of_four}",
      "${s.itinerary_tab}, ${s.three_of_four}",
      "${s.tickets_tab}, ${s.four_of_four}",
    ];
    return "${tabLabels[index]}, ${isSelected ? s.selected : s.unselected}";
  }

  static Future<bool?> showCustomDialog(
      {required BuildContext context,
      required CustomDialogConfig config,
      bool? barrierDismissible}) async {
    SelectLanguageGenericProvider lanProvider =
        Provider.of<SelectLanguageGenericProvider>(context!, listen: false);

    // Create VisaDialogConfig from CustomDialogConfig
    final visaConfig = VisaDialogConfig(
      positiveButtonText: config.confirmText,
      negativeButtonText:
          config.disableCancel == true ? null : config.cancelText,
      onPositivePressed: () {
        config.onConfirm?.call();
        FirebaseAnalyticsService.logEventButtonClick(
            btnName: lanProvider.getKeyFromValue(config.confirmText));
      },
      onNegativePressed: () {
        config.onCancel?.call();
        FirebaseAnalyticsService.logEventButtonClick(
            btnName: lanProvider.getKeyFromValue(config.cancelText));
      },
      barrierDismissible: barrierDismissible ?? true,
      dialogRouteName: config.dialogRouteName?.isNotEmpty == true
          ? config.dialogRouteName
          : "${lanProvider.getKeyFromValue(config.title)}_dialog",
    );

    return VisaNativeDialog.show(
      context: context,
      title: config.title,
      message: config.description,
      config: visaConfig,
    );
  }

  /// Check current notification settings and return detailed status
  ///
  /// Returns a map containing:
  /// - authorizationStatus: Current authorization status
  /// - alert: Alert setting status
  /// - badge: Badge setting status
  /// - sound: Sound setting status
  /// - isGranted: Whether notifications are currently granted
  ///
  /// Example usage:
  /// ```dart
  /// final settings = await Utils.getNotificationSettings();
  /// print('Notifications granted: ${settings['isGranted']}');
  /// ```
  static Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();

      return {
        'authorizationStatus': settings.authorizationStatus.name,
        'alert': settings.alert.name,
        'badge': settings.badge.name,
        'sound': settings.sound.name,
        'isGranted':
            settings.authorizationStatus == AuthorizationStatus.authorized ||
                settings.authorizationStatus == AuthorizationStatus.provisional,
      };
    } catch (e) {
      Utils.logPrint('Error getting notification settings: $e');
      return {
        'authorizationStatus': 'unknown',
        'alert': 'unknown',
        'badge': 'unknown',
        'sound': 'unknown',
        'isGranted': false,
      };
    }
  }

  /// Build notification type item widget
  static Widget _buildNotificationTypeItem(
    BuildContext context,
    String title,
    String subtitle,
    bool isEnabled,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: VisaTextUtils.getVisaTextStyle(
                  VisaTextStyle.displayBodyL,
                  context: context,
                  isDarkMode: false,
                  fontFamily: VisaFontWeight.medium,
                  fontColor:
                      isEnabled ? VisaColors.black : VisaColors.textFieldBorder,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: VisaTextUtils.getVisaTextStyle(
                  VisaTextStyle.displayBodyS,
                  context: context,
                  isDarkMode: false,
                  fontFamily: VisaFontWeight.regular,
                  fontColor: VisaColors.textFieldBorder,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: isEnabled,
          onChanged: null, // Disabled for now, can be implemented later
          activeColor: VisaColors.primary,
        ),
      ],
    );
  }
}
