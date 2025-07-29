import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../customization/calendar_builders.dart';
import '../customization/calendar_style.dart';

class CellContent extends StatelessWidget {
  final DateTime day;
  final DateTime focusedDay;
  final String? locale;
  final bool isTodayHighlighted;
  final bool isToday;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isWithinRange;
  final bool isOutside;
  final bool isDisabled;
  final bool isHoliday;
  final bool isWeekend;
  final CalendarStyle calendarStyle;
  final CalendarBuilders calendarBuilders;

  const CellContent({
    super.key,
    required this.day,
    required this.focusedDay,
    required this.calendarStyle,
    required this.calendarBuilders,
    required this.isTodayHighlighted,
    required this.isToday,
    required this.isSelected,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isWithinRange,
    required this.isOutside,
    required this.isDisabled,
    required this.isHoliday,
    required this.isWeekend,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final dowLabel = DateFormat.EEEE(locale).format(day);
    final dayLabel = DateFormat.yMMMMd(locale).format(day);
    final semanticsLabel = '$dowLabel, $dayLabel';

    Widget? cell =
        calendarBuilders.prioritizedBuilder?.call(context, day, focusedDay);

    if (cell != null) {
      return Focus(
        focusNode: FocusNode(),
        child: Semantics(
          label: semanticsLabel,
          excludeSemantics: true,
          child: cell,
        ),
      );
    }

    final text = calendarStyle.dayTextFormatter?.call(day, locale) ??
        DateFormat.d(locale).format(day.toLocal());
    // final margin = calendarStyle.cellMargin;
    // final padding = EdgeInsets.zero;
    final alignment = calendarStyle.cellAlignment;
    const duration = Duration(milliseconds: 250);

    final margin = const EdgeInsets.all(2).r;
    final padding = const EdgeInsets.all(5).r;

    if (isDisabled) {
      cell = calendarBuilders.disabledBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.disabledDecoration,
            alignment: alignment,
            child: AutoSizeText(text,
                stepGranularity: 1,
                minFontSize: 5,
                style: calendarStyle.disabledTextStyle),
          );
    } else if (isSelected) {
      cell = calendarBuilders.selectedBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.selectedDecoration,
            alignment: alignment,
            child: AutoSizeText(text,
                stepGranularity: 1,
                minFontSize: 5,
                style: calendarStyle.selectedTextStyle),
          );
    } else if (isRangeStart) {
      cell =
          calendarBuilders.rangeStartBuilder?.call(context, day, focusedDay) ??
              AnimatedContainer(
                duration: duration,
                margin: margin,
                padding: padding,
                decoration: calendarStyle.rangeStartDecoration,
                alignment: alignment,
                child: AutoSizeText(text,
                    stepGranularity: 1,
                    minFontSize: 5,
                    style: calendarStyle.rangeStartTextStyle),
              );
    } else if (isRangeEnd) {
      cell = calendarBuilders.rangeEndBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.rangeEndDecoration,
            alignment: alignment,
            child: AutoSizeText(text,
                stepGranularity: 1,
                minFontSize: 5,
                style: calendarStyle.rangeEndTextStyle),
          );
    } else if (isToday && isTodayHighlighted) {
      cell = calendarBuilders.todayBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.todayDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.todayTextStyle),
          );
    } else if (isHoliday) {
      cell = calendarBuilders.holidayBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.holidayDecoration,
            alignment: alignment,
            child: AutoSizeText(text,
                stepGranularity: 1,
                minFontSize: 5,
                style: calendarStyle.holidayTextStyle),
          );
    } else if (isWithinRange) {
      cell =
          calendarBuilders.withinRangeBuilder?.call(context, day, focusedDay) ??
              AnimatedContainer(
                duration: duration,
                margin: margin,
                padding: padding,
                decoration: calendarStyle.withinRangeDecoration,
                alignment: alignment,
                child: AutoSizeText(text,
                    stepGranularity: 1,
                    minFontSize: 5,
                    style: calendarStyle.withinRangeTextStyle),
              );
    } else if (isOutside) {
      cell = calendarBuilders.outsideBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.outsideDecoration,
            alignment: alignment,
            child: AutoSizeText(text,
                stepGranularity: 1,
                minFontSize: 5,
                style: calendarStyle.outsideTextStyle),
          );
    } else {
      cell = calendarBuilders.defaultBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: isWeekend
                ? calendarStyle.weekendDecoration
                : calendarStyle.defaultDecoration,
            alignment: alignment,
            child: AutoSizeText(
              text,
              stepGranularity: 1,
              minFontSize: 5,
              style: calendarStyle.defaultTextStyle,
            ),
          );
    }

    return Focus(
      focusNode: FocusNode(),
      child: Semantics(
        label: semanticsLabel,
        excludeSemantics: true,
        child: cell,
      ),
    );
  }
}
