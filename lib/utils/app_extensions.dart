import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import 'utils.dart';

extension StringColorExtensions on String {
  Color toColor() => Color(Utils.getColorFromHex(this));
}

extension IsNullOrEmpty on String? {
  bool get isNullOrEmpty {
    return this == null ||
        this!.trim().isEmpty; // return true if string is empty or null
  }
}

// Navigation methods extension
extension NavigationExtensions on GoRouter {
  GoRouter get _router => AppRouter.router;

  Future pushRoute(
    String location, {
    Object? extra,
    TransitionType transition = TransitionType.slideRight,
  }) {
    return _router.push(location, extra: extra);
  }

  Future<T?> pushNamedRoute<T>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
    TransitionType transition = TransitionType.fade,
  }) {
    return _router.pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  void popRoute<T>([T? result]) {
    if (canPopRoute()) {
      _router.pop(result);
    }
  }

  void goRoute(
    String location, {
    Object? extra,
    TransitionType transition = TransitionType.fade,
  }) {
    _router.go(location, extra: extra);
  }

  void goNamedRoute(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
    TransitionType transition = TransitionType.fade,
  }) {
    _router.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  Future<T?> replaceRoute<T>(
    String location, {
    Object? extra,
    TransitionType transition = TransitionType.fade,
  }) {
    return _router.replace<T>(location, extra: extra);
  }

  Future<T?> replaceNamedRoute<T>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
    TransitionType transition = TransitionType.fade,
  }) {
    return _router.replaceNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  bool canPopRoute() => _router.canPop();

  void refreshRoute() => _router.refresh();

  // Replace `GoRouterState.of(this)` with correct access via the current state
  String get currentLocation => _router.currentLocation;

  RouteMatchList? get _currentConfiguration =>
      _router.routerDelegate.currentConfiguration;

  // Use `_router` to get the current route name via `GoRouterState`
  String? get currentRouteName => _currentConfiguration?.last.route.name;

  bool get canGoBack => _router.canPop();

  Map<String, String> get pathParameters =>
      _router.routerDelegate.currentConfiguration.pathParameters;

  Map<String, String> get queryParameters =>
      Uri.parse(currentLocation).queryParameters;

  Object? get extra => _router.routerDelegate.currentConfiguration.extra;
}

void _trackNavigationEvent(String action, String location, Object? extra) {
  try {
    // FirebaseAnalytics.instance.logEvent(
    //   name: 'navigation_action',
    //   parameters: {
    //     'action': action,
    //     'destination': location,
    //     // 'has_extra': extra ?? {},
    //   },
    // );
  } catch (e) {
    debugPrint('Failed to track navigation event: $e');
  }
}

extension MediaQueryExtension on BuildContext {
  // Get screen width
  double get screenWidth => MediaQuery.sizeOf(this).width;

  // Get screen height
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // Get the orientation (landscape or portrait)
  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  // Get text scaling factor (useful for adjusting text size)
  TextScaler get textScaleFactor => MediaQuery.textScalerOf(this);

  // Check if the device is in a low resolution (small screen)
  bool get isSmallScreen =>
      screenWidth < 600; // You can adjust the value as needed

  // Get screens insets to find the nearest MediaQuery ancestor
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  double get topPadding => MediaQuery.paddingOf(this).top;
}

extension TextEditingControllerExtension on TextEditingController {
  /// Returns trimmed text without unnecessary `.toString()` and `?? ''`
  String toTrimmedString() {
    return text.trim();
  }

  /// Returns true if the controller's trimmed text is empty or null
  bool get isEmpty => toTrimmedString().isEmpty;

  /// Returns true if the controller's trimmed text is not empty and not null
  bool get isNotEmpty => toTrimmedString().isNotEmpty;

  /// Clears the controller and sets it to an empty string
  void clearText() {
    clear();
  }

  /// Sets the controller's text to a trimmed version of its current text
  void trim() {
    text = toTrimmedString();
  }

  /// Returns the length of the trimmed text
  int get trimmedLength => toTrimmedString().length;
}

extension SafeListExtensions<T> on List<T>? {
  bool isLastIndex(int index) {
    if (this == null || this!.isEmpty) {
      return false; // ✅ Handle null or empty list safely
    }
    return index == this!.length - 1;
  }

  bool isLastItem(T item) {
    if (this == null || this!.isEmpty) {
      return false; // ✅ Handle null or empty list safely
    }
    int index = this!.indexOf(item);
    if (index == -1) {
      return false; // ✅ Item not found in the list
    }
    return index == this!.length - 1; // ✅ Check if it's the last item
  }

  bool isSecondLastItems(T item) {
    if (this == null || this!.length < 2) {
      return false; // ✅ Null or too short list
    }
    int index = this!.indexOf(item);
    if (index == -1) {
      return false; // ✅ Item not found
    }
    return index == this!.length - 2; // ✅ Check if it's at second last index
  }

  void removeLastTwo() {
    if (this == null || this!.length < 2) {
      return; // ✅ Handle null & short lists safely
    }
    this!.removeRange(this!.length - 2, this!.length);
  }
}

extension StringCasingExtension on String {
  String capitalizeEachWord() {
    return split(' ')
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
