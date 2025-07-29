import 'package:flutter/material.dart';

import '../../../../../core/theme/theme.dart';
import '../shared/calendar_utils.dart' show TextFormatter;

/// Class containing styling and configuration of `TableCalendar`'s header.
class HeaderStyle {
  /// Responsible for making title Text centered.
  final bool titleCentered;

  /// Responsible for FormatButton visibility.
  final bool formatButtonVisible;

  /// Controls the text inside FormatButton.
  /// * `true` - the button will show next CalendarFormat
  /// * `false` - the button will show current CalendarFormat
  final bool formatButtonShowsNext;

  /// Use to customize header's title text (e.g. with different `DateFormat`).
  /// You can use `String` transformations to further customize the text.
  /// Defaults to simple `'yMMMM'` format (i.e. January 2019, February 2019, March 2019, etc.).
  ///
  /// Example usage:
  /// ```dart
  /// titleTextFormatter: (date, locale) => DateFormat.yM(locale).format(date),
  /// ```
  final TextFormatter? titleTextFormatter;

  /// Style for title Text (month-year) displayed in header.
  final TextStyle titleTextStyle;

  /// Style for FormatButton `Text`.
  final TextStyle formatButtonTextStyle;

  /// Background `Decoration` for FormatButton.
  final BoxDecoration formatButtonDecoration;

  /// Internal padding of the whole header.
  final EdgeInsets headerPadding;

  /// External margin of the whole header.
  final EdgeInsets headerMargin;

  /// Internal padding of FormatButton.
  final EdgeInsets formatButtonPadding;

  /// Outer padding of FormatButton.
  final EdgeInsets formatButtonOuterPadding;

  /// Internal padding of left chevron.
  /// Determines how much of ripple animation is visible during taps.
  final EdgeInsets leftChevronPadding;

  /// Internal padding of right chevron.
  /// Determines how much of ripple animation is visible during taps.
  final EdgeInsets rightChevronPadding;

  /// External margin of left chevron.
  final EdgeInsets leftChevronMargin;

  /// External margin of right chevron.
  final EdgeInsets rightChevronMargin;

  /// Widget used for left chevron.
  ///
  /// Tapping on it will navigate to previous calendar page.
  final Widget leftChevronIcon;

  /// Widget used for right chevron.
  ///
  /// Tapping on it will navigate to next calendar page.
  final Widget rightChevronIcon;

  /// Determines left chevron's visibility.
  final bool leftChevronVisible;

  /// Determines right chevron's visibility.
  final bool rightChevronVisible;

  /// Decoration of the header.
  final BoxDecoration decoration;

  /// External color of header date background.
  final Color headerDateBgColor;

  /// External radius of header date background.
  final double headerDateBgColorCornerRadius;

  /// External padding horizontal of header date background.
  final double headerDateHorizontalPadding;

  /// External padding vertical of header date background.
  final double headerDateVerticalPadding;

  /// Widget used for left chevron.
  ///
  /// Tapping on it will navigate to previous calendar page.
  final Widget dropDownBottomIcon;

  /// Widget used for left chevron.
  ///
  /// Tapping on it will navigate to previous calendar page.
  final Widget dropDownTopIcon;

  /// Responsible for making format button title Text centered.
  final bool formatButtonTitleCentered;

  /// Creates a `HeaderStyle` used by `TableCalendar` widget.
  const HeaderStyle({
    this.titleCentered = false,
    this.formatButtonTitleCentered = false,
    this.formatButtonVisible = true,
    this.formatButtonShowsNext = true,
    this.titleTextFormatter,
    this.titleTextStyle = const TextStyle(fontSize: 12.0),
    this.formatButtonTextStyle = const TextStyle(fontSize: 14.0),
    this.formatButtonDecoration = const BoxDecoration(
      border: Border.fromBorderSide(BorderSide()),
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
    this.headerMargin = const EdgeInsets.symmetric(vertical: 0.0),
    this.headerPadding = const EdgeInsets.symmetric(vertical: 5.0),
    this.formatButtonOuterPadding =
        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    this.formatButtonPadding =
        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    this.leftChevronPadding = const EdgeInsets.all(0.0),
    this.rightChevronPadding = const EdgeInsets.all(0.0),
    this.leftChevronMargin = const EdgeInsets.only(left: 5.0, right: 20.0),
    this.rightChevronMargin = const EdgeInsets.only(left: 15.0, right: 0.0),
    this.leftChevronIcon = const Icon(
      Icons.chevron_left,
      color: VisaColors.black,
    ),
    this.rightChevronIcon =
        const Icon(Icons.chevron_right, color: VisaColors.black),
    this.dropDownBottomIcon = const Icon(Icons.keyboard_arrow_down),
    this.dropDownTopIcon = const Icon(Icons.keyboard_arrow_up),
    this.leftChevronVisible = true,
    this.rightChevronVisible = true,
    this.decoration = const BoxDecoration(),
    this.headerDateBgColor = Colors.transparent,
    this.headerDateBgColorCornerRadius = 10.0,
    this.headerDateHorizontalPadding = 12.0,
    this.headerDateVerticalPadding = 8.0,
  });
}
